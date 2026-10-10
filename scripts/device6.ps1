<#
  device6.ps1 - 통화 곡선 관측, 1커맨드.

  왜 스크립트인가: 케이블이 꽂힌 순간이 가장 비싼 시간이다. 그때 adb 경로를 찾고
  로그 필터를 정하고 파싱 정규식을 짜면 한 판이 통째로 날아간다.
  판정 기준은 **미리** 박아 둔다 - 사후에 정하면 끼워맞추게 된다.

  ⛔ 한 판은 **약 315초**다. 6분이 아니다. Free 플랜 통화 상한이 300초라
     (call_service.py:73-78, CALL_DURATION_S_BY_PLAN) 서버가 거기서 끊고,
     작별 인사까지 더해 315~320초가 된다. **이 도구로 본 것은 전부 5분 관측이다.**
     6분을 봤다고 쓰지 마라 - 곡선은 후반에 갈리는데 우리는 그 후반을 아직 못 봤다.
     15분이 필요하면 서버의 NORMAL_CALL_DURATION_S(core/config.py:123) 탈출구를 열어야 한다.

  사용법
    .\scripts\device6.ps1 -Start 1        # 1단계(둘 다 OFF) 캡처 시작 — 한 판 ~315초
    .\scripts\device6.ps1 -Start live     # 라이브 대조군
    .\scripts\device6.ps1 -Stop           # 통화 끝나면 - 캡처 종료 + 즉시 판정
    .\scripts\device6.ps1 -Analyze <경로> # 이미 받아둔 로그 재판정
    .\scripts\device6.ps1 -Install        # APK #4 설치(필요할 때만)

  [에뮬레이터] 받는다. 예전엔 「가상 마이크가 2배」라고 거부했지만 그 전제는 실측으로
     무너졌다(HAL 16,029Hz=1.002배, 통화 누적 0.98~1.00배 - 서버가 실기기에서 잰 0.98과 같다).
     ⚠ 다만 곡선의 **크기**는 다르다: 실기기 246초 1223ms  vs  에뮬 315초 367ms.
       방향·형태는 같고 크기는 작다. 그래서 로그 파일명에 EMU- 딱지가 붙는다 - 섞지 마라.

  ⚠ 이 파일은 UTF-8 BOM 으로 저장해야 한다(PowerShell 5.1 은 BOM 없으면 ANSI 로 읽어
    한글이 깨지고 파싱이 죽는다). 편집 후 BOM 이 살아 있는지 확인해라.
#>
[CmdletBinding()]
param(
  [string]$Start,
  [switch]$Stop,
  [string]$Analyze,
  [switch]$Install,
  # 남겨 둔 호환용 스위치. 에뮬레이터는 이제 기본으로 받는다(위 헤더 참고).
  [switch]$AllowEmulator
)

$ErrorActionPreference = 'Stop'

$Adb     = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$OutDir  = "$env:USERPROFILE\Desktop\beavertalkweb\logs"
$StateF  = Join-Path $OutDir '.device6-state.json'
$ApkPath = "$env:USERPROFILE\Desktop\beavertalkweb\apk\app-debug_순정캐스케이드_AEC-ON_20260813_4.apk"

