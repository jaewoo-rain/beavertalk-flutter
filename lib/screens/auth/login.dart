import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/brand_icons.dart';
import '../../components/organisms/bottom_sheet_country_select.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Web client id (public value) — must match the server's `GOOGLE_CLIENT_ID`.
const _googleClientId =
    '117133754675-ovpf9bvvm96e18d0089692k51bq75esk.apps.googleusercontent.com';

/// Auth — landing login screen. Figma `screen/auth_login` (`2117:19693`).
///
/// Brand block + social sign-in buttons + "or" divider + email login +
/// sign-up prompt.
///
/// **Google is real on web**: the GIS [gis_web.renderButton] yields an idToken
/// via [GoogleSignIn.onCurrentUserChanged], which we hand to
/// `authController.socialLogin('google', idToken)`; the AuthGate then shows
/// home. Kakao/Apple remain mocked for now.
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates the login landing screen.
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// Google Sign-In. On web the GIS `clientId` is used; on mobile the same web
  /// client id is passed as `serverClientId` so the returned idToken's audience
  /// matches Supabase's Google provider (required by `signInWithIdToken`).
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _googleClientId : null,
    serverClientId: kIsWeb ? null : _googleClientId,
    scopes: const ['email', 'profile'],
  );

  StreamSubscription<GoogleSignInAccount?>? _googleSub;
  bool _googleBusy = false;

  /// Guards double-taps while the Kakao login flow is in progress.
  bool _kakaoBusy = false;

  /// Guards double-taps while the Apple login flow is in progress.
  bool _appleBusy = false;

  @override
  void initState() {
    super.initState();
    // First entry with no language captured yet → prompt with the country/
    // language bottom sheet over this screen (Figma `auth_login__sheet`).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ref.read(signupDraftProvider).language == null) {
        _showLanguageSheet();
      }
    });
    if (kIsWeb) {
      // A signed-in user (idToken populated) arrives on this stream after the
      // GIS button is pressed and consent is granted.
      _googleSub = _googleSignIn.onCurrentUserChanged.listen(_onGoogleUser);
      // Tries to restore a prior session without UI (no-op if none).
      unawaited(_googleSignIn.signInSilently());
    }
  }

  /// Country/language picker shown as a modal bottom sheet over the login
  /// screen (Figma `auth_login__sheet` / `BottomSheet-CountrySelect`). It is a
  /// pure overlay — no status bar / progress bar / home indicator, just the
  /// country list + confirm button over a dim. On confirm the chosen language
  /// is stored in the signup draft.
  Future<void> _showLanguageSheet() async {
    final items = <CountryItem>[
      for (final l in mockLanguages)
        CountryItem(code: l.id, name: l.name, countryCode: l.countryCode),
    ];
    // Local selection while the sheet is open; seeded from the draft.
    String? selected = ref.read(signupDraftProvider).language;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: BottomSheetCountrySelect(
                items: items,
                value: selected,
                // Overlay over the login screen — omit the device chrome.
                showHomeIndicator: false,
                onChanged: (code) => setSheetState(() => selected = code),
                onConfirm: selected == null
                    ? null
                    : () {
                        ref
                            .read(signupDraftProvider.notifier)
                            .setLanguage(selected!);
                        Navigator.of(sheetContext).pop();
                      },
                onClose: () => Navigator.of(sheetContext).pop(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _googleSub?.cancel();
    super.dispose();
  }

  /// Exchanges the Google idToken for our JWT via `POST /auth/social`.
  Future<void> _onGoogleUser(GoogleSignInAccount? account) async {
    if (account == null || _googleBusy) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _googleBusy = true);
    try {
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw UnknownFailure(l10n.loginGoogleTokenError);
      }
      await ref
          .read(authControllerProvider.notifier)
          .signInWithGoogle(idToken: idToken, accessToken: auth.accessToken);
      // Success → AuthGate is authenticated and shows home; pop the auth flow.
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError(l10n.loginGoogleSignInFailed);
    } finally {
      if (mounted) setState(() => _googleBusy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Kakao sign-in: runs the native Kakao flow and, on success, exchanges the
  /// OIDC idToken for a Supabase session (in [AuthController.signInWithKakao]).
  /// The AuthGate then shows home/onboarding; here we just pop the auth flow.
  /// User cancellation returns silently (no snackbar).
  Future<void> _kakaoLogin() async {
    if (_kakaoBusy) return;
    setState(() => _kakaoBusy = true);
    try {
      await ref.read(authControllerProvider.notifier).signInWithKakao();
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('카카오 로그인에 실패했어요.');
    } finally {
      if (mounted) setState(() => _kakaoBusy = false);
    }
  }

  /// Apple sign-in (iOS): runs the native Apple flow and, on success, exchanges
  /// the identityToken for a Supabase session (in [AuthController.signInWithApple]).
  /// User cancellation returns silently (no snackbar). On Android this surfaces a
  /// generic error (Apple needs extra web-flow config there).
  Future<void> _appleLogin() async {
    if (_appleBusy) return;
    setState(() => _appleBusy = true);
    try {
      await ref.read(authControllerProvider.notifier).signInWithApple();
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('애플 로그인에 실패했어요.');
    } finally {
      if (mounted) setState(() => _appleBusy = false);
    }
  }

  /// Email login opens the dedicated email/password form.
  void _emailLogin() => Navigator.pushNamed(context, Routes.loginForm);

  /// Opens the signup flow.
  void _goSignup() => Navigator.pushNamed(context, Routes.signup);

  /// Opens the terms-of-service article (from the consent notice link).
  void _goTerms() => Navigator.pushNamed(context, Routes.terms);

  /// Opens the privacy-policy article (from the consent notice link).
  void _goPrivacy() => Navigator.pushNamed(context, Routes.privacy);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      // Figma horizontal screen padding is 40px (buttons are 295 wide,
      // centered in the 375 frame). The 76px top matches the design's
      // vertical position: the (empty/hidden) 56px GNB + 20px body inset,
      // so the avatar lands at screen y≈120 as in node 2117:19693.
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.s40,
            76, // Figma top offset (no AppSpacing token)
            AppSpacing.s40,
            AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Brand block: circular beaver avatar + wordmark ──────────
            const _LogoBlock(),
            // Figma: wordmark bottom → first social button ≈ 46px.
            const SizedBox(height: 46), // Figma 46px gap (no AppSpacing token)
            // ── Social sign-in buttons ──────────────────────────────────
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: l10n.loginContinueWithKakao,
              leftIcon: const KakaoIcon(size: 24),
              disabled: _kakaoBusy,
              onPressed: _kakaoLogin,
            ),
            const SizedBox(height: AppSpacing.s16),
            // Google: custom button (matches Kakao/Apple) wired to the real
            // Google sign-in flow.
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: l10n.loginContinueWithGoogle,
              leftIcon: const GoogleIcon(size: 24),
              disabled: _googleBusy,
              onPressed: _googleLogin,
            ),
            const SizedBox(height: AppSpacing.s16),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: l10n.loginContinueWithApple,
              leftIcon: const AppleIcon(size: 24),
              disabled: _appleBusy,
              onPressed: _appleLogin,
            ),
            const SizedBox(height: AppSpacing.s16),
            // ── "or" divider ────────────────────────────────────────────
            const _OrDivider(),
            const SizedBox(height: AppSpacing.s16),
            // ── Email login (primary) ───────────────────────────────────
            Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.loginContinueWithEmail,
              leftIcon: const MailIcon(size: 24, color: AppColors.onPrimary),
              onPressed: _emailLogin,
            ),
            // Figma: email button → signup prompt = 16px.
            const SizedBox(height: AppSpacing.s16),
            // ── Signup prompt + terms notice ────────────────────────────
            _SignupPrompt(
              onSignup: _goSignup,
              onTerms: _goTerms,
              onPrivacy: _goPrivacy,
            ),
          ],
        ),
      ),
    );
  }

  /// Starts the Google sign-in flow from the custom button. On success the
  /// [GoogleSignIn.onCurrentUserChanged] stream fires [_onGoogleUser], which
  /// exchanges the idToken for our JWT — the existing logic, unchanged.
  ///
  /// Note: on web, the idToken is delivered via the One Tap / button flow;
  /// `signIn()` triggers it but token availability depends on the GIS session.
  Future<void> _googleLogin() async {
    if (_googleBusy) return;
    final l10n = AppLocalizations.of(context);
    try {
      await _googleSignIn.signIn();
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError(l10n.loginGoogleSignInFailed);
    }
  }
}

