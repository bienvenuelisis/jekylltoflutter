import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;

  final String url;

  const WebViewPage({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

WebViewController? controllerGlobal;

Future<bool> _getBack(BuildContext context) async {
  if (await controllerGlobal?.canGoBack() ?? false) {
    controllerGlobal?.goBack();
    return Future.value(false);
  } else {
    Get.back();
    return Future.value(false);
  }
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _getBack(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            NavigationControls(_controller.future),
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: widget.url,
            debuggingEnabled: true,
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: const <JavascriptChannel>{},
            navigationDelegate: (NavigationRequest request) {
              /* if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              } */
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {},
          );
        }),
        //floatingActionButton: favoriteButton(),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(
    this._webViewControllerFuture, {
    Key? key,
  }) : super(key: key);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data!;
        controllerGlobal = controller;

        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        Get.back();
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        controller.goForward();
                      } else {
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
