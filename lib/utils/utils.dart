import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:html/dom.dart' as html_parser;

import '../models/index.dart';
import '../screens/article_content.dart';
import '../screens/home.dart';

void snackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    colorText: Colors.white,
    backgroundColor: Colors.black87,
  );
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future dialog<T>(
  BuildContext context, {
  required String title,
  required String content,
  String cancelText = "Annuler",
  String okText = "D'accord",
  VoidCallback? cancelFunc,
  VoidCallback? okFunc,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, okText);
            if (okFunc != null) okFunc();
          },
          child: Text(okText),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, cancelText);
            if (cancelFunc != null) cancelFunc();
          },
          child: Text(cancelText),
        ),
      ],
    ),
  );
}

void toast(
  BuildContext context,
  String message, {
  int duration = 3,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  void Function()? action,
  String actionText = "Ok",
  Widget? leading,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: behavior,
      content: leading == null
          ? Text(message)
          : Row(
              children: [
                leading,
                const SizedBox(width: 20),
                Expanded(child: Text(message)),
              ],
            ),
      duration: Duration(seconds: duration),
      action: action == null
          ? null
          : SnackBarAction(
              label: actionText,
              onPressed: action,
            ),
    ),
  );
}

void goTo(
  BuildContext context,
  Widget widget, [
  bool pushRepplacement = false,
]) {
  pushTo(context, widget, false);
}

void navigateTo(
  BuildContext context,
  Widget widget, [
  bool pushRepplacement = false,
]) {
  pushTo(context, widget, false);
}

void pushTo(
  BuildContext context,
  Widget widget, [
  bool pushRepplacement = false,
]) {
  if (pushRepplacement) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}

String htmlParse(String html, [String default_ = ""]) {
  return html_parser.DocumentFragment.html(html).text ?? default_;
}

void goToArticle(
  Article? article, {
  bool offlineMode = false,
  required BuildContext context,
}) {
  if (article == null) {
    snackbar("Erreur", "Impossible de lire cet article.");
    pushTo(context, const Home());
  } else {
    pushTo(
      context,
      ArticleContent(
        article: article,
        offlineMode: offlineMode,
      ),
    );
  }
}
