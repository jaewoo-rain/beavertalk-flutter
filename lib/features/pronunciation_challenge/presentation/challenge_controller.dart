import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../domain/challenge_engine.dart';
import '../domain/game_config.dart';

/// Drives the [ChallengeEngine] from a [Ticker] and exposes a [Listenable]
/// (via [ChangeNotifier]) so the `CustomPaint` repaints each frame.
///
/// The ticker runs continuously once started (the belt animates behind the
/// start/result panels); [ChallengeEngine.running] gates the actual gameplay.
class ChallengeController extends ChangeNotifier {
  /// Creates a controller bound to [vsync]. Inject an [engine] for tests.
  ChallengeController({required TickerProvider vsync, ChallengeEngine? engine})
      : engine = engine ?? ChallengeEngine() {
    _ticker = vsync.createTicker(_onTick);
  }

  /// The simulation this controller advances.
  final ChallengeEngine engine;

  late final Ticker _ticker;
  Duration _last = Duration.zero;

  /// Selected difficulty (read live by the engine each frame).
  Difficulty get difficulty => engine.difficulty;
  set difficulty(Difficulty value) => engine.difficulty = value;

  /// Starts the per-frame ticker (idempotent).
  void startTicker() {
    _last = Duration.zero;
    if (!_ticker.isActive) _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final rawDt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    // KEEP the web game clamp (line 589): dt = min(0.05, delta).
    final dt = rawDt < 0.05 ? rawDt : 0.05;
    engine.update(dt);
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
