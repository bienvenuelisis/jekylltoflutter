import 'dart:collection';

import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/providers/articles/post_article_card_model.dart';
import 'package:jekylltoflutter/services/feeds.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/utils/image_loader.dart';
import 'package:shimmer/shimmer.dart';

import '../../screens/article_content.dart';
import '../../screens/bookmarks.dart';
import '../../screens/favorites.dart';
import '../../services/local_storage.dart';
import '../../utils/size_config.dart';
import '../../utils/utils.dart';
import '../../widgets/image.dart';

class ArticlesMainModel extends ChangeNotifier {
  late final PageController _pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 1,
  );

  PageController get pageController => _pageViewController;

  late double height;

  late double width;

  int get count => _mainPosts.length;

  bool _error = false;

  bool get error => _error;

  bool _isCompleted = false;

  bool get complete => _isCompleted;

  bool _loading = true;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;

    notifyListeners();
  }

  ArticlesMainModel() {
    width = SizeConfig.screenWidth;
    height = SizeConfig.screenHeight / 2.4;

    _getMainPosts();
  }

  List<Article> _mainPosts = [];

  Future<void> refreshContents() async {
    _mainPosts = [];
    _error = false;
    _isCompleted = false;
    _loading = true;
    notifyListeners();

    _getMainPosts();
  }

  UnmodifiableListView<Article> get mainPosts =>
      UnmodifiableListView(_mainPosts);

  void _getMainPosts() async {
    try {
      Feeds.featured().forEach((article) => {registerRecentArticle(article)});
    } catch (e) {
      debugPrint(e.toString());

      if (count == 0) {
        _error = true;
        notifyListeners();
      }
    }

    _isCompleted = true;
    _loading = false;
    notifyListeners();
  }

  void registerRecentArticle(Article article) {
    if (_loading) {
      _loading = false;
    }

    _mainPosts.add(article);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }
}

class MainArticlesBuilder extends StatefulWidget {
  final ArticlesMainModel articlesMains;
  final PageController _pageViewController;

  const MainArticlesBuilder(
    this.articlesMains,
    this._pageViewController, {
    Key? key,
  }) : super(key: key);

  @override
  _MainArticlesBuilderState createState() => _MainArticlesBuilderState();
}

class _MainArticlesBuilderState extends State<MainArticlesBuilder> {
  lastArticlesMain(BuildContext context) {
    return PageView.builder(
      itemCount: widget.articlesMains.mainPosts.length,
      controller: widget._pageViewController,
      itemBuilder: (context, index) {
        return Consumer(builder: (context, ref, child) {
          return WidgetMainPost(
            ref.watch(ChangeNotifierProvider((ref) => ArticleModelCard(
                  widget.articlesMains.mainPosts[index],
                  ref.read(favoritesProvider),
                  ref.read(bookmarksProvider),
                ))),
            height: widget.articlesMains.height,
            width: widget.articlesMains.width,
          );
        });
      },
    );
  }

