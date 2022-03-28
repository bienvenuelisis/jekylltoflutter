import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jekylltoflutter/providers/menu_notifier.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'bookmarks.dart';
import 'categories.dart';
import 'favorites.dart';
import 'home.dart';
import 'settings_page/settings_page.dart';

class MainScreen extends StatefulWidget {
  final bool offlineMode;

  const MainScreen({Key? key, this.offlineMode = false}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final menu = ref.watch(menuProvider);

        return Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: menu.controller,
            //onPageChanged: menu.changeMenu,
            children: <Widget>[
              const Home(),
              const CategoriesArticlePage(),
              ToReadLaterPage(),
              Favorites(),
              const SettingsPage(),
            ],
          ),
          bottomNavigationBar: SalomonBottomBar(
            selectedItemColor: Colors.teal,
            unselectedItemColor: Theme.of(context).textTheme.headline6!.color,
            items: <SalomonBottomBarItem>[
              SalomonBottomBarItem(
                icon: const Icon(
                  Icons.home,
                ),
                title: const Text('Accueil'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(LineAwesomeIcons.list),
                title: const Text('Tags'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.bookmark),
                title: const Text('A lire'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite),
                title: const Text('Favoris'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.settings),
                title: const Text(''),
              ),
            ],
            onTap: menu.changeMenu,
            currentIndex: menu.index,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
