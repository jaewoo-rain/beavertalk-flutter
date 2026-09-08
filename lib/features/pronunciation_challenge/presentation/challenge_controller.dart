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

  /// Whether the clock is held (pause panel showing).
  ///
  /// The ticker keeps running — the tunnel still animates behind the overlay,
  /// which is what the design shows — but the engine stops advancing, so the
  /// timer and the cards freeze where they were.
  bool _clockHeld = false;

  /// Holds the simulation without stopping the ticker.
  void pauseClock() => _clockHeld = true;

  /// Releases the hold. The next tick resumes from a fresh delta, so the time
  /// spent paused is not charged to the round.
  void resumeClock() {
    _clockHeld = false;
    _last = Duration.zero;
  }

  void _onTick(Duration elapsed) {
    final rawDt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (_clockHeld) {
      notifyListeners(); // keep the canvas live, just don't advance it
      return;
    }
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
