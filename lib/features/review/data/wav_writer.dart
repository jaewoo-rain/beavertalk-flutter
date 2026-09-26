import 'dart:typed_data';

/// 채점에 올릴 수 있는 최소 녹음 길이 — PCM16 · 16kHz · 모노 0.3초(9,600바이트).
///
/// 이보다 짧으면 서버(SpeechSuper 유료 채점)에 보내 봐야 0점대가 나온다. 보내지 않고 「너무 짧음」으로
/// 되돌린다. 발음 학습(learning_intro)과 취약 발음 평가(learn_test)가 같은 기준을 쓴다 — 예전엔
/// 취약 발음 평가만 빈 녹음만 걸러 0.1~0.3초 녹음도 유료 채점으로 나갔다(QA F011 · 09-26).
const int kMinScorablePcmBytes = 16000 * 2 * 3 ~/ 10;

/// [pcm] 이 [kMinScorablePcmBytes] 보다 짧은가(빈 녹음 포함).
bool isTooShortToScore(Uint8List pcm) => pcm.lengthInBytes < kMinScorablePcmBytes;

/// Wraps raw PCM16 audio bytes in a canonical 44-byte WAV (RIFF) header.
///
/// The recorder produces headerless little-endian PCM16; the backend expects a
/// proper WAV file (PCM16, mono) to transcode + score. Defaults match the
/// recorder config: 16000 Hz, mono, 16-bit.
///
/// Returns a single [Uint8List] of `header(44) + pcm`.
Uint8List pcm16ToWav(
  Uint8List pcm, {
  int sampleRate = 16000,
  int numChannels = 1,
  int bitsPerSample = 16,
}) {
  final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
  final int blockAlign = numChannels * (bitsPerSample ~/ 8);
  final int dataSize = pcm.lengthInBytes;
  final int riffSize = 36 + dataSize; // 4 + (8 + 16) + (8 + dataSize)

  final header = BytesBuilder();

  void writeString(String s) => header.add(s.codeUnits);
  void writeU32(int v) {
    final b = ByteData(4)..setUint32(0, v, Endian.little);
    header.add(b.buffer.asUint8List());
  }

  void writeU16(int v) {
    final b = ByteData(2)..setUint16(0, v, Endian.little);
    header.add(b.buffer.asUint8List());
  }

  // RIFF chunk descriptor.
  writeString('RIFF');
  writeU32(riffSize);
  writeString('WAVE');

  // fmt sub-chunk (PCM).
  writeString('fmt ');
  writeU32(16); // PCM fmt chunk size
  writeU16(1); // audio format = 1 (PCM)
  writeU16(numChannels);
  writeU32(sampleRate);
  writeU32(byteRate);
  writeU16(blockAlign);
  writeU16(bitsPerSample);

  // data sub-chunk.
  writeString('data');
  writeU32(dataSize);

  final out = BytesBuilder();
  out.add(header.toBytes());
  out.add(pcm);
  return out.toBytes();
}
