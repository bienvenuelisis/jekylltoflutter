// ignore_for_file: deprecated_member_use

import 'package:jekylltoflutter/providers/articles/articles_main_model.dart';
import 'package:jekylltoflutter/providers/articles/articles_recents_model.dart';
import 'package:jekylltoflutter/providers/menu_notifier.dart';
import 'package:jekylltoflutter/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/colors.dart';
import '../providers/app_status_provider.dart';
import '../services/local_storage.dart';
import '../utils/utils.dart';
import 'page_data_usage_resume.dart';

final articlesRecentsProvider =
    ChangeNotifierProvider((_) => ArticlesRecentsModel());
final articlesMainsProvider =
    ChangeNotifierProvider((_) => ArticlesMainModel());

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  double heightMainArticle() {
    return MediaQuery.of(context).size.height / 2.4;
  }

  Future<void> testNetwork(
    ArticlesRecentsModel articlesRecents,
    ArticlesMainModel articlesMains,
    AppStatusProvider app,
  ) async {
    if (await app.testConnectivity()) {
      refreshAllContents(articlesRecents, articlesMains, app);
      snackbar(
        "Vous êtes a nouveau connecté.",
        """Mise à jour des contenus en cours...""",
      );
    } else {
      snackbar(
        "Hors ligne",
        """Cette îcone sert à vous indiquer que vous êtes en mode hors-ligne.""",
      );
    }
  }

  Future<void> refreshAllContents(
    ArticlesRecentsModel articlesRecents,
    ArticlesMainModel articlesMains,
    AppStatusProvider app,
  ) async {
    articlesMains.loading = true;
    articlesRecents.loading = true;
    if (await app.setupBlogContents()) {
      articlesMains.refreshContents();
      articlesRecents.refreshContents();
    } else {
      articlesMains.loading = false;
      articlesRecents.loading = false;

      if (await app.testConnectivity()) {
        snackbar("Erreur", """Impossible de mettre à jour les articles.
          \n Réessayer ultérieurement.""");
      } else {
        snackbar("Erreur", """Impossible de joindre nos serveurs.
          \n Vérifier que vous disposez d'une connexion Internet.""");
      }
    }

    return;
  }

  supTitle(bool nightMode, String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: nightMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          decoration: const BoxDecoration(
              border: Border(
            left: BorderSide(width: 5.0, color: Colors.teal),
          )),
        ),
      ],
    );
  }

  supTitleWithButton(bool nightMode, String title, BuildContext context,
      void Function() navigate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: nightMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          decoration: const BoxDecoration(
              border: Border(
            left: BorderSide(width: 5.0, color: Colors.teal),
          )),
        ),
        FlatButton(
          child: Text(
            "Voir tout",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            navigate();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ArticlesRecentsModel articlesRecents =
            ref.watch(articlesRecentsProvider);

        ArticlesMainModel articlesMains = ref.watch(articlesMainsProvider);

        final menu = ref.watch(menuProvider);
        
        AppStatusProvider app = ref.watch(appProvider);

        bool nightMode = LocalStorage.nightMode;

        return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              brightness: AppColors.bright(app.offline),
              title: Text(
                'Accueil',
                style: TextStyle(
                  color: nightMode ? Colors.white70 : Colors.white,
                ),
              ),
              actions: <Widget>[
                app.offline
                    ? IconButton(
                        onPressed: () {
                          testNetwork(articlesRecents, articlesMains, app);
                        },
                        icon: Icon(
                          Icons.signal_wifi_off_sharp,
                          color: nightMode ? Colors.white70 : Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
                IconButton(
                  onPressed: () {
                    goTo(context, const PageDataUsageResume());
                  },
                  icon: Icon(
                    Icons.data_usage,
                    color: nightMode ? Colors.white70 : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    refreshAllContents(articlesRecents, articlesMains, app);
                  },
                  icon: Icon(
                    Icons.sync,
                    color: nightMode ? Colors.white70 : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: SearchArticle());
                  },
                  icon: Icon(
                    Icons.search,
                    color: nightMode ? Colors.white70 : Colors.white,
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              key: refreshKey,
              onRefresh: () =>
                  refreshAllContents(articlesRecents, articlesMains, app),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                controller: articlesRecents.scroller,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      supTitle(nightMode, 'A la une', context),
                      const SizedBox(height: 10.0),
                      MainArticlesBuilder(
                          articlesMains, articlesMains.pageController),
                      const SizedBox(height: 10.0),
                      articlesMains.loading
                          ? const SizedBox.shrink()
                          : Center(
                              child: SmoothPageIndicator(
                                controller: articlesMains
                                    .pageController, // PageController
                                count: articlesMains.count,
                                effect: const ExpandingDotsEffect(
                                  spacing: 8.0,
                                  radius: 4.0,
                                  dotWidth: 18.0,
                                  dotHeight: 3.0,
                                  paintStyle: PaintingStyle.fill,
                                  strokeWidth: 1.5,
                                  dotColor: Colors.grey,
                                  activeDotColor: Colors.indigo,
                                ), // your preferred effect
                                onDotClicked: (index) {
                                  articlesMains.pageController
                                      .jumpToPage(index);
                                },
                              ),
                            ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 20.0),
                      supTitleWithButton(
                          nightMode, 'Derniers articles', context, () {
                        menu.changeMenu(1);
                      }),
                      LastArticleBuilder(articlesRecents),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