/// Circular beaver avatar (120px) over the "BeaverTalk" wordmark.
class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        // Figma wordmark is 179.663px wide → 180.
        const BeaverTalkLogo(width: 180, color: AppColors.text),
      ],
    );
  }
}

/// Horizontal "or" divider — a centered label between two hairlines.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: AppColors.textTertiary),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
          child: Text(
            AppLocalizations.of(context).loginOrDivider,
            style: AppType.caption1.r.copyWith(color: AppColors.textSecondary),
          ),
        ),
        line,
      ],
    );
  }
}

/// "Don't have an account? Sign up" row plus the terms/privacy notice.
class _SignupPrompt extends StatelessWidget {
  const _SignupPrompt({
    required this.onSignup,
    required this.onTerms,
    required this.onPrivacy,
  });

  /// Tapped when "Sign up" is pressed.
  final VoidCallback onSignup;

  /// Tapped on the "Terms of Service" link in the consent notice.
  final VoidCallback onTerms;

  /// Tapped on the "Privacy Policy" link in the consent notice.
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Wrap keeps the prompt + action on one line normally, but lets them
        // flow onto a second line if the localized text grows.
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6, // Figma 6px gap (no AppSpacing token)
          children: [
            Text(
              l10n.loginNoAccount,
              style:
                  AppType.label1.r.copyWith(color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: onSignup,
              child: Text(
                l10n.signUp,
                style: AppType.label1.sb.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        // Figma: signup link row → terms notice = 16px.
        const SizedBox(height: AppSpacing.s16),
        // Figma left-aligns the terms notice across the full 295px width.
        SizedBox(
          width: double.infinity,
          child: _TermsNotice(onTerms: onTerms, onPrivacy: onPrivacy),
        ),
      ],
    );
  }
}

/// Bottom consent notice with tappable, underlined "Terms of Service" and
/// "Privacy Policy" links (Figma `hit/terms` / `hit/privacy` over node
/// `2117:19693`). Stateful so the [TapGestureRecognizer]s are disposed.
class _TermsNotice extends StatefulWidget {
  const _TermsNotice({required this.onTerms, required this.onPrivacy});

