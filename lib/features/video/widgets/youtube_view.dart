import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// YouTube's own embed page in a WebView.
///
/// YouTube refuses embeds that don't identify the app (error 150/152), so the page is
/// requested with `Referer: https://<application id>`, as YouTube asks of WebView apps.
/// A small script on the page reports when the video ends, and when YouTube shows its
/// "confirm you're not a bot" page instead of the video (usually caused by a VPN).
class YoutubeView extends StatefulWidget {
  const YoutubeView({
    super.key,
    required this.videoId,
    required this.onEnded,
    required this.onBlocked,
  });

  final String videoId;
  final VoidCallback onEnded;
  final VoidCallback onBlocked;

  @override
  State<YoutubeView> createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  static const _referer = 'https://com.koenawin.koenawin_dhamma';
  static const _embedPrefix = 'https://www.youtube.com/embed/';

  // Waits for the <video> element, then reports "ended" once per video.
  static const _hook = '''
(function hook() {
  var v = document.querySelector('video');
  if (!v) { setTimeout(hook, 500); return; }
  if (v.__koenawin) return;
  v.__koenawin = true;
  v.addEventListener('ended', function () { KoeNaWin.postMessage('ended'); });
})();
(function check(n) {
  var t = ((document.body && document.body.innerText) || '').toLowerCase();
  if (t.indexOf('not a bot') >= 0) { KoeNaWin.postMessage('blocked'); return; }
  var v = document.querySelector('video');
  if (v && !v.paused) return;
  if (n < 20) setTimeout(function () { check(n + 1); }, 1000);
})(0);
''';

  late final WebViewController _web = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black)
    ..addJavaScriptChannel(
      'KoeNaWin',
      onMessageReceived: (m) {
        if (m.message == 'ended') widget.onEnded();
        if (m.message == 'blocked') widget.onBlocked();
      },
    )
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) => _web.runJavaScript(_hook),
        // Stay on the embed page: the YouTube logo and end cards would leave the app's player.
        onNavigationRequest: (request) =>
            request.url.startsWith(_embedPrefix) ||
                request.url.startsWith('about:')
            ? NavigationDecision.navigate
            : NavigationDecision.prevent,
      ),
    );

  @override
  void initState() {
    super.initState();
    final platform = _web.platform;
    if (platform is AndroidWebViewController) {
      // The user already tapped the video, so let it start with sound.
      platform.setMediaPlaybackRequiresUserGesture(false);
    }
    _load();
  }

  @override
  void didUpdateWidget(YoutubeView old) {
    super.didUpdateWidget(old);
    if (old.videoId != widget.videoId) _load();
  }

  void _load() => _web.loadRequest(
    Uri.parse(
      '$_embedPrefix${widget.videoId}'
      // hl=en keeps YouTube's page text in English so the bot-check text can be found.
      '?autoplay=1&playsinline=1&rel=0&fs=1&hl=en',
    ),
    headers: const {'Referer': _referer},
  );

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 16 / 9,
    child: WebViewWidget(controller: _web),
  );
}
