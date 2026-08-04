/// The subscription state machine — spec §6 of `12_프론트_구현명세.md`.
///
/// Two axes live here and they are **not** the same thing:
/// - [SubscriptionState] — where the billing relationship stands right now.
/// - [SubscriptionTier] — which feature set is unlocked.
///
/// Mixing them collapses the call-screen variants (spec §9-1 splits those by
/// *tier*, while the manage screens split by *state*), so `trial` is a state
/// whose tier is [SubscriptionTier.max], and `grace` keeps whatever tier the
/// lapsed subscription had.
library;

/// Which feature set the member may use.
///
/// Spec §9-2: Free is one call and one pronunciation check a day; Pro removes
/// both limits; Max adds video calls and the full character roster.
enum SubscriptionTier {
  /// No paid entitlement. One call and one check per day.
  free,

  /// Unlimited calls and checks, 15-minute sessions, base characters.
  pro,

  /// Everything in Pro plus video calls and every character.
  max,
}

/// Where the billing relationship stands — the eight server states of spec §6.
///
/// Every transition is driven by a **store event**; the app never moves a
/// member between these on its own (work order §1-5). In particular, dismissing
/// a sheet changes nothing.
enum SubscriptionState {
  /// No active subscription. Never had one, or long since lapsed.
  free,

  /// Inside the Max free trial.
  trial,

  /// Pro, auto-renew on.
  activePro,

  /// Max, auto-renew on.
  activeMax,

  /// Renewal payment failed; the store is retrying. **Access is retained.**
  grace,

  /// Still unpaid after the grace window. **Access is blocked** until the
  /// member fixes payment.
  onHold,

  /// Cancelled, but paid through to a future expiry date. Access holds until
  /// then.
  ending,

  /// Lapsed after expiry and dropped back to Free.
  ///
  /// Its *manage* surface is the Free one (`subscription_manage_free`);
  /// `trial_expired` is a notice screen with a single `See plans` CTA and no
  /// billing list at all (spec §4-1).
  expired,
}

/// The status pill shown on a manage screen — spec §6-1.
///
/// Six tones for eight states: [SubscriptionState.expired] shows none (its
/// notice screen has no pill), and Pro and Max share `Renewing`.
enum SubscriptionBadge {
  /// `Current` — the Free plan is the one in force.
  current,

  /// `Trial`.
  ///
  /// The original design had `Renewing` here. That was wrong and is called out
  /// as a fixed defect in spec §16-4 — do not reintroduce it.
  trial,

  /// `Renewing` — a paid plan with auto-renew on.
  renewing,

  /// `Past due` — renewal failed, store is retrying.
  pastDue,

  /// `Paused` — account hold.
  paused,

  /// `Canceling` — cancelled, running out the paid term.
  canceling,
}

/// The label a billing row shows, as a key rather than a string.
///
/// Copy is registered in `l10n` (work order §1-3 forbids hardcoded strings), so
/// the domain names the label and the widget resolves it.
enum BillingSlotLabel {
  /// Slot ① on a paid plan.
  changePlan,

  /// Slot ① everywhere else.
  compareAllPlans,

  /// Slot ⑦, every state but [SubscriptionState.ending].
  cancelSubscription,

  /// Slot ⑦ on [SubscriptionState.ending] — the cancellation is reversible
  /// until the term runs out.
  resubscribe,
}

/// Where a billing row leads.
///
/// Route constants are deliberately absent: none of these screens exist yet
/// (they are P1–P5), and naming them here would couple the domain layer to a
/// navigation table that has not been written. The presentation layer maps
/// these to routes when the screens land.
enum BillingDestination {
  /// `depth/plans_compare`.
  plansCompare,

  /// `depth/plan_change_upgrade` — Pro → Max.
  planChangeUpgrade,

  /// `depth/plan_change_downgrade` — Max → Pro.
  planChangeDowngrade,

  /// `overlay/character_offer`.
  characterOffer,

  /// `overlay/restore — 복원 성공`.
  restoreSuccess,

  /// `overlay/restore — 복원할 항목 없음`.
  restoreEmpty,

  /// `screen/main_mypage_payment`.
  paymentHistory,

  /// `overlay/refund_help`.
  refundHelp,

  /// The store's own subscription management page — see
  /// `core/store/store_subscription_link.dart`.
  manageInStore,

  /// `overlay/not_eligible` — "there is no subscription to cancel".
  notEligible,

  /// `overlay/cancel_downsell` — the trial's cancel path.
  cancelDownsell,

  /// `overlay/cancel_subscription`.
  cancelSubscription,

  /// `overlay/resubscribe`.
  resubscribe,
}

/// The screen-facing questions each state answers.
///
/// These live as an extension rather than as fields on a status object because
/// they are pure functions of the state, and spec §5 requires the billing list
/// to stay **seven rows in every state** — only slots ① and ⑦ vary. Keeping the
/// variance in one place is what stops rows from being hidden per state.
extension SubscriptionStateX on SubscriptionState {
  /// The tier this state implies on its own, where the state is enough to
  /// determine it.
  ///
  /// Null for [SubscriptionState.grace], [SubscriptionState.onHold] and
  /// [SubscriptionState.ending]: those retain whichever plan lapsed, which only
  /// the subscription record knows. Read the tier off `SubscriptionStatus`
  /// instead of calling this directly.
  SubscriptionTier? get impliedTier => switch (this) {
        SubscriptionState.free => SubscriptionTier.free,
        SubscriptionState.expired => SubscriptionTier.free,
        SubscriptionState.trial => SubscriptionTier.max,
        SubscriptionState.activePro => SubscriptionTier.pro,
        SubscriptionState.activeMax => SubscriptionTier.max,
        SubscriptionState.grace => null,
        SubscriptionState.onHold => null,
        SubscriptionState.ending => null,
      };

