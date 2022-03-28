import 'package:jekylltoflutter/providers/articles/bookmark_provider.dart';
import 'package:jekylltoflutter/providers/articles/post_article_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/screens/search.dart';

import '../services/local_storage.dart';
import 'favorites.dart';

final bookmarksProvider = ChangeNotifierProvider((_) => BookmarkProvider());

class ToReadLaterPage extends ConsumerWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  ToReadLaterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    BookmarkProvider bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'A lire plus tard',
          style: TextStyle(
            color: LocalStorage.nightMode ? Colors.white70 : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              bookmarks.refreshContents();
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
      body: _bookmarksArticlesProvider(bookmarks, context),
    );
  }

  List<Widget> articlesConsumer(BookmarkProvider bookMark) {
    return bookMark.bookmarksPosts
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
        .toList();
  }

  Widget _builderArticlesBookmarksList(BookmarkProvider bookMark) {
    List<Widget> articlesEl = articlesConsumer(bookMark);

    if (!bookMark.complete) {
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
      },
    );
  }

  Widget _bookmarksArticlesProvider(
      BookmarkProvider bookMark, BuildContext context) {
    if (bookMark.loading) {
      return _loading();
    } else {
      if (bookMark.error) {
        return _error(bookMark, context);
      } else {
        if (bookMark.complete && bookMark.count == 0) {
          return _noBookmarks(context);
        } else {
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: () => bookMark.refreshContents(),
            child: _builderArticlesBookmarksList(bookMark),
          );
        }
      }
    }
  }

  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _noBookmarks(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          'Aucun article à lire plus tard enregistré.',
          style: TextStyle(
            fontSize: 21,
            fontFamily: "Poppins",
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
      ),
    );
  }

  Widget __error(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          'Une erreur s\'est produite lors du chargement de vos articles à lire plus tard.\n \n Réessayez ultérieurement.',
          style: TextStyle(
            fontSize: 21,
            fontFamily: "Poppins",
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
      ),
    );
  }

  Widget _error(BookmarkProvider bookMark, BuildContext context) {
    List<Widget> articlesEl = articlesConsumer(bookMark);

    articlesEl.add(Consumer(
      builder: (_, __, ___) {
        return __error(context);
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
