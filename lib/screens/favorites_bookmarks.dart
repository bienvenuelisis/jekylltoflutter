import 'package:flutter/material.dart';

import '../services/local_storage.dart';
import 'bookmarks.dart';
import 'favorites.dart';

class FavoritesBookmarks extends StatelessWidget {
  const FavoritesBookmarks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            labelColor: LocalStorage.nightMode ? Colors.white70 : Colors.white,
            unselectedLabelColor:
                LocalStorage.nightMode ? Colors.white24 : Colors.black87,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor:
                LocalStorage.nightMode ? Colors.white70 : Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.favorite),
                text: "Favoris",
              ),
              Tab(
                icon: Icon(Icons.bookmark),
                text: "A lire plus tard",
              ),
            ],
          ),
          elevation: 0,
          title: Text(
            'Favoris & A lire',
            style: TextStyle(
              color: LocalStorage.nightMode ? Colors.white70 : Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Favorites(),
            ToReadLaterPage(),
          ],
        ),
      ),
    );
  }
}