  /// Whether paid features are actually usable right now.
  ///
  /// Spec §6: `GRACE` **retains** access while the store retries, `ON_HOLD`
  /// **blocks** it. That asymmetry is the whole point of having two states.
  bool get grantsPaidAccess => switch (this) {
        SubscriptionState.trial ||
        SubscriptionState.activePro ||
        SubscriptionState.activeMax ||
        SubscriptionState.grace ||
        SubscriptionState.ending =>
          true,
        SubscriptionState.free ||
        SubscriptionState.onHold ||
        SubscriptionState.expired =>
          false,
      };

  /// The gold upgrade banner — spec §6-1.
  ///
  /// Hidden on Max (nothing above it) and on [SubscriptionState.onHold], where
  /// **restoring payment has to come first**; selling an upgrade to someone
  /// whose card just failed is the wrong ask. Also hidden on
  /// [SubscriptionState.expired], whose notice screen carries a single CTA.
  bool get showsUpgradeBanner => switch (this) {
        SubscriptionState.free ||
        SubscriptionState.trial ||
        SubscriptionState.activePro ||
        SubscriptionState.grace ||
        SubscriptionState.ending =>
          true,
        SubscriptionState.activeMax ||
        SubscriptionState.onHold ||
        SubscriptionState.expired =>
          false,
      };

  /// The red payment-failure banner — spec §6-1, `GRACE` and `ON_HOLD` only.
  ///
  /// It used to appear on [SubscriptionState.ending] too. That was a defect
  /// (spec §16-4); a cancelled-but-paid subscription has no failed payment.
  bool get showsPaymentFailureBanner =>
      this == SubscriptionState.grace || this == SubscriptionState.onHold;

  /// The status pill, or null when the state shows none.
  SubscriptionBadge? get badge => switch (this) {
        SubscriptionState.free => SubscriptionBadge.current,
        SubscriptionState.trial => SubscriptionBadge.trial,
        SubscriptionState.activePro => SubscriptionBadge.renewing,
        SubscriptionState.activeMax => SubscriptionBadge.renewing,
        SubscriptionState.grace => SubscriptionBadge.pastDue,
        SubscriptionState.onHold => SubscriptionBadge.paused,
        SubscriptionState.ending => SubscriptionBadge.canceling,
        SubscriptionState.expired => null,
      };

  /// Slot ① label — spec §5-2.
  BillingSlotLabel get planSlotLabel => switch (this) {
        SubscriptionState.activePro ||
        SubscriptionState.activeMax =>
          BillingSlotLabel.changePlan,
        _ => BillingSlotLabel.compareAllPlans,
      };

  /// Slot ① destination — spec §5-2.
  BillingDestination get planSlotDestination => switch (this) {
        SubscriptionState.activePro => BillingDestination.planChangeUpgrade,
        SubscriptionState.activeMax => BillingDestination.planChangeDowngrade,
        _ => BillingDestination.plansCompare,
      };

  /// Slot ③ destination — spec §5-4.
  ///
  /// Free has nothing to restore. Everyone else does, and that includes people
  /// who only ever bought a character: character purchases run on the in-house
  /// PG and outlive any subscription (spec §12).
  BillingDestination get restoreDestination =>
      this == SubscriptionState.free
          ? BillingDestination.restoreEmpty
          : BillingDestination.restoreSuccess;

  /// Slot ⑦ label — spec §5-3.
  BillingSlotLabel get statusSlotLabel => this == SubscriptionState.ending
      ? BillingSlotLabel.resubscribe
      : BillingSlotLabel.cancelSubscription;

  /// Slot ⑦ destination — spec §5-3.
  ///
  /// Free keeps the row and explains itself when tapped rather than hiding it
  /// (spec §5-1: rows are never hidden per state).
  BillingDestination get statusSlotDestination => switch (this) {
        SubscriptionState.free => BillingDestination.notEligible,
        SubscriptionState.trial => BillingDestination.cancelDownsell,
        SubscriptionState.ending => BillingDestination.resubscribe,
        _ => BillingDestination.cancelSubscription,
      };

  /// Whether this state renders the full billing list.
  ///
  /// [SubscriptionState.expired] does not: `trial_expired` is a notice screen
  /// (spec §4-1). Its manage surface is the Free screen.
  bool get showsBillingList => this != SubscriptionState.expired;
}

/// What the purchase funnel was asked to buy — the route argument of
/// `purchase_processing`.
///
/// The tier alone used to travel, so the paywall's annual selection and the
/// OTO's "Switch to yearly" both silently bought the *monthly* product. The
/// cycle now rides along; a bare [SubscriptionTier] argument is still accepted
/// (and read as monthly) so older call sites keep working.
typedef PurchaseRequest = ({SubscriptionTier tier, bool annual});
