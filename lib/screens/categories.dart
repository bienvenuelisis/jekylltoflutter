import 'package:jekylltoflutter/providers/articles/category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/articles/search_advanced.dart';
import '../services/local_storage.dart';
import '../utils/utils.dart';

final categoriesPagesProvider =
    ChangeNotifierProvider((ref) => CategoryPageModelList());

class CategoriesArticlePage extends ConsumerWidget {
  const CategoriesArticlePage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBarDefault(
    BuildContext context,
    CategoryPageModelList categoryNotifier,
  ) {
    return AppBar(
      elevation: 0,
      brightness: Brightness.light,
      title: const Text('Chargement...'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: SearchArticle());
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            categoryNotifier.refreshCategories();
          },
          icon: const Icon(
            Icons.sync,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _loadingCategories(
      BuildContext context, CategoryPageModelList categoryNotifier) {
    return Scaffold(
      appBar: _appBarDefault(context, categoryNotifier),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _categoriesArticlesPageLayout(
      BuildContext context, CategoryPageModelList categoriesPage) {
    return DefaultTabController(
      length: categoriesPage.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Catégories & Tags',
            style: TextStyle(
              color: LocalStorage.nightMode ? Colors.white70 : Colors.white,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: SearchArticle());
              },
            ),
            const SizedBox(width: 10),
            IconButton(
                icon: const Icon(Icons.sync, color: Colors.white),
                onPressed: () {
                  categoriesPage.refreshCategories();
                }),
            const SizedBox(width: 10),
          ],
          bottom: TabBar(
            tabs: categoriesTabs(categoriesPage.categories),
            isScrollable: true,
            labelColor: LocalStorage.nightMode ? Colors.white70 : Colors.white,
            unselectedLabelColor:
                LocalStorage.nightMode ? Colors.white24 : Colors.black87,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor:
                LocalStorage.nightMode ? Colors.white70 : Colors.white,
          ),
        ),
        body: TabBarView(
            children: categoriesPage.categoriesNotifiers
                .map((categoryPage) => Consumer(
                      builder: (context, ref, child) {
                        return CategoryPageWidget(
                          categoryPage: ref.watch(categoryPage),
                        );
                      },
                    ))
                .toList()),
      ),
    );
  }

  List<Widget> categoriesTabs(List<String> categories) {
    return categories.map((category) => categoryTab(category)).toList();
  }

  Widget categoryTab(String category) {
    return Tab(text: htmlParse(category));
  }

  @override
  Widget build(BuildContext context, ref) {
    CategoryPageModelList categoryNotifier = ref.watch(categoriesPagesProvider);
    return _categoriesArticlesPage(categoryNotifier, context);
  }

  Widget _categoriesArticlesPage(
      CategoryPageModelList categoriesPage, BuildContext context) {
    if (categoriesPage.loading) {
      return _loadingCategories(context, categoriesPage);
    } else {
      if (categoriesPage.error) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 4),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    "Impossible de charger les catégories."
                    " \n\nVérifiez votre connexion internet et relancer l'Application.",
                    style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  categoriesPage.refreshCategories();
                },
                child: const Text(
                  "Recharger les catégories",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        if (categoriesPage.count == 0) {
          return const Padding(
            padding: EdgeInsets.all(9),
            child: Center(
              child: Text(
                "Aucune catégorie à charger.",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else {
          return _categoriesArticlesPageLayout(context, categoriesPage);
        }
      }
    }
  }
}