# -- 판정 기준 (사전 등록) ---------------------------------------------------
$Criteria = @(
  [pscustomobject]@{
    Name = '빈채널왕복(ping)'
    Good = '5분(300초) 시점 20ms 이하, 평평'
    Bad  = '5분(300초) 시점 500ms 초과, 우상향'
    Why  = '[주판정] Dart->네이티브 빈 호출 왕복. 네이티브 핸들러 자체는 0~3ms 로 평평한 것이 확인됐으므로, 이게 자라면 적체는 안드로이드 플랫폼(main) 스레드다. 실기기 기존값 4ms -> 2128ms'
  }
  [pscustomobject]@{
    Name = 'fed/elapsed'
    Good = '95~105% 유지'
    Bad  = '85% 미만으로 하락'
    Why  = '⛔ **대화가 있는 판에서만 읽어라.** 이 값은 (보낸 오디오 / 벽시계)라 비버가 말을 안 하면 당연히 낮게 나온다 - 조용한 판(에뮬은 호스트 마이크가 무음이라 턴이 거의 없다)에서 이 값으로 「이상」을 내면 전부 거짓 양성이다. 교차 확인: 재생이 진짜 못 따라갔으면 engine min 이 0ms 로 말라야 한다. 둘이 반대로 말하면 이 항목이 틀린 것이다(2026-08-13 실측: 70~79% 인데 engine min 0ms 는 0회). 주판정은 핑 곡선, 체감은 발화중구멍이다.'
  }
  [pscustomobject]@{
    Name = '마이크 평균간격'
    Good = '22.3ms (한 프레임 704B = 352샘플 = 16kHz)'
    Bad  = '11ms 근처 = 두 배 속도 캡처 → **그 판은 버린다**'
    Why  = '[측정 유효성 게이트] 2026-08-14 실측: 에뮬 오디오 HAL 이 16kHz 라고 선언해 놓고 실제로는 32,322Hz(2.020배)로 읽는 상태에 빠질 수 있다. 통화 도중 45/s -> 90/s 로 계단을 밟고 그 뒤 통화 내내 유지된다. 입력이 2배면 서버 부하·턴 구조가 통째로 달라져 다른 항목을 못 읽는다. ⭐ KB/s 가 아니라 **간격**을 보는 이유: 무음에서도 돈다(내용 비교는 무음이면 100%로 붙어 못 쓴다). ⚠ 방아쇠는 미상이고 빌드·턴구조와 무관하다(같은 APK 가 어제는 정상, 오늘은 계단). 그래서 판마다 확인해야 한다 - 어제 정상이었으니 오늘도 정상이 안 통한다'
  }
  [pscustomobject]@{
    Name = '오디오/통화시간 배수'
    Good = '0.95~1.05'
    Bad  = '1.2 초과'
    Why  = 'rx(초) / elapsed(초). 서버가 실시간보다 빠르게 밀어넣는지. 캐스케이드 기존값 1.04'
  }
  [pscustomobject]@{
    Name = '발화중구멍'
    Good = '5분에 1.0초 미만'
    Bad  = '3.0초 초과'
    Why  = '비버가 말하는 중 무음을 넣은 시간 = 사장님이 실제로 듣는 끊김. 다른 지표가 나빠도 이게 0이면 체감은 멀쩡하다'
  }
  [pscustomobject]@{
    Name = 'cushion grew'
    Good = '0~2회'
    Bad  = '상한(1200ms) 도달'
    Why  = '[주의] 이건 클라 혼잡을 못 본다 - 큐가 빈 경우에만 오르므로 상류(서버 공백/네트워크) 신호다. 서버 2.44초 공백 수정 배포 후 이 횟수가 줄면 그 수정이 들은 것'
  }
  [pscustomobject]@{
    Name = 'engine min'
    Good = '120ms 이상 유지'
    Bad  = '0ms 가 반복'
    Why  = '네이티브 엔진 최저 잔량. 0 이 반복되면 엔진이 말랐다 = feed 가 못 닿았다'
  }
)

function Show-Criteria {
  Write-Output ''
  Write-Output '=== 판정표 (사전 등록, 측정 전에 고정) ============================='
  foreach ($c in $Criteria) {
    Write-Output ''
    Write-Output ("  [{0}]" -f $c.Name)
    Write-Output ("    정상 : {0}" -f $c.Good)
    Write-Output ("    이상 : {0}" -f $c.Bad)
    Write-Output ("    의미 : {0}" -f $c.Why)
  }
  Write-Output ''
  Write-Output '==================================================================='
}