  /// Tapped on the "Terms of Service" link.
  final VoidCallback onTerms;

  /// Tapped on the "Privacy Policy" link.
  final VoidCallback onPrivacy;

  @override
  State<_TermsNotice> createState() => _TermsNoticeState();
}

class _TermsNoticeState extends State<_TermsNotice> {
  late final TapGestureRecognizer _termsTap =
      TapGestureRecognizer()..onTap = () => widget.onTerms();
  late final TapGestureRecognizer _privacyTap =
      TapGestureRecognizer()..onTap = () => widget.onPrivacy();

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 12pt caption keeps the notice compact so it fits without scrolling; the
    // login body stays in a SingleChildScrollView for longer localized text.
    final base = AppType.caption1.r.copyWith(color: AppColors.textSecondary);
    // Links read as links: brighter (white) + underlined, mirroring Figma's
    // underlined `서비스 약관` / `개인정보 보호정책` spans.
    final link = AppType.caption1.r.copyWith(
      color: AppColors.text,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.text,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: l10n.loginTermsNoticePrefix),
          TextSpan(
            text: l10n.termsOfService,
            style: link,
            recognizer: _termsTap,
          ),
          TextSpan(text: l10n.loginTermsNoticeAnd),
          TextSpan(
            text: l10n.privacyPolicy,
            style: link,
            recognizer: _privacyTap,
          ),
          TextSpan(text: l10n.loginTermsNoticeSuffix),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}
