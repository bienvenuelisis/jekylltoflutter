import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Worker;

import '../constants/themes.dart';
import '../models/index.dart';
import '../services/jekyll_blog.dart';
import '../services/local_storage.dart';
import '../utils/utils.dart';
import '../widgets/image.dart';

class SearchArticle extends SearchDelegate<Article> {
  SearchArticle()
      : super(
          searchFieldLabel: 'Rechercher',
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return LocalStorage.nightMode ? Themes.dark : Themes.light;
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
          buildResults(context);
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

  @override
  Widget buildResults(BuildContext context) {
    return _searchArticleSearchBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _historyArticlesSearch(
      LocalStorage.getSearchHistory.reversed.toList(),
    );
  }

  FutureBuilder<List<Article>> _searchArticleSearchBuilder() {
    return FutureBuilder<List<Article>>(
      future: search(query),
      builder: (context, response) {
        if (response.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(9),
              child: Text('Impossible de recharger les articles actuellement.'),
            ),
          );
        } else {
          return ((response.hasData)
              ? ((response.data!.isEmpty)
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(9),
                        child: Text(
                            'Aucun article ne correspond à votre recherche.'),
                      ),
                    )
                  : _searchArticlesFound(response.data!))
              : const Center(
                  child: CircularProgressIndicator(),
                ));
        }
      },
    );
  }

  Widget _searchArticlesFound(
    List<Article> articles,
  ) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: context.width * 0.9,
          height: context.height * 0.1,
          child: ListTile(
            minLeadingWidth: context.width * 0.2,
            leading: SizedBox(
              width: context.width * 0.2,
              child: Images.network(
                articles[index].image!,
              ),
            ),
            title: Text(htmlParse(articles[index].title)),
            trailing: Text(articles[index].dateFr.year),
            onTap: () {
              goToArticle(articles[index], context: context);
            },
          ),
        );
      },
    );
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
            showResults(context);
          },
        );
      },
    );
  }

  Future<List<Article>> search(String search) async {
    LocalStorage.addToSearchHistory(search);
    return JekyllBlog.searchArticle(search);
  }
}
