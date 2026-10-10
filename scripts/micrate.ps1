<#
  micrate.ps1 - 마이크 레이트를 **구간별로** 반복 샘플링한다.

  왜 반복인가: 어제 클라 MIC 계량기가 45/s -> 90/s 로 **계단**을 밟았다. 한 번만 재면
  평균이 계단을 먹어 「2배가 없다」로 잘못 닫힌다. 구간마다 따로 내야 계단이 보인다.

  두 계층을 같은 창에서 같이 잰다:
    HAL : AudioFlinger RECORD 스레드의 Frames read 델타 (앱과 무관)
    APP : 로그의 `mic → sent N frames` 델타 (Dart 소비/송신)
  갈라지면 원인이 갈린다 - HAL 1.0 인데 APP 2.0 이면 **소비자가 둘**이고,
  둘 다 2.0 이면 장치/클럭이다.

  사용법:  .\scripts\micrate.ps1 -Log <logcat파일> -Windows 20 -Every 30
#>
[CmdletBinding()]
param(
  [string]$Log,
  [int]$Windows = 20,
  [int]$Every = 30,
  [string]$Serial = 'emulator-5554'
)
$ErrorActionPreference = 'Continue'
$Adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

function Get-AllRec {
  $af = & $Adb -s $Serial shell dumpsys media.audio_flinger
  $res=@(); $cur=$null
  foreach ($l in $af) {
    if ($l -match 'Input thread \S+, name (\S+), tid (\d+), type 3 \(RECORD\)') {
      if($cur){$res+=$cur}
      $cur=[pscustomobject]@{name=$Matches[1];tid=$Matches[2];sr=$null;standby=$null;fr=$null}
      continue
    }
    if ($cur) {
      if ($l -match 'Standby:\s+(\w+)'    -and -not $cur.standby) { $cur.standby=$Matches[1] }
      if ($l -match 'Sample rate:\s+(\d+)'-and -not $cur.sr)      { $cur.sr=[int]$Matches[1] }
      if ($l -match 'Frames read:\s+(\d+)'-and -not $cur.fr)      { $cur.fr=[long]$Matches[1] }
    }
  }
  if($cur){$res+=$cur}
  ,$res
}
# 활성(standby=no) 스레드들의 Frames read 합. 스레드가 둘 이상 동시에 돌면 합이 2배가 된다.
function Sum-Active($rs) {
  $s=0; $n=0
  foreach ($r in $rs) { if ($r.standby -eq 'no' -and $r.fr -ne $null) { $s += $r.fr; $n++ } }
  [pscustomobject]@{ sum=$s; active=$n }
}
function Get-AppSent {
  if (-not $Log -or -not (Test-Path $Log)) { return $null }
  $m = Get-Content $Log -Encoding UTF8 | Select-String -Pattern 'mic → sent (\d+) frames' | Select-Object -Last 1
  if (-not $m) { return $null }
  if ($m.Line -match 'mic → sent (\d+) frames') { return [long]$Matches[1] }
  return $null
}

Write-Output ("{0,-9} {1,-7} {2,-9} {3,-11} {4,-9} {5,-11} {6}" -f '시각','활성','HAL Hz','HAL 배수','APP 건/s','APP 배수','판정')
Write-Output ('-' * 78)

$sw=[Diagnostics.Stopwatch]::StartNew()
$prevRec = Sum-Active (Get-AllRec); $prevApp = Get-AppSent; $prevT = $sw.Elapsed.TotalSeconds
for ($i=1; $i -le $Windows; $i++) {
  Start-Sleep -Seconds $Every
  $rs = Get-AllRec
  $rec = Sum-Active $rs
  $app = Get-AppSent
  $t   = $sw.Elapsed.TotalSeconds
  $dt  = $t - $prevT
  $halHz = if ($rec.sum -ge $prevRec.sum -and $dt -gt 0) { ($rec.sum - $prevRec.sum)/$dt } else { 0 }
  $halX  = $halHz/16000
  # 앱 쪽 실시간 기준: HAL 버퍼 352 frames(22ms) => 45.45 건/s
  $appPs = if ($null -ne $app -and $null -ne $prevApp -and $dt -gt 0) { ($app - $prevApp)/$dt } else { $null }
  $appX  = if ($null -ne $appPs) { $appPs/45.45 } else { $null }
  $mark = ''
  if ($halX -ge 1.5)                        { $mark += 'HAL 2배! ' }
  if ($null -ne $appX -and $appX -ge 1.5)   { $mark += 'APP 2배! ' }
  if ($rec.active -gt 1)                    { $mark += ('레코더 ' + $rec.active + '개! ') }
  if ($halX -lt 0.5)                        { $mark += '녹음 멈춤 ' }
  Write-Output ("{0,-9} {1,-7} {2,-9:N0} {3,-11:N3} {4,-9} {5,-11} {6}" -f `
    (Get-Date -Format 'HH:mm:ss'), $rec.active, $halHz, $halX, `
    $(if($null -ne $appPs){'{0:N1}' -f $appPs}else{'-'}), `
    $(if($null -ne $appX){'{0:N3}' -f $appX}else{'-'}), $mark)
  $prevRec=$rec; $prevApp=$app; $prevT=$t
}
Write-Output '완료.'
