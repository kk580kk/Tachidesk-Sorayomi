import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'webview_provider.g.dart';

// class WebViewData {
//   WebViewController? controller;
//   int? progress;
// }
//
// @riverpod
// class WebViewState extends _$WebViewState {
//   @override
//   WebViewData build(String url) {
//     final data = WebViewData();
//     final controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (url) {
//           data.progress = 0;
//         },
//         onProgress: (progress) {
//           final s = WebViewData();
//           s.controller = data.controller;
//           s.progress = progress;
//           state = s;
//         },
//         onPageFinished: (url) {
//           final s = WebViewData();
//           s.controller = data.controller;
//           s.progress = 100;
//           state = s;
//         },
//       ))
//       ..setUserAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36")
//       ..loadRequest(Uri.parse(url));
//     data.controller = controller;
//     data.progress = 0;
//     return data;
//   }
// }

@riverpod
WebViewController webViewController(
    WebViewControllerRef ref, {
      required String url,
      required Color backgroundColor,
    }) {
  print("webViewController $url");
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(backgroundColor)
   // ..setUserAgent("Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/115.0.5790.160 Mobile/15E148 Safari/604.1")
    ..loadRequest(Uri.parse(url));
  return controller;
}