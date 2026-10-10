import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 웹의 법무 페이지를 앱 안에서 띄운다.
///
/// 문안을 앱에 복제하지 않기 위한 화면이다 — 정본은 beavertalk.im 한 곳뿐이고,
/// 여기서는 그것을 보여주기만 한다.
///
/// ★ webview_flutter 는 Android·iOS 만 지원한다. 이 저장소는 web·linux·macos·
///   windows 도 빌드 타깃이라, 지원하지 않는 플랫폼에서 [WebViewController] 를
///   만들면 런타임에 죽는다. 그래서 [_canEmbed] 로 갈라 외부 브라우저로 넘긴다.
class LegalWebView extends StatefulWidget {
  /// 띄울 문서 URL. `legal_urls.dart` 의 상수를 쓴다.
  const LegalWebView({super.key, required this.url});

  /// 법무 문서 주소.
  final String url;

  @override
  State<LegalWebView> createState() => _LegalWebViewState();
}

/// 인앱 웹뷰를 쓸 수 있는 플랫폼인가.
bool get _canEmbed =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

class _LegalWebViewState extends State<LegalWebView> {
  WebViewController? _controller;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (_canEmbed) _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          // 본문 로드 실패만 잡는다. 서브리소스(폰트·이미지) 실패로 전체를
          // 오류 화면으로 바꾸면 읽을 수 있는 문서를 못 보여주게 된다.
          // isForMainFrame 은 nullable 이다 — iOS(WKWebView)는 값을 안 줄 때가 있고,
          // 그때 무시해 버리면 오류 화면이 영영 안 떠서 빈 화면만 남는다.
          // 그래서 '명시적으로 false 일 때만' 건너뛴다.
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame == false) return;
            setState(() {
              _loading = false;
              _failed = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('브라우저를 열지 못했습니다. $widget.url 로 접속해 주세요.')),
      );
    }
  }

  void _retry() {
    setState(() {
      _loading = true;
      _failed = false;
    });
    _controller?.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    // 웹뷰를 못 쓰는 플랫폼(web·desktop) — 외부 브라우저로 안내한다.
    if (!_canEmbed) {
      return _Fallback(
        message: '법적 고지는 웹사이트에서 확인하실 수 있습니다.',
        actionLabel: '브라우저에서 열기',
        onAction: _openExternally,
      );
    }

    if (_failed) {
      return _Fallback(
        message: '문서를 불러오지 못했습니다.\n네트워크 상태를 확인해 주세요.',
        actionLabel: '다시 시도',
        onAction: _retry,
        secondaryLabel: '브라우저에서 열기',
        onSecondary: _openExternally,
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_loading)
          ColoredBox(
            color: context.c.backgroundNormalNormal,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

/// 로드 실패·미지원 플랫폼 공용 안내 화면.
class _Fallback extends StatelessWidget {
  const _Fallback({
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppType.body2.r.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: AppSpacing.s8),
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
