import 'entities/subscription.dart';
import 'entities/subscription_state.dart';

/// A resolved subscription status — the single answer every subscription screen
/// reads.
///
/// Work order §4-1-2 asks for expiry to stop being computed in the entity. It
/// is computed here instead, once, so that 42 screens cannot each drift into
/// their own idea of "active".
class SubscriptionStatus {
  /// Creates a status. Prefer [SubscriptionStatusResolver.resolve].
  const SubscriptionStatus({
    required this.state,
    required this.tier,
    this.expiresAt,
    this.retryingUntil,
    this.pausedSince,
    this.source,
    this.isPlanInferred = false,
  });

  /// Where the billing relationship stands.
  final SubscriptionState state;

  /// Which feature set is unlocked. See [isPlanInferred] before trusting this
  /// for a Max-only decision.
  final SubscriptionTier tier;

  /// When access lapses. Null for open-ended and for [SubscriptionState.free].
  final DateTime? expiresAt;

  /// `Retrying until <date>` on the grace banner — spec §11-3 requires this to
  /// be a **server value**, never a locally computed one.
  final DateTime? retryingUntil;

  /// `Paused since <date>` on the hold banner. Same rule as [retryingUntil].
  final DateTime? pausedSince;

  /// The record this was derived from, when there was one.
  final Subscription? source;

  /// Whether [tier] was assumed rather than read.
  ///
  /// **True for every paid state today.** The server's `SubscriptionOut` carries
  /// `subscribe_id` / `start_date` / `end_date` / `price` / `is_activate` and no
  /// plan field at all, so nothing distinguishes Pro from Max on the wire. The
  /// resolver assumes Pro because Pro is the only paid product the backend
  /// currently sells — Max exists in the design, not in the API.
  ///
  /// Screens that gate a Max-only affordance must branch on this rather than on
  /// [tier] alone, and it stays true until the server grows a plan field. See
  /// the plan doc's review item 3.
  final bool isPlanInferred;

  /// Whether paid features are usable right now — see
  /// [SubscriptionStateX.grantsPaidAccess].
  bool get grantsPaidAccess => state.grantsPaidAccess;

  /// The status with [state] forced to [next], keeping everything else.
  ///
  /// Used by the mock/demo overrides that render all eight states; the server
  /// cannot produce five of them (see [SubscriptionStatusResolver]).
  SubscriptionStatus copyWith({
    SubscriptionState? state,
    SubscriptionTier? tier,
    DateTime? expiresAt,
    DateTime? retryingUntil,
    DateTime? pausedSince,
    bool? isPlanInferred,
  }) =>
      SubscriptionStatus(
        state: state ?? this.state,
        tier: tier ?? this.tier,
        expiresAt: expiresAt ?? this.expiresAt,
        retryingUntil: retryingUntil ?? this.retryingUntil,
        pausedSince: pausedSince ?? this.pausedSince,
        source: source,
        isPlanInferred: isPlanInferred ?? this.isPlanInferred,
      );

  /// The default status for a member with nothing on file.
  static const none = SubscriptionStatus(
    state: SubscriptionState.free,
    tier: SubscriptionTier.free,
  );
}

/// Turns the server's subscription rows into a [SubscriptionStatus].
///
/// ## What this can and cannot decide
///
/// The design describes eight states (spec §6). The current API supplies five
/// fields and **cannot express five of those states**:
///
/// | State | Decidable today | Why |
/// |---|---|---|
/// | `free` · `expired` | yes | absence / lapsed `end_date` |
/// | `activePro` | yes* | *tier assumed — see [SubscriptionStatus.isPlanInferred] |
/// | `ending` | yes | cancelled flag with a future `end_date` |
/// | `activeMax` | no | no plan field |
/// | `trial` | no | no trial flag |
/// | `grace` · `onHold` | no | no billing-retry state |
///
/// **The undecidable five are never guessed.** They arrive either from a future
/// server field or from an explicit override in the demo/mock path. Inventing
/// them from `price` heuristics would put members on the wrong screen, and the
/// wrong screen here means the wrong cancellation instructions.
///
/// This is the shortfall spec §15-2 predicted: the design assumes store IAP,
/// and store IAP is what would carry trial, grace and hold.
class SubscriptionStatusResolver {
  /// Creates a resolver. [now] exists so tests can pin the clock; production
  /// leaves it null and reads [DateTime.now].
  const SubscriptionStatusResolver({DateTime Function()? now}) : _now = now;

  final DateTime Function()? _now;

  DateTime get _clock => (_now ?? DateTime.now)();

  /// Resolves [subscriptions] (newest first, as the server returns them).
  ///
  /// Rows are *not* assumed unique: `POST /subscriptions` never checks for an
  /// existing one, so several may be active at once. The newest active row
  /// wins, matching what `currentSubscriptionProvider` did before this existed.
  SubscriptionStatus resolve(List<Subscription> subscriptions) {
    if (subscriptions.isEmpty) return SubscriptionStatus.none;

    final now = _clock;

    // An active row: flag explicitly true and not past its end date.
    for (final s in subscriptions) {
      if (s.isActivate != true) continue;
      final end = s.endDate;
      if (end != null && !end.isAfter(now)) continue;
      return SubscriptionStatus(
        state: SubscriptionState.activePro,
        tier: SubscriptionTier.pro,
        expiresAt: end,
        source: s,
        isPlanInferred: true,
      );
    }

    // Cancelled but still paid up — the member keeps access until [end].
    //
    // `cancel` only flips `is_activate` to false; it does not clear
    // `end_date`. So a false flag with a future end date is precisely the
    // `ENDING` state, not an expired one.
    for (final s in subscriptions) {
      if (s.isActivate != false) continue;
      final end = s.endDate;
      if (end == null || !end.isAfter(now)) continue;
      return SubscriptionStatus(
        state: SubscriptionState.ending,
        tier: SubscriptionTier.pro,
        expiresAt: end,
        source: s,
        isPlanInferred: true,
      );
    }

    // Rows exist but none is live: the member had a subscription and lost it.
    //
    // `null` flags land here too. The column has no server default, so a null
    // is "never activated", which is indistinguishable from lapsed and is
    // treated the same way — both mean no access.
    return SubscriptionStatus(
      state: SubscriptionState.expired,
      tier: SubscriptionTier.free,
      expiresAt: _latestEnd(subscriptions),
      source: subscriptions.first,
    );
  }

  /// The furthest `end_date` on file, for the "expired on" line.
  DateTime? _latestEnd(List<Subscription> subscriptions) {
    DateTime? latest;
    for (final s in subscriptions) {
      final end = s.endDate;
      if (end == null) continue;
      if (latest == null || end.isAfter(latest)) latest = end;
    }
    return latest;
  }
}
