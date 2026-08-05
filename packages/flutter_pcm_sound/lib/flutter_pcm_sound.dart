import 'dart:math' as math;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

enum LogLevel {
  none,
  error,
  standard,
  verbose,
}

// Apple Documentation: https://developer.apple.com/documentation/avfaudio/avaudiosessioncategory
enum IosAudioCategory {
  soloAmbient, // same as ambient, but other apps will be muted. Other apps will be muted.
  ambient, // same as soloAmbient, but other apps are not muted.
  playback, // audio will play when phone is locked, like the music app
  playAndRecord //
}

class FlutterPcmSound {
  static const MethodChannel _channel = const MethodChannel('flutter_pcm_sound/methods');

  static Function(int)? onFeedSamplesCallback;

  static LogLevel _logLevel = LogLevel.standard;

  static bool _needsStart = true;

  /// set log level
  static Future<void> setLogLevel(LogLevel level) async {
    _logLevel = level;
    return await _invokeMethod('setLogLevel', {'log_level': level.index});
  }

  /// setup audio
  /// 'avAudioCategory' is for iOS only,
  /// enabled by default on other platforms
  static Future<void> setup(
      {required int sampleRate,
      required int channelCount,
      IosAudioCategory iosAudioCategory = IosAudioCategory.playback,
      bool iosAllowBackgroundAudio = false,
      }) async {
    return await _invokeMethod('setup', {
      'sample_rate': sampleRate,
      'num_channels': channelCount,
      'ios_audio_category': iosAudioCategory.name,
      'ios_allow_background_audio' : iosAllowBackgroundAudio,
    });
  }

  /// queue 16-bit samples (little endian)
  ///
  /// Returns the engine's queued frame count *after* this feed, so a caller can
  /// drive playback by pushing on its own clock instead of waiting to be asked.
  /// Only the Android side reports it; elsewhere (iOS/macOS/web) this is null and
  /// the caller has to fall back to its own estimate.
  static Future<int?> feed(PcmArrayInt16 buffer) async {
    if (_needsStart && buffer.count != 0) _needsStart = false;
    final result = await _invokeMethod('feed', {'buffer': buffer.bytes.buffer.asUint8List()});
    return result is int ? result : null;
  }

  /// set the threshold at which we call the
  /// feed callback. i.e. if we have less than X
  /// queued frames, the feed callback will be invoked
  static Future<void> setFeedThreshold(int threshold) async {
    return await _invokeMethod('setFeedThreshold', {'feed_threshold': threshold});
  }

  /// Your feed callback is invoked _once_ for each of these events:
  /// - Low-buffer event: when the number of buffered frames falls below the threshold set with `setFeedThreshold`
  /// - Zero event: when the buffer is fully drained (`remainingFrames == 0`)
  /// Note: once means once per `feed()`. Every time you feed new data, it allows
  /// the plugin to trigger another low-buffer or zero event.
  static void setFeedCallback(Function(int)? callback) {
    onFeedSamplesCallback = callback;
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// convenience function:
  ///   * if needed, invokes your feed callback to start playback
  ///   * returns true if your callback was invoked
  static bool start() {
    if (_needsStart && onFeedSamplesCallback != null) {
      onFeedSamplesCallback!(0);
      return true;
    } else {
      return false;
    }
  }

  /// release all audio resources
  static Future<void> release() async {
    return await _invokeMethod('release');
  }

  /// (beavertalk patch) Drops everything queued for playback **without tearing the
  /// engine down** — the barge-in path.
  ///
  /// [release] is the only other way to stop mid-utterance, but it kills the
  /// AudioTrack and its thread, so reusing it costs a `setup()` plus a settle
  /// delay. Barge-in happens every time the user interrupts, so that price can't
  /// be paid. This keeps the track alive (silence keep-alive included, so
  /// AudioFlinger never moves it to the idle list and charges ~130ms to
  /// reactivate) and empties only the queue and the track buffer.
  ///
  /// Returns the number of **input frames** discarded — the caller's ground truth
  /// for "how much of what we sent never reached the speaker". Measured *before*
  /// the flush, and on Android it includes the AudioTrack's own buffer, not just
  /// the pending queue: counting the queue alone drops up to 800ms on some
  /// devices, which is the same class of error that caused the self-talk loop
  /// (see [getStats]' notes and `remainingInputFrames` on the Android side).
  ///
  /// Returns null when the platform does not implement it, so the caller can tell
  /// "nothing was queued" (0) apart from "I could not clear" (null) instead of
  /// silently trusting a wrong number.
  ///
  /// ⚠ iOS reports the pending queue only. Its render callback pulls ~10-20ms at
  /// a time, so there is no queryable "handed over but unplayed" pool the way
  /// Android has one; the value runs a few ms low.
  static Future<int?> clear() async {
    final res = await _invokeMethod<dynamic>('clear');
    if (res is int) return res;
    if (res is Map) {
      final v = res['frames_discarded'];
      if (v is num) return v.toInt();
    }
    return null;
  }

  /// (beavertalk patch) O(1) snapshot of the native playback backlog, for
  /// diagnosing stutter that worsens over a long call.
  ///
  /// Android only; other platforms return an empty map (the method is not
  /// implemented there, and diagnostics must never break playback).
  ///   queued_bytes       — audio fed but not yet handed to AudioTrack
  ///   chunks             — pieces that backlog is split into
  ///   underruns          — AudioTrack.getUnderrunCount() since setup (cumulative)
  ///   track_buffer_bytes — AudioTrack's own buffer size
  ///   total_feeds        — feed() calls since setup
  static Future<Map<String, int>> getStats() async {
    try {
      final raw = await _channel.invokeMapMethod<String, dynamic>('getStats');
      if (raw == null) return const {};
      return {
        for (final e in raw.entries)
          if (e.value is num) e.key: (e.value as num).toInt(),
      };
    } catch (_) {
      return const {};
    }
  }

  static Future<T?> _invokeMethod<T>(String method, [dynamic arguments]) async {
    if (_logLevel.index >= LogLevel.standard.index) {
      String args = '';
      if (method == 'feed') {
        Uint8List data = arguments['buffer'];
        if (data.lengthInBytes > 6) {
          args = '(${data.lengthInBytes ~/ 2} samples) ${data.sublist(0, 6)} ...';
        } else {
          args = '(${data.lengthInBytes ~/ 2} samples) $data';
        }
      } else if (arguments != null) {
        args = arguments.toString();
      }
      print("[PCM] invoke: $method $args");
    }
    return await _channel.invokeMethod(method, arguments);
  }

  static Future<dynamic> _methodCallHandler(MethodCall call) async {
    if (_logLevel.index >= LogLevel.standard.index) {
      String func = '[[ ${call.method} ]]';
      String args = call.arguments.toString();
      print("[PCM] $func $args");
    }
    switch (call.method) {
      case 'OnFeedSamples':
        int remainingFrames = call.arguments["remaining_frames"];
        _needsStart = remainingFrames == 0;
        if (onFeedSamplesCallback != null) {
          onFeedSamplesCallback!(remainingFrames);
        }
        break;
      default:
        print('Method not implemented');
    }
  }
}

class PcmArrayInt16 {
  final ByteData bytes;