  Widget _error() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: Text("Vérifiez votre connexion internet et recharger la page.",
            style: TextStyle(
                fontSize: 21, fontFamily: "Poppins", color: Colors.black)),
      ),
    );
  }

  Widget _noArticles() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          "Aucun article à charger.",
          style: TextStyle(
              fontSize: 21, fontFamily: "Poppins", color: Colors.black),
        ),
      ),
    );
  }

  Widget lastArticlesMainPlaceHolders(BuildContext context) {
    return PageView.builder(
      itemCount: widget.articlesMains.count,
      restorationId: "widgetsMainPlaceHolders",
      controller:
          PageController(initialPage: 0, keepPage: true, viewportFraction: 1),
      itemBuilder: (context, index) {
        return __imgLoading(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.articlesMains.height,
      child: _mainArticlesBuilder(),
    );
  }

  Widget _mainArticlesBuilder() {
    if (widget.articlesMains._loading) {
      return lastArticlesMainPlaceHolders(context);
    } else if (widget.articlesMains.error) {
      return _error();
    } else {
      if (widget.articlesMains.complete && widget.articlesMains.count == 0) {
        return _noArticles();
      } else {
        return lastArticlesMain(context);
      }
    }
  }
}

class WidgetMainPost extends StatefulWidget {
  final double height;

  final double width;

  const WidgetMainPost(
    this.post, {
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  final ArticleModelCard post;

  @override
  _WidgetMainPostState createState() => _WidgetMainPostState();
}

class _WidgetMainPostState extends State<WidgetMainPost> {
  final Color newsTitleColor = const Color(0xFF000000);

  @override
  void initState() {
    super.initState();
  }

  void goToArticle() {
    goTo(
      context,
      ArticleContent(
        article: widget.post.article,
      ),
    );
  }

  TextStyle _titleStyle() {
    return const TextStyle(
      fontSize: 15,
      color: Colors.white,
      decorationStyle: TextDecorationStyle.solid,
      fontWeight: FontWeight.w400,
    );
  }

  Widget _bookMark() {
    if (widget.post.isInBookMarks) {
      return IconButton(
        icon: const Icon(Icons.bookmark, color: Colors.teal),
        onPressed: () {
          widget.post.removeFromBookmarks();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.bookmark_border, color: Colors.teal),
        onPressed: () {
          widget.post.addToBookmarks();
        },
      );
    }
  }

  Widget _premiumIcon() {
    if (widget.post.article.premium) {
      bool locked = LocalStorage.lockedPremiumArticle(widget.post.article);

      return IconButton(
        icon: Icon(
          Icons.stars,
          color: locked ? Colors.amber[900] : Colors.amber[300],
        ),
        onPressed: () {
          if (locked) {
            snackbar(
              "Contenu Premium Bloqué",
              "Vous serez invité à effectuer une action pour débloquer ce contenu.",
            );
          } else {
            snackbar(
              "Contenu Premium Débloqué",
              "Vous pouvez désormais bénéficier de ce contenu sans aucune restriction.",
            );
          }
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _favoriteIcon() {
    if (widget.post.isFavorite) {
      return IconButton(
        icon: const Icon(Icons.favorite, color: Colors.red),
        onPressed: () {
          widget.post.removeFromFavorite();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.favorite_border, color: Colors.teal),
        onPressed: () {
          widget.post.addToFavorite();
        },
      );
    }
  }

  Widget _imageBuilder(Article article) {
    return Images.network(
      article.image!,
      fit: BoxFit.cover,
      usePlaceHolder: !LocalStorage.loadImagesMainPostsAuto,
      loader: ImageLoading.imgPlaceHolder(),
    );
  }

  Widget _imgError() {
    return Container(color: Colors.grey);
  }

  Widget imgOk(Article article) {
    return _imageBuilder(article);
  }

  Widget _imgLoading() {
    return SizedBox(
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 500),
        baseColor: Colors.grey,
        highlightColor: Colors.blueGrey,
        child: const Card(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _categorySpanCategory(String category) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: RichText(
          text: TextSpan(
            text: category,
            style: const TextStyle(
              color: Colors.white,
              backgroundColor: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categorySpanLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.red,
      highlightColor: Colors.white,
      child: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: RichText(
            text: const TextSpan(
                text: 'Chargement...',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                )),
          ),
        ),
      ),
    );
  }

  Widget _categorySpanBuilder(ArticleModelCard articleModel) {
    if (articleModel.categoryIsLoading) {
      return _categorySpanLoading();
    } else {
      return _categorySpanCategory(articleModel.article.categoryMain);
    }
  }

  Widget _imageArticleBuilder(ArticleModelCard articleModel) {
    if (articleModel.imageIsLoading) {
      return _imgLoading();
    } else {
      if (articleModel.article.image == null) {
        return _imgError();
      } else {
        return _imageBuilder(articleModel.article);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goToArticle();
      },
      child: Stack(
        children: [
          Positioned.fill(child: _imageArticleBuilder(widget.post)),
          Positioned(
            top: 6,
            left: 0,
            child: _categorySpanBuilder(widget.post),
          ),
          Positioned(
            top: 0,
            right: 6,
            child: _favoriteIcon(),
          ),
          Positioned(
            top: 0,
            right: 45,
            child: _bookMark(),
          ),
          Positioned(
            top: 0,
            right: 84,
            child: _premiumIcon(),
          ),
          Positioned(
            top: widget.height - 75,
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              child: Container(
                color: Colors.black,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: RichText(
                        maxLines: 1,
                        softWrap: true,
                        text: TextSpan(
                            text: htmlParse(widget.post.article.title),
                            style: _titleStyle()),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer,
                              color: Colors.white, size: 24),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                              htmlParse(
                                widget.post.article.dateFr.complete,
                              ),
                              style: _titleStyle())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              opacity: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

Widget __imgLoading(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 242,
    //height: MediaQuery.of(context).size.height / 4,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 1],
          colors: [Colors.grey, Colors.black]),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
  );
}