function Get-PhoneSerial {
  if (-not (Test-Path $Adb)) { throw "adb 를 못 찾았다: $Adb" }
  $lines = & $Adb devices | Select-Object -Skip 1 | Where-Object { $_ -match '\S' }
  $phones = @()
  $emus   = @()
  foreach ($l in $lines) {
    $parts = $l -split '\s+'
    if ($parts.Count -lt 2) { continue }
    $serial = $parts[0]; $state = $parts[1]
    if ($state -ne 'device') { continue }
    if ($serial -like 'emulator-*') { $emus += $serial } else { $phones += $serial }
  }
  if ($phones.Count -eq 0) {
    if ($emus.Count -gt 0) {
      # 2026-08-13: 「에뮬 가상 마이크가 2배」라는 전제는 실측으로 무너졌다.
      #   HAL RECORD 스레드 Frames read 실측 16,029Hz(=1.002배)이고, 통화 누적도 0.98~1.00배로
      #   서버가 실기기에서 잰 0.98 과 같은 자리다. 그래서 에뮬을 거부하지 않는다.
      # ⚠ 다만 **강도**는 다르다 - 실기기 246초에 1223ms 였는데 에뮬은 315초에 367ms 다.
      #   방향·형태는 같고 크기는 작다. 그래서 EMU- 딱지는 유지한다: 실기기 수치와 섞지 마라.
      Write-Warning '[에뮬] 에뮬레이터로 잰다. 곡선의 방향은 실기기와 같지만 크기는 더 작다 - 실기기 수치와 같은 표에 놓지 마라.'
      return $emus[0]
    }
    throw "[거부] 붙은 기기가 없다. 폰 케이블을 꽂고 화면 잠금을 풀어라(USB 디버깅 허용 팝업이 뜰 수 있다)."
  }
  if ($phones.Count -gt 1) { throw "폰이 여러 대다: $($phones -join ', '). 한 대만 남겨라." }
  return $phones[0]
}

# -- -Install ----------------------------------------------------------------
if ($Install) {
  $serial = Get-PhoneSerial
  if (-not (Test-Path $ApkPath)) { throw "APK 가 없다: $ApkPath" }
  # 한글 파일명 + adb 는 예전에 실패했다 -> ASCII 임시 경로로 복사해서 설치한다.
  $tmp = Join-Path $env:TEMP 'bt6.apk'
  Copy-Item $ApkPath $tmp -Force
  Write-Output "설치 중 ($serial) ..."
  & $Adb -s $serial install -r $tmp
  Remove-Item $tmp -Force
  Write-Output '설치 끝.'
  return
}

# -- -Start ------------------------------------------------------------------
if ($Start) {
  $serial = Get-PhoneSerial
  if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }

  # 이전 캡처가 살아 있으면 먼저 정리 (로그 두 개가 한 파일에 섞이면 판정이 깨진다)
  if (Test-Path $StateF) {
    $old = Get-Content $StateF -Raw | ConvertFrom-Json
    try { Stop-Process -Id $old.pid -Force -ErrorAction Stop } catch {}
    Remove-Item $StateF -Force
    Write-Output '(이전 캡처를 정리했다)'
  }

  $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
  # 딱지는 **파일명에** 박는다. 헤더에만 두면 파일을 옮겨 붙일 때 떨어져 나간다.
  $tag   = if ($serial -like 'emulator-*') { 'EMU-' } else { '' }
  $log   = Join-Path $OutDir ("{0}stage-{1}_{2}.log" -f $tag, $Start, $stamp)

  & $Adb -s $serial logcat -c
  # ⛔ 2026-08-14: flutter 태그만 잡으면 Choreographer 의 Skipped N frames 와
  #   OpenGLRenderer 의 Davey! 가 통째로 빠진다. 그 둘이 「안드로이드 메인 스레드가
  #   막혔다」의 유일한 외부 증거인데, 12분 판에서 0건으로 나와 「없다」로 읽을 뻔했다.
  #   실제로는 **캡처가 안 된 것**이었다(계측 부재를 부재로 읽는 함정).
  # ⛔ 2026-08-15: 같은 함정을 아바타 쪽에서 한 번 더 닫는다. 단계 2·3 은 ExoPlayer 가
  #   도는 판인데 코덱 태그를 안 잡으면 **화면이 얼어붙어도 로그에 아무 증거가 없다**.
  #   아바타는 육안 판정이 원칙이지만(하드웨어 오버레이라 screencap 이 검게 나온다),
  #   「얼었다」를 봤을 때 그 원인이 디코더인지 가릴 외부 증거는 이 태그들뿐이다.
  # ⚠ 인자 목록 사이에 주석을 끼워 넣지 마라 — 백틱 줄바꿈 뒤 주석은 파싱이 깨진다.
  $logcatArgs = @('-s', $serial, 'logcat', '-s', 'flutter:V', 'Choreographer:V', 'OpenGLRenderer:V', 'MediaCodec:V', 'ExoPlayerImplInternal:V', 'ACodec:V', 'CCodec:V', 'OMXClient:V')
  $p = Start-Process -FilePath $Adb -ArgumentList $logcatArgs -NoNewWindow -PassThru -RedirectStandardOutput $log

  @{ pid = $p.Id; log = $log; stage = $Start; serial = $serial } |
    ConvertTo-Json | Set-Content $StateF -Encoding utf8

  Write-Output ''
  Write-Output "[OK] 캡처 시작 - 단계 [$Start] / 기기 $serial"
  Write-Output "   로그: $log"
  Write-Output ''
  Write-Output '   이제 폰에서:'
  Write-Output '     1) 마이페이지 -> 개발자 도구 에서 이번 단계의 스위치를 맞춘다'
  Write-Output '        (통화 들어가기 전에. 통화 중 변경은 측정을 섞는다)'
  Write-Output '          단계 1 = 둘 다 OFF   단계 2 = 아바타만 ON   단계 3 = 둘 다 ON'
  Write-Output '          live   = 라이브 통화(벗기지 않은 제품 그대로 - 대조군)'
  Write-Output '     2) 통화 시작 -> 끝까지 (Free 플랜은 300초에서 서버가 끊는다 = 약 315초)'
  Write-Output '     3) 끊고 나서:  .\scripts\device6.ps1 -Stop'
  Show-Criteria
  return
}

