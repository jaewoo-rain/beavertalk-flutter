import 'dart:typed_data';

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
