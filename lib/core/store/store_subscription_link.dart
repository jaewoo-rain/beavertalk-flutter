import 'package:flutter/foundation.dart';

/// Deep links to the platform store's subscription management page — spec
/// §15-1, work order §6-2.
///
/// These back the `In the store` group of the billing list (spec §5): once
/// subscriptions move to store IAP, cancelling, changing payment method and
/// requesting a refund all happen **outside the app**, and the app's only job
/// is to hand the member to the right page.
///
/// This builds URIs and nothing else. Opening one needs `url_launcher`, which
/// is not a dependency yet — that lands with the screens that use it. Keeping
/// the URL logic plugin-free is also what makes it testable on the desktop
/// runner.
///
/// Figma leaves these intentionally unlinked: a prototype that jumps to an
/// external URL ends the walkthrough (spec §15-1).
abstract final class StoreSubscriptionLink {
  /// The Android application id, from `android/app/build.gradle.kts`
  /// (`applicationId`).
  ///
  /// Duplicated from Gradle because Dart cannot read it, so it lives in exactly
  /// one Dart place rather than being pasted at each call site.
  static const androidPackage = 'im.beavertalk.beavertalk';

  /// App Store subscription management.
  ///
  /// Takes no parameters — Apple resolves the account itself, so this works
  /// today with nothing outstanding.
  static final Uri appStore =
      Uri.parse('https://apps.apple.com/account/subscriptions');

  /// Google Play, showing every subscription for the account.
  ///
  /// The fallback of [googlePlay]; see there for why it is what ships now.
  static final Uri googlePlayAll =
      Uri.parse('https://play.google.com/store/account/subscriptions');

  /// Google Play, deep-linked to one product when [productId] is known.
  ///
  /// **[productId] is null in every caller today.** No subscription products
  /// exist in the Play console yet; the ids are minted when they are created
  /// (spec §15-1), so the app uses the account-wide page until then. The
  /// parameter is here so that adding the id later is a one-line change rather
  /// than a URL rewrite.
  static Uri googlePlay({String? productId}) {
    if (productId == null || productId.isEmpty) return googlePlayAll;
    return googlePlayAll.replace(
      queryParameters: {'sku': productId, 'package': androidPackage},
    );
  }

  /// Google Play's promo-code redemption page.
  ///
  /// Android's half of the offer-code story. Play has no in-app redemption
  /// sheet the way StoreKit does, so a code is spent on this page in the Play
  /// Store app instead — which is why the app asks the rail first and only
  /// falls back here.
  static final googlePlayRedeem =
      Uri.parse('https://play.google.com/redeem');

  /// The right link for whichever platform is running.
  ///
  /// Defaults to the Play link off-device (desktop and web builds) so a
  /// mistargeted tap lands on a real page rather than an Apple URL that cannot
  /// resolve. Neither store page is reachable in those builds anyway.
  static Uri forCurrentPlatform({String? productId}) {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return appStore;
    }
    return googlePlay(productId: productId);
  }
}