# -- 판정 --------------------------------------------------------------------
function Invoke-Judge([string]$path) {
  if (-not (Test-Path $path)) { throw "로그가 없다: $path" }
  $text = Get-Content $path -Encoding UTF8

  $inflate = @()
  foreach ($l in $text) {
    if ($l -match 'INFLATE: elapsed ([\d.]+)s') {
      $row = [ordered]@{ elapsed = [double]$Matches[1]; rx = $null; fedPct = $null; queueB = $null; pingMs = $null; holeS = $null }
      if ($l -match 'rx ([\d.]+)s')        { $row.rx     = [double]$Matches[1] }
      if ($l -match 'fed/elapsed (\d+)%')  { $row.fedPct = [int]$Matches[1] }
      if ($l -match 'queue (\d+)B')        { $row.queueB = [int]$Matches[1] }
      if ($l -match '빈채널왕복 (\d+)ms')   { $row.pingMs = [int]$Matches[1] }
      if ($l -match '발화중구멍 ([\d.]+)s') { $row.holeS  = [double]$Matches[1] }
      $inflate += [pscustomobject]$row
    }
  }
  if ($inflate.Count -eq 0) {
    Write-Output '[실패] INFLATE 줄이 0건이다. 통화가 안 열렸거나 릴리즈 빌드(로그가 컴파일 아웃)다.'
    return
  }

  $micKB  = @(); foreach ($l in $text) { if ($l -match 'MIC: .*?([\d.]+)KB/s')   { $micKB  += [double]$Matches[1] } }
  # ⭐ 2026-08-14: 유효성 게이트를 KB/s -> **평균간격**으로 갈았다. 무음에서도 돌기 때문이다.
  $micGap = @(); foreach ($l in $text) { if ($l -match '평균간격 ([\d.]+)ms')     { $micGap += [double]$Matches[1] } }
  $engMin = @(); foreach ($l in $text) { if ($l -match 'PUMP: .*min (-?\d+)ms') { $engMin += [int]$Matches[1] } }
  $grew   = @($text | Where-Object { $_ -match 'cushion grew' })
  $starve = @($text | Where-Object { $_ -match 'starved! #' })
  $lastCushion = $null
  foreach ($l in $text) { if ($l -match 'cushion grew .* (\d+)ms') { $lastCushion = [int]$Matches[1] } }

  $last  = $inflate[-1]
  $first = $inflate[0]
  $early = @($inflate | Where-Object { $_.elapsed -le 60 -and $null -ne $_.pingMs })
  $pingEarly = if ($early.Count) { ($early | Measure-Object pingMs -Average).Average } else { $null }
  $pingLast  = $last.pingMs
  $micAvg    = if ($micKB.Count)  { ($micKB | Measure-Object -Average).Average } else { $null }
  $ratio     = if ($last.rx -and $last.elapsed) { $last.rx / $last.elapsed } else { $null }
  $engZero   = @($engMin | Where-Object { $_ -eq 0 }).Count

  Write-Output ''
  if ((Split-Path $path -Leaf) -like 'EMU-*') {
    Write-Output '*******************************************************************'
    Write-Output '  [에뮬] 에뮬레이터 판이다. 곡선의 방향은 실기기와 같지만 크기가 더 작다.'
    Write-Output '  실기기 246초 1223ms  vs  에뮬 315초 367ms. 같은 표에 놓고 비교하지 마라.'
    Write-Output '*******************************************************************'
  }
  Write-Output ("=== 판정 : {0} ===" -f (Split-Path $path -Leaf))
  Write-Output ("  통화 길이 : {0:N1}초   (INFLATE 창 {1}개)" -f $last.elapsed, $inflate.Count)
  if ($last.elapsed -lt 290) { Write-Output '  [경고] 290초에 못 미친다. 통화가 상한(315초) 전에 끊겼다 - 다시 재라.' }
  Write-Output ''

  function Write-Verdict($name, $value, $fmt, $isGood, $isBad, $note) {
    if ($null -eq $value)  { $mark = '?      ' }
    elseif ($isBad)        { $mark = '이상 <<<' }
    elseif ($isGood)       { $mark = '정상' }
    else                   { $mark = '경계' }
    $v = if ($null -eq $value) { '측정없음' } else { ($fmt -f $value) }
    Write-Output ("  {0,-22} {1,-14} {2}" -f $name, $v, $mark)
    if ($note) { Write-Output ("  {0,-22}   - {1}" -f '', $note) }
  }

  $pe = if ($null -ne $pingEarly) { '{0:N0}ms' -f $pingEarly } else { '?' }
  $pl = if ($null -ne $pingLast)  { "${pingLast}ms" }          else { '?' }
  Write-Verdict '빈채널왕복(마지막)' $pingLast '{0}ms' `
    ($null -ne $pingLast -and $pingLast -le 20) ($null -ne $pingLast -and $pingLast -gt 500) `
    ("초반 60초 평균 {0} -> 마지막 {1}   [주판정]" -f $pe, $pl)

  # ⛔ 조용한 판에서는 이 항목으로 「이상」을 내지 않는다. engine min 이 한 번도 0 이 아니면
  #    재생은 안 말랐다는 뜻이고, 낮은 fed/elapsed 는 「말할 게 없었다」는 뜻이다.
  $quiet = ($engZero -eq 0)
  Write-Verdict 'fed/elapsed(마지막)' $last.fedPct '{0}%' `
    ($null -ne $last.fedPct -and $last.fedPct -ge 95 -and $last.fedPct -le 105) `
    ($null -ne $last.fedPct -and $last.fedPct -lt 85 -and -not $quiet) `
    ($(if ($quiet) {
        "초반 {0}% -> 마지막 {1}%   ⛔ engine min 0ms 가 0회 = 엔진이 안 말랐다. 이 판은 대화가 적어 이 값을 읽으면 안 된다" -f $first.fedPct, $last.fedPct
      } else {
        "초반 {0}% -> 마지막 {1}%" -f $first.fedPct, $last.fedPct
      }))

  # ⛔ 이 항목이 「이상」이면 **다른 항목을 읽지 마라.** 입력이 2배인 판이다.
  $gapAvg = if ($micGap.Count) { ($micGap | Measure-Object -Average).Average } else { $null }
  Write-Verdict '마이크 평균간격' $gapAvg '{0:N1}ms' `
    ($null -ne $gapAvg -and $gapAvg -ge 20.0) `
    ($null -ne $gapAvg -and $gapAvg -lt 16.0) `
    '기준 22.3ms(=16kHz). 11ms 근처면 HAL 이 2배로 읽는 상태다 - **이 판은 버리고 다른 항목을 읽지 마라**'
  Write-Verdict 'MIC 평균(참고)' $micAvg '{0:N1} KB/s' `
    ($null -ne $micAvg -and $micAvg -ge 29.7 -and $micAvg -le 32.8) `
    ($null -ne $micAvg -and $micAvg -ge 60) `
    '기준 31.3 KB/s. ⚠ 무음이어도 값은 나오지만, 계기 없는 빌드에서는 측정없음으로 뜬다'

  Write-Verdict '오디오/통화시간' $ratio '{0:N2}배' `
    ($null -ne $ratio -and $ratio -ge 0.95 -and $ratio -le 1.05) `
    ($null -ne $ratio -and $ratio -gt 1.2) $null

  Write-Verdict '발화중구멍(누적)' $last.holeS '{0:N1}초' `
    ($null -ne $last.holeS -and $last.holeS -lt 1.0) `
    ($null -ne $last.holeS -and $last.holeS -gt 3.0) `
    '사장님이 실제로 듣는 끊김'

  $cnote = if ($lastCushion) { "마지막 쿠션 ${lastCushion}ms" } else { '성장 없음' }
  Write-Verdict 'cushion grew' $grew.Count '{0}회' `
    ($grew.Count -le 2) ($lastCushion -eq 1200) `
    ("{0}. 주의: 이 지표는 클라 혼잡을 못 본다(상류 신호)" -f $cnote)

  Write-Verdict 'engine min 0ms' $engZero '{0}회' ($engZero -eq 0) ($engZero -gt 3) `
    ("PUMP 창 {0}개 중" -f $engMin.Count)

  Write-Verdict '굶음 로그' $starve.Count '{0}회' ($starve.Count -eq 0) ($starve.Count -gt 5) $null

  Write-Output ''
  Write-Output '  --- 핑 곡선 (30초 간격) ---'
  $prev = -999.0
  foreach ($r in $inflate) {
    if ($null -eq $r.pingMs) { continue }
    if ($r.elapsed - $prev -lt 30) { continue }
    $prev = $r.elapsed
    $bar = '#' * [Math]::Min(60, [Math]::Max(1, [int]([Math]::Sqrt($r.pingMs) * 2)))
    Write-Output ("   {0,6:N0}s  {1,6}ms  {2}" -f $r.elapsed, $r.pingMs, $bar)
  }
  Write-Output ''
  Write-Output '  => 곡선이 평평하면: 이 구성엔 범인이 없다. 다음 단계를 켜라.'
  Write-Output '  => 우상향하면    : 방금 켠 것이 범인이다.'
  Write-Output '==================================================================='
}

if ($Analyze) { Invoke-Judge $Analyze; return }

if ($Stop) {
  if (-not (Test-Path $StateF)) { throw '진행 중인 캡처가 없다. 먼저 -Start 를 써라.' }
  $st = Get-Content $StateF -Raw | ConvertFrom-Json
  try { Stop-Process -Id $st.pid -Force -ErrorAction Stop } catch {}
  Remove-Item $StateF -Force
  Start-Sleep -Milliseconds 300
  Write-Output "캡처 종료 - 단계 [$($st.stage)]"
  Invoke-Judge $st.log
  Write-Output ''
  Write-Output "원본 로그: $($st.log)"
  return
}

Write-Output @'
device6.ps1 - 통화 곡선 관측 (한 판 약 315초)

  .\scripts\device6.ps1 -Install        APK #4 설치
  .\scripts\device6.ps1 -Start 1        1단계(둘 다 OFF) 캡처 시작
  .\scripts\device6.ps1 -Start 2        2단계(아바타 ON)
  .\scripts\device6.ps1 -Start 3        3단계(힌트도 ON)
  .\scripts\device6.ps1 -Start live     라이브 대조군  <- 빠뜨리지 마라

  ⚠ 한 판은 6분이 아니라 약 315초다. Free 플랜 통화 상한이 300초(call_service.py:73-78)라
     서버가 거기서 끊는다. 이 도구로 본 것은 전부 5분 관측이다 - 6분을 봤다고 쓰지 마라.
  .\scripts\device6.ps1 -Stop           캡처 종료 + 즉시 판정
  .\scripts\device6.ps1 -Analyze <log>  이미 받은 로그 재판정
'@
Show-Criteria
