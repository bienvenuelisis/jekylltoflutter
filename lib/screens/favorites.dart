import 'package:jekylltoflutter/providers/articles/favorite_page.dart';
import 'package:jekylltoflutter/providers/articles/post_article_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/screens/search.dart';

import '../services/local_storage.dart';
import 'bookmarks.dart';

final favoritesProvider = ChangeNotifierProvider((_) => FavoriteProvider());

class Favorites extends ConsumerWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    FavoriteProvider favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoris',
          style: TextStyle(
            color: LocalStorage.nightMode ? Colors.white70 : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              favorites.refreshContents();
            },
            icon: Icon(
              Icons.sync,
              color: LocalStorage.nightMode ? Colors.white70 : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchArticle());
            },
            icon: Icon(
              Icons.search,
              color: LocalStorage.nightMode ? Colors.white70 : Colors.white,
            ),
          ),
        ],
      ),
      body: _favoritesArticlesProvider(favorites, context),
    );
  }

  List<Widget> articlesConsumer(FavoriteProvider favorite) {
    return favorite.favoritesPosts
        .map(
          (post) => Consumer(
            builder: (context, ref, child) {
              return ArticleCard(
                articleModel: ref.watch(ChangeNotifierProvider(
                  (ref) => ArticleModelCard(
                    post,
                    ref.read(favoritesProvider),
                    ref.read(bookmarksProvider),
                  ),
                )),
              );
            },
          ),
        )
        .toList();
  }

  Widget _builderArticlesFavoritesList(FavoriteProvider favorite) {
    List<Widget> articlesEl = articlesConsumer(favorite);

    if (!favorite.complete) {
      articlesEl.add(Consumer(builder: (_, __, ___) {
        return const Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }));
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: articlesEl.length,
        itemBuilder: (context, index) {
          return articlesEl[index];
        });
  }

  Widget _favoritesArticlesProvider(
      FavoriteProvider favorite, BuildContext context) {
    if (favorite.loading) {
      return _loading();
    } else {
      if (favorite.error) {
        return _error(favorite);
      } else {
        if (favorite.complete && favorite.count == 0) {
          return _noFavorite(context);
        } else {
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: () => favorite.refreshContents(),
            child: _builderArticlesFavoritesList(favorite),
          );
        }
      }
    }
  }

  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _noFavorite(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          'Aucun favori ajouté.',
          style: TextStyle(
            fontSize: 21,
            fontFamily: "Poppins",
            color: Theme.of(context).textTheme.headline6!.color, /*  */
          ),
        ),
      ),
    );
  }

  Widget __error() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          'Une erreur s\'est produite lors du chargement de vos favoris.\n \n Réessayez ultérieurement.',
          style: TextStyle(fontSize: 21, fontFamily: "Poppins"),
        ),
      ),
    );
  }

  Widget _error(FavoriteProvider favorite) {
    List<Widget> articlesEl = articlesConsumer(favorite);

    articlesEl.add(Consumer(
      builder: (_, __, ___) {
        return __error();
      },
    ));

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: articlesEl.length,
      itemBuilder: (context, index) {
        return articlesEl[index];
      },
    );
  }
}
