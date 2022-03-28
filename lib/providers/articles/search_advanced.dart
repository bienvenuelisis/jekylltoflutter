import 'dart:collection';

import 'package:jekylltoflutter/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' hide Worker;

import '../../models/params.dart';
import '../../services/local_storage.dart';
import '../../utils/utils.dart';

final searchPageProvider = ChangeNotifierProvider((ref) => SearchPageModel());

class SearchPageModel extends ChangeNotifier {
  String _search = "";

  String get search => _search;

  set search(String search) {
    _search = search;

    LocalStorage.addToSearchHistory(search);
    refreshContents();
  }

  final ScrollController _scrollController = ScrollController();

  ScrollController get scroller => _scrollController;

  int get count => _searchPosts.length;

  int _actualPage = 1;

  final int _perPage = 10;

  ArticlesGetRequestParams get paramsSearch {
    return ArticlesGetRequestParams(
      search: search,
      page: _actualPage,
      perPage: _perPage,
    );
  }

  bool _error = false;

  bool get error => _error;

  bool _loading = true;

  bool get loading => _loading;

  bool _loadingMoreContents = false;

  bool get loadingMoreContents => _loadingMoreContents;

  bool _noMoreArticles = false;

  bool get noMoreArticles => _noMoreArticles;

  SearchPageModel();

  List<Article> _searchPosts = [];

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
      moreArticles = paramsSearch.fetchPostsOf;
      for (var article in moreArticles) {
        registerMoreSearchArticle(article);
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
    _searchPosts = [];
    _error = false;
    _loading = true;
    _loadingMoreContents = false;
    _noMoreArticles = false;
    _actualPage = 1;
    notifyListeners();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreContents();
      }
    });

    _getSearchPosts();
  }

  UnmodifiableListView<Article> get searchPosts =>
      UnmodifiableListView(_searchPosts);

  void _getSearchPosts() async {
    try {
      for (var article in paramsSearch.fetchPostsOf) {
        registerNewSearchArticle(article);
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

  void registerNewSearchArticle(Article article) {
    if (_loading) {
      _loading = false;
    }

    _searchPosts.add(article);
    notifyListeners();
  }

  void registerMoreSearchArticle(Article article) {
    _searchPosts.add(article);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class SearchArticle extends SearchDelegate<Article> {
  SearchArticle()
      : super(
          searchFieldLabel: 'Rechercher',
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    bool nightMode = LocalStorage.nightMode;
    return ThemeData(
      backgroundColor: nightMode ? Colors.grey.shade300 : Colors.white,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
          buildResults(context);
        },
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          //buildResults(context);
          //context.read(searchPageProvider).refreshContents();
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    );
  }

  Widget __loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _noArticlesForSearch() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(9),
            child: Text('Aucun article ne correspond à votre recherche.',
                style: style)));
  }

  Widget __error() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(9),
            child: Text('Impossible de recharger les articles actuellement.',
                style: style)));
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      SearchPageModel searchPage = ref.watch(searchPageProvider);
      searchPage.search = query;

      if (searchPage.loading) {
        return __loading();
      } else {
        if (searchPage.error) {
          return __error();
        } else {
          if (searchPage.count == 0) {
            return _noArticlesForSearch();
          } else {
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: () => searchPage.refreshContents(),
              child: _searchArticlesFound(searchPage, context),
            );
          }
        }
      }
    });
  }

  final TextStyle style = const TextStyle(fontFamily: "Poppins", fontSize: 18);

  @override
  Widget buildSuggestions(BuildContext context) {
    return _historyArticlesSearch(LocalStorage.getSearchHistory);
  }

  List<Widget> builderArticlesSearch(
      SearchPageModel searchPage, BuildContext context) {
    return searchPage.searchPosts
        .map((a) => ListTile(
              leading: const Icon(Icons.article, color: Colors.red),
              title: Text(htmlParse(a.title)),
              onTap: () {
                goToArticle(a, context: context);
              },
            ))
        .toList();
  }

  Widget _searchArticlesFound(
      SearchPageModel searchPage, BuildContext context) {
    List<Widget> articlesEl = builderArticlesSearch(searchPage, context);

    if (searchPage.loadingMoreContents) {
      articlesEl.add(const Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else if (searchPage.noMoreArticles) {
      articlesEl.add(const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
          child: Text(
            'Tous les articles de cette catégorie ont été chargés.',
            style: TextStyle(
                fontSize: 18, fontFamily: "Poppins", color: Colors.black),
          )));
    } else if (searchPage.error) {
      articlesEl.add(__error());
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: articlesEl.length,
        controller: searchPage.scroller,
        itemBuilder: (context, index) {
          return articlesEl[index];
        });
  }

  Widget _historyArticlesSearch(List<String> searchs) {
    return ListView.builder(
      itemCount: searchs.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(searchs[index].toString()),
          onTap: () {
            query = searchs[index].toString();
            buildResults(context);
          },
        );
      },
    );
  }
}
