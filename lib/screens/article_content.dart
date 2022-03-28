import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/providers/articles/post_article_read_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_status_provider.dart';

class ArticleContent extends StatefulWidget {
  final Article article;

  final bool offlineMode;

  const ArticleContent({
    required this.article,
    this.offlineMode = false,
    Key? key,
  }) : super(key: key);

  @override
  _ArticleContentState createState() => _ArticleContentState();
}

class _ArticleContentState extends State<ArticleContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return PostArticleContentPage(
          read: ref.watch(
            ChangeNotifierProvider(
              (ref) => PostArticleReadModel(
                widget.article,
                ref.watch(appProvider),
              ),
            ),
          ),
        );
      },
    );
  }
}
