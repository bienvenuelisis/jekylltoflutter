import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/providers/articles/post_article_card_model.dart';
import 'package:jekylltoflutter/services/feeds.dart';

import '../../models/params.dart';
import '../../screens/bookmarks.dart';
import '../../screens/favorites.dart';

class CategoryPageModelList extends ChangeNotifier {
  List<String> _categories = [];

  List<ChangeNotifierProvider<CategoryPageModel>> get categoriesNotifiers =>
      _categories
          .map((c) =>
              ChangeNotifierProvider((ref) => CategoryPageModel(category: c)))
          .toList();

  List<String> get categories => _categories;

  int get count => _categories.length;

  CategoryPageModelList() {
    refreshContents();
  }

  Future refreshCategories() async {
    await refreshContents();
  }

  bool ifHasNewContentsOrUpdate() {
    //return false;
    return true;
  }

  Future refreshContents() async {
    _loading = true;
    _error = false;
    _categories = [];
    notifyListeners();

    await _getCategories();
  }

  Future<void> _getCategories() async {
    try {
      _categories = Feeds.mainCategories().toList();
      _categories.sort();
    } catch (e) {
      debugPrint(e.toString());
      _error = true;
    }

    _loading = false;
    notifyListeners();
  }

  bool _loading = true;

  bool get loading => _loading;

  bool _error = false;

  bool get error => _error;
}

class CategoryPageModel extends ChangeNotifier {
  final String category;

  final ScrollController _scrollController = ScrollController();

  ScrollController get scroller => _scrollController;

  int get count => _categoriesPosts.length;

  int _actualPage = 1;

  final int _perPage = 10;

  ArticlesGetRequestParams get postsParamsByCategory {
    return ArticlesGetRequestParams(
      page: _actualPage,
      perPage: _perPage,
    ).setMainCategory(category);
  }

  bool _error = false;

  bool get error => _error;

  bool _loading = true;

  bool get loading => _loading;

  bool _loadingMoreContents = false;

  bool get loadingMoreContents => _loadingMoreContents;

  bool _noMoreArticles = false;

  bool get noMoreArticles => _noMoreArticles;

  CategoryPageModel({required this.category}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreContents();
      }
    });

    _getcategoriesPosts();
  }

  List<Article> _categoriesPosts = [];

  Future<void> loadMoreContents() async {
    if (_noMoreArticles) {
      return;
    }

    //Init loading animations
    _loadingMoreContents = true;
    notifyListeners();

    //Get next this categories articles.
    _actualPage++;
    List<Article> moreArticles = [];

    try {
      moreArticles = postsParamsByCategory.fetchPostsOf;
      for (var article in moreArticles) {
        registerMoreCategoryArticle(article);
      }
    } catch (e) {
      _error = true;
    }

    //No loading more contents.
    _loadingMoreContents = false;

    //All articles are being loaded ?
    if (moreArticles.length < _perPage) {
      _noMoreArticles = true;
    }

    notifyListeners();
  }

  Future<void> refreshContents() async {
    _categoriesPosts = [];
    _error = false;
    _loading = true;
    _loadingMoreContents = false;
    _noMoreArticles = false;
    _actualPage = 1;
    notifyListeners();

    _getcategoriesPosts();
  }

  UnmodifiableListView<Article> get categoriesPosts =>
      UnmodifiableListView(_categoriesPosts);

  void _getcategoriesPosts() async {
    try {
      for (var article in postsParamsByCategory.fetchPostsOf) {
        registerNewCategoryArticle(article);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (count == 0) {
        _error = true;
      }
    }

    _loading = false;
    notifyListeners();
  }

  void registerNewCategoryArticle(Article article) {
    if (_loading) {
      _loading = false;
    }

    _categoriesPosts.add(article);
    notifyListeners();
  }

  void registerMoreCategoryArticle(Article article) {
    _categoriesPosts.add(article);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class CategoryPageWidget extends StatefulWidget {
  final CategoryPageModel categoryPage;

  const CategoryPageWidget({
    Key? key,
    required this.categoryPage,
  }) : super(key: key);

  @override
  _CategoryPageWidgetState createState() => _CategoryPageWidgetState();
}

class _CategoryPageWidgetState extends State<CategoryPageWidget> {
  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryPage.loading) {
      return _loading();
    } else {
      if (widget.categoryPage.error) {
        return _error();
      } else {
        if (widget.categoryPage.count == 0) {
          return _noArticles();
        } else {
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: () => widget.categoryPage.refreshContents(),
            child: _builderArticlesCategories(),
          );
        }
      }
    }
  }

  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget __error() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          'Une erreur s\'est produite lors du chargement des articles de cette catégorie.\n \n Réessayez ultérieurement.',
          style: TextStyle(fontSize: 21, fontFamily: "Poppins"),
        ),
      ),
    );
  }

  List<Widget> builderCategoryArticlesConsumerWithAds(List<Widget> articles) {
    return articles;
  }

  List<Widget> builderArticlesCategoriesConsumer() {
    return builderCategoryArticlesConsumerWithAds(
        widget.categoryPage.categoriesPosts
            .map(
              (post) => Consumer(
                builder: (context, ref, child) {
                  return ArticleCard(
                    articleModel: ref.watch(
                      ChangeNotifierProvider(
                        (ref) => ArticleModelCard(
                          post,
                          ref.read(favoritesProvider),
                          ref.read(bookmarksProvider),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
            .toList());
  }

  Widget _builderArticlesCategories() {
    List<Widget> articlesEl = builderArticlesCategoriesConsumer();

    if (widget.categoryPage.loadingMoreContents) {
      articlesEl.add(Consumer(
        builder: (_, __, ___) {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ));
    } else if (widget.categoryPage.noMoreArticles) {
      articlesEl.add(Consumer(
        builder: (_, __, ___) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Tous les articles de cette catégorie ont été chargés.',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                color: Theme.of(context).textTheme.headline6!.color,
              ),
            ),
          );
        },
      ));
    } else if (widget.categoryPage.error) {
      articlesEl.add(
        Consumer(
          builder: (_, __, ___) {
            return __error();
          },
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: articlesEl.length,
      controller: widget.categoryPage.scroller,
      itemBuilder: (context, index) {
        return articlesEl[index];
      },
    );
  }

  Widget _noArticles() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Aucun article dans cette catégorie.',
              style: TextStyle(
                fontSize: 21,
                fontFamily: "Poppins",
                color: Theme.of(context).textTheme.headline6!.color,
              ),
            )));
  }

  Widget _error() {
    List<Widget> articlesEl = builderArticlesCategoriesConsumer();

    if (widget.categoryPage.loadingMoreContents) {
      articlesEl.add(Consumer(
        builder: (_, __, ___) {
          return __error();
        },
      ));
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: articlesEl.length,
      controller: widget.categoryPage.scroller,
      itemBuilder: (context, index) {
        return articlesEl[index];
      },
    );
  }
}