  PcmArrayInt16({required this.bytes});

  factory PcmArrayInt16.zeros({required int count}) {
    Uint8List list = Uint8List(count * 2);
    return PcmArrayInt16(bytes: list.buffer.asByteData());
  }

  factory PcmArrayInt16.empty() {
    return PcmArrayInt16.zeros(count: 0);
  }

  factory PcmArrayInt16.fromList(List<int> list) {
    var byteData = ByteData(list.length * 2);
    for (int i = 0; i < list.length; i++) {
      byteData.setInt16(i * 2, list[i], Endian.host);
    }
    return PcmArrayInt16(bytes: byteData);
  }

  int get count => bytes.lengthInBytes ~/ 2;

  operator [](int idx) {
    int vv = bytes.getInt16(idx * 2, Endian.host);
    return vv;
  }

  operator []=(int idx, int value) {
    return bytes.setInt16(idx * 2, value, Endian.host);
  }
}

// for testing
class MajorScale {
  int _periodCount = 0;
  int sampleRate = 44100;
  double noteDuration = 0.25;

  MajorScale({required this.sampleRate, required this.noteDuration});

  // C Major Scale (Just Intonation)
  List<double> get scale {
    List<double> c = [261.63, 294.33, 327.03, 348.83, 392.44, 436.05, 490.55, 523.25];
    return [c[0]] + c + c.reversed.toList().sublist(0, c.length - 1);
  }

  // total periods needed to play the entire note
  int _periodsForNote(double freq) {
    int nFramesPerPeriod = (sampleRate / freq).round();
    int totalFramesForDuration = (noteDuration * sampleRate).round();
    return totalFramesForDuration ~/ nFramesPerPeriod;
  }

  // total periods needed to play the whole scale
  int get _periodsForScale {
    int total = 0;
    for (double freq in scale) {
      total += _periodsForNote(freq);
    }
    return total;
  }

  // what note are we currently playing
  int get noteIdx {
    int accum = 0;
    for (int n = 0; n < scale.length; n++) {
      accum += _periodsForNote(scale[n]);
      if (_periodCount < accum) {
        return n;
      }
    }
    return scale.length - 1;
  }

  // generate a sine wave
  List<int> cosineWave({int periods = 1, int sampleRate = 44100, double freq = 440, double volume = 0.5}) {
    final period = 1.0 / freq;
    final nFramesPerPeriod = (period * sampleRate).toInt();
    final totalFrames = nFramesPerPeriod * periods;
    final step = math.pi * 2 / nFramesPerPeriod;
    List<int> data = List.filled(totalFrames, 0);
    for (int i = 0; i < totalFrames; i++) {
      data[i] = (math.cos(step * (i % nFramesPerPeriod)) * volume * 32768).toInt() - 16384;
    }
    return data;
  }

  void reset() {
    _periodCount = 0;
  }

  // generate the next X periods of the major scale
  List<int> generate({required int periods, double volume = 0.5}) {
    List<int> frames = [];
    for (int i = 0; i < periods; i++) {
      _periodCount %= _periodsForScale;
      frames += cosineWave(periods: 1, sampleRate: sampleRate, freq: scale[noteIdx], volume: volume);
      _periodCount++;
    }
    return frames;
  }
}
