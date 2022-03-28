import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/providers/articles/articles_recents_model.dart';
import 'package:jekylltoflutter/providers/articles/post_article_card_model.dart';

import '../utils/size_config.dart';
import 'bookmarks.dart';
import 'favorites.dart';

class ArticlesListPage extends StatefulWidget {
  final List<Article> posts;

  final String title;

  const ArticlesListPage(this.posts, this.title, {Key? key}) : super(key: key);

  @override
  _ArticlesListPageState createState() => _ArticlesListPageState();
}

class _ArticlesListPageState extends State<ArticlesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: widget.posts.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(36),
              child: Center(
                child: Text(
                  "Aucun article correspondant trouvé.",
                  style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                children: _articleConsumerWithAds(widget.posts
                    .map((article) => _articleConsumer(article))
                    .toList()),
              ),
            )),
    );
  }

  Widget _articleConsumer(Article article) {
    return Consumer(
      builder: (context, ref, child) => WidgetLatestNews(
        ref.watch(ChangeNotifierProvider<ArticleModelCard>(
          (ref) => ArticleModelCard(
            article,
            ref.read(favoritesProvider),
            ref.read(bookmarksProvider),
          ),
        )),
        height: SizeConfig.screenHeight / 3,
        width: SizeConfig.screenWidth,
      ),
    );
  }

  List<Widget> _articleConsumerWithAds(List<Widget> articles) {
    return articles;
  }
}
