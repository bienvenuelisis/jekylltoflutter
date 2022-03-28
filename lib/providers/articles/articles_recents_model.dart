import 'dart:collection';

import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/providers/articles/post_article_card_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/params.dart';
import '../../screens/article_content.dart';
import '../../screens/bookmarks.dart';
import '../../screens/favorites.dart';
import '../../services/local_storage.dart';
import '../../utils/size_config.dart';
import '../../utils/utils.dart';
import '../../widgets/image.dart';

class ArticlesRecentsModel extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();

  late double height;

  late double width;

  ScrollController get scroller => _scrollController;

  int get count => _recentsPosts.length;

  int _actualPage = 1;

  final int _perPage = 10;

  ArticlesGetRequestParams get postsParamsRecents {
    return ArticlesGetRequestParams(
      page: _actualPage,
      perPage: _perPage,
      featured: false,
    );
  }

  bool _error = false;

  bool get error => _error;

  bool _loading = true;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;

    notifyListeners();
  }

  bool _loadingMoreContents = false;

  bool get loadingMoreContents => _loadingMoreContents;

  bool _noMoreArticles = false;

  bool get noMoreArticles => _noMoreArticles;

  ArticlesRecentsModel() {
    width = SizeConfig.screenWidth;
    height = SizeConfig.screenHeight / 3;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_loadingMoreContents) loadMoreContents();
      }
    });

    refreshContents();
  }

  List<Article> _recentsPosts = [];

  Future<void> loadMoreContents() async {
    if (_noMoreArticles) {
      return;
    }

    //Init loading animations
    _loadingMoreContents = true;
    notifyListeners();

    _actualPage++;
    List<Article> moreRecentsArticles = [];

    try {
      await Future.delayed(const Duration(milliseconds: 1800)).then((_) {
        moreRecentsArticles = postsParamsRecents.fetchPostsOf;
      });
      for (var article in moreRecentsArticles) {
        registerMoreRecentArticle(article);
      }
    } catch (e) {
      _error = true;
    }

    //No loading more contents.
    _loadingMoreContents = false;

    //All articles are being loaded ?
    if (moreRecentsArticles.length < _perPage) {
      _noMoreArticles = true;
    }

    notifyListeners();
  }

  Future<void> refreshContents() async {
    _recentsPosts = [];
    _error = false;
    _loading = true;
    _loadingMoreContents = false;
    _noMoreArticles = false;
    _actualPage = 1;
    notifyListeners();

    _getRecentsPosts();
  }

  UnmodifiableListView<Article> get recentsPosts =>
      UnmodifiableListView(_recentsPosts);

  void _getRecentsPosts() async {
    try {
      for (var article in postsParamsRecents.fetchPostsOf) {
        registerRecentArticle(article);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (count == 0) {
        _error = true;
        notifyListeners();
      }
    }

    _loading = false;
    notifyListeners();
  }

  void registerRecentArticle(Article article) {
    _recentsPosts.add(article);
  }

  void registerMoreRecentArticle(Article article) {
    _recentsPosts.add(article);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class LastArticleBuilder extends StatefulWidget {
  final ArticlesRecentsModel articlesRecents;

  const LastArticleBuilder(
    this.articlesRecents, {
    Key? key,
  }) : super(key: key);

  @override
  _LastArticleBuilderState createState() => _LastArticleBuilderState();
}

Widget _list(List<Widget> articlesWidgets) {
  return Column(
    children: [
      ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: articlesWidgets,
      )
    ],
  );
}

class _LastArticleBuilderState extends State<LastArticleBuilder> {
  Widget _error() {
    List<Widget> articlesWidgets = builderLastArticles();
    articlesWidgets.add(Consumer(
      builder: (BuildContext context, ref, _) {
        return __error();
      },
      //child: __error()
    ));
    return _list(articlesWidgets);
  }

  List<Widget> builderLastArticlesWithAds(List<Widget> lastArticles) {
    return lastArticles;
  }

  List<Widget> builderLastArticles() {
    return builderLastArticlesWithAds(widget.articlesRecents.recentsPosts
        .map(
          (article) => Consumer(
            builder: ((context, ref, child) => WidgetLatestNews(
                  ref.watch(
                    ChangeNotifierProvider<ArticleModelCard>(
                      (ref) => ArticleModelCard(
                        article,
                        ref.read(favoritesProvider),
                        ref.read(bookmarksProvider),
                      ),
                    ),
                  ),
                  height: widget.articlesRecents.height,
                  width: widget.articlesRecents.width,
                )),
          ),
        )
        .toList());
  }

  Widget __error() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Text(
          "Vérifiez votre connexion internet et relancer l'Application.",
          style: TextStyle(
            fontSize: 21,
            fontFamily: "Poppins",
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
      ),
    );
  }

  Widget _placeHolders() {
    return Column(
      children: List.generate(10, (index) => (_placeHolder())).toList(),
    );
  }

  Widget _placeHolder() {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        width: widget.articlesRecents.width,
        child: Row(
          children: <Widget>[
            const Expanded(
              child: PlaceholderLines(
                count: 3,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.6),
              ),
              child: const Center(
                child: Icon(
                  Icons.photo_size_select_actual,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _endOfList() {
    List<Widget> articlesWidgets = builderLastArticles();
    articlesWidgets.add(Consumer(builder: (_, __, ___) {
      return __endOfList();
    }));
    return _list(articlesWidgets);
  }

  Widget __endOfList() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Text(
            "Plus aucun article à charger.",
            style: TextStyle(
              fontSize: 21,
              fontFamily: "Poppins",
              color: Theme.of(context).textTheme.headline6!.color,
            ),
          ),
        ));
  }

  Widget _noArticles() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          "Vérifiez votre connexion internet et relancer l'Application.",
          style: TextStyle(
            fontSize: 21,
            fontFamily: "Poppins",
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articlesRecents.loading) {
      return _placeHolders();
    } else if (widget.articlesRecents.error) {
      return _error();
    } else {
      if (widget.articlesRecents.noMoreArticles) {
        if (widget.articlesRecents.count == 0) {
          return _noArticles();
        } else {
          return _endOfList();
        }
      } else {
        return _builderRecentsArticlesOk();
      }
    }
  }

  Widget _builderRecentsArticlesOk() {
    List<Widget> articlesWidgets = builderLastArticles();
    if (widget.articlesRecents.loadingMoreContents) {
      articlesWidgets.add(Consumer(builder: (_, __, ___) {
        return const Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }));
    }
    return _list(articlesWidgets);
  }
}

class WidgetLatestNews extends StatefulWidget {
  final double height;

  final double width;

  const WidgetLatestNews(
    this.post, {
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  final ArticleModelCard post;

  @override
  _WidgetLatestNewsState createState() => _WidgetLatestNewsState();
}

class _WidgetLatestNewsState extends State<WidgetLatestNews> {
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 0.0,
        top: 8.0,
        right: 0.0,
        bottom: mediaQuery.padding.bottom,
      ),
      child: _buildWidgetContentLatestNews(),
    );
  }

  /* Widget _imageBuilder() {
    return CachedNetworkImage(
      height: widget.height,
      fit: BoxFit.cover,
      width: widget.width,
      errorWidget: (_, __, ___) => _imgLoading(),
      placeholder: (_, __) => _imgLoading(),
      imageUrl: widget.post.media.details.full.source_url,
    );
  } */

  /* Widget _imageBuilder() {
    return Image(
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return _imgLoading();
      },
      image: PCacheImage(widget.post.article.image),
      fit: BoxFit.cover,
      height: widget.height,
      width: widget.width,
    );
  } */

  Widget _imageBuilder() {
    return Images.network(
      widget.post.article.image!,
      loader: _imgLoading(),
      fit: BoxFit.cover,
      height: widget.height,
      width: widget.width,
      usePlaceHolder: !LocalStorage.loadImagesMainPostsAuto,
    );
  }

  Widget _imgLoading() {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 500),
      baseColor: Colors.grey,
      highlightColor: Colors.blueGrey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        //height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 1],
              colors: [Colors.grey, Colors.black]),
          /* borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ) */
        ),
      ),
    );
  }

  Widget _imageArticleBuilder() {
    if (widget.post.imageIsLoading) {
      return _imgLoading();
    } else {
      return _imageBuilder();
    }
  }

  Widget _buildWidgetContentLatestNews() {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            goToArticle();
          },
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                            color: const Color(0xFF000000).withOpacity(0.1))
                      ]),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(25))),
                    child: ClipRRect(
                      child: _imageArticleBuilder(),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(1),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  goToArticle();
                },
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(0),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.0),
                          const Color(0xFF000000).withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 178.0,
                      right: 12.0,
                    ),
                    child: Text(
                      htmlParse(widget.post.article.title),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      top: 4.0,
                      right: 12.0,
                    ),
                    child: Wrap(
                      children: <Widget>[
                        const SizedBox(width: 4.0),
                        _categoryArticleBuilder(),
                        const SizedBox(width: 2.0),
                        _dateArticle(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryArticleBuilder() {
    if (widget.post.categoryIsLoading) {
      return _categoryLoading();
    } else {
      return _categoryArticle();
    }
  }

  Widget _categoryArticle() {
    return Text(
      "#${widget.post.article.categoryMain.toLowerCase()},",
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 12.0,
        decoration: TextDecoration.underline,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _dateArticle() {
    return Text(
      widget.post.article.dateFr.complete.toLowerCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 12.0,
        decoration: TextDecoration.underline,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _categoryLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey,
      child: Text(
        "...",
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 11.0,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
