import 'dart:io';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/services/jekyll_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/colors.dart';
import '../../models/params.dart';
import '../../screens/article_content.dart';
import '../../screens/posts_page.dart';
import '../../screens/splash.dart';
import '../../services/local_storage.dart';
import '../../utils/layout_utilities.dart';
import '../../utils/size_config.dart';
import '../../utils/utils.dart';
import '../../widgets/image.dart';
import '../../widgets/web_view_controller.dart';
import '../app_status_provider.dart';

class PostArticleReadModel extends ChangeNotifier {
  AppStatusProvider app;

  String get authorAvator => "${JekyllBlog.baseUrl}/${article.author!.avatar}";

  final bool _errorWhenLoadingImage = false;

  bool get errorWhenLoadingImage => _errorWhenLoadingImage;

  final bool _errorWhenLoadingCategory = false;

  bool get errorWhenLoadingCategory => _errorWhenLoadingCategory;

  final Article article;

  ArticleReadMode articleTheme =
      LocalStorage.nightMode ? ArticleReadMode.night : ArticleReadMode.light;

  bool _isFavorite = false;

  bool _readItLater = false;

  bool get readItLater => _readItLater;

  bool get isFavorite => _isFavorite;

  Widget get bookMarkIcon => _readItLater
      ? IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.teal),
          onPressed: () {
            removeFromBookmarks();
          },
        )
      : IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.teal),
          onPressed: () {
            addToBookmarks();
          },
        );

  Widget get favoriteIcon => isFavorite
      ? IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            removeFromFavorite();
          },
        )
      : IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.teal),
          onPressed: () {
            addToFavorite();
          },
        );

  PostArticleReadModel(this.article, this.app) {
    updateInfos();
  }

  void darkTheme() {
    articleTheme = ArticleReadMode.night;
    changeTheme();
  }

  void lightTheme() {
    articleTheme = ArticleReadMode.light;
    changeTheme();
  }

  void changeTheme() {
    LocalStorage.nightMode =
        (articleTheme == ArticleReadMode.night ? true : false);
  }

  void updateInfos() {
    updateIsFavorite();
    updateIsToReadLater();

    ///Removed because cause dispose error.
    //app.addListener(() => this.notifyListeners());
    //app.testNetwork();
  }

  void updateIsToReadLater() {
    if (LocalStorage.isReadLaterArticle(article.id.toString())) {
      _readItLater = true;

      notifyListeners();
    }
  }

  void updateIsFavorite() {
    if (LocalStorage.isFavorite(article.id.toString())) {
      _isFavorite = true;

      notifyListeners();
    }
  }

  void addToFavorite() {
    LocalStorage.addToFavoritesPosts(article);
    _isFavorite = true;

    notifyListeners();
  }

  void removeFromFavorite() {
    LocalStorage.removeFromFavoritesPosts(article);
    _isFavorite = false;

    notifyListeners();
  }

  void addToBookmarks() {
    LocalStorage.addToReadLaterArticles(article);
    _readItLater = true;

    notifyListeners();
  }

  void removeFromBookmarks() {
    LocalStorage.removeFromReadLaterArticles(article);
    _readItLater = false;

    notifyListeners();
  }
}

enum ArticleReadMode {
  light,
  night,
}

void goToArticle(
  Article article, {
  bool offlineMode = false,
  required BuildContext context,
}) {
  goTo(
    context,
    ArticleContent(
      article: article,
      offlineMode: offlineMode,
    ),
  );
}

Widget articleWidgetFromUrl(String url, {bool offlineMode = false}) {
  Article? article = articleFromUrl(url);

  if (article == null) {
    return const Splash();
  } else {
    return ArticleContent(
      article: article,
      offlineMode: offlineMode,
    );
  }
}

Article? articleFromUrl(String url) {
  try {
    return JekyllBlog.articles.firstWhere(
      (article) => article.url == url || url.startsWith(article.url),
    );
  } catch (e) {
    return null;
  }
}

void goToArticleUrl(
  String url, {
  bool offlineMode = false,
  required BuildContext context,
}) {
  goToArticle(
    articleFromUrl(url)!,
    offlineMode: offlineMode,
    context: context,
  );
}

void goToCategoryPage(Article article, BuildContext context) {
  goTo(
    context,
    ArticlesListPage(
      ArticlesGetRequestParams(category: article.categoryMain.toLowerCase())
          .fetchPostsOf,
      "Catégorie : ${article.categoryMain}",
    ),
  );
}

void goToAuthorPage(Article article, BuildContext context) {
  goTo(
    context,
    ArticlesListPage(
      JekyllBlog.fromAuthor(
        article.author!,
      ),
      "Articles de ${article.author!.name}",
    ),
  );
}

void goToDateArticlesPage(Article article, BuildContext context) {
  goTo(
    context,
    ArticlesListPage(
      JekyllBlog.thisDate(
        article,
      ),
      "Articles publiés le : ${article.dateFr.complete}",
    ),
  );
}

class PostArticleContentPage extends StatefulWidget {
  final PostArticleReadModel read;

  const PostArticleContentPage({
    required this.read,
    Key? key,
  }) : super(key: key);

  @override
  _PostArticleContentPageState createState() => _PostArticleContentPageState();
}

class _PostArticleContentPageState extends State<PostArticleContentPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            background: _imageArticleBuilder(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          expandedHeight: 250,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            _readArticle(),
          ),
        ),
      ]),
    );
  }

  List<Widget> _readArticle() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
        child: _articleTopInfo(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
        child: _dateArticle(),
      ),
      const SizedBox(height: 21),
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: _articleTitle(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
        child: _dividerUnderTItle(),
      ),
      const SizedBox(height: 21),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 7.5, right: 7.5),
        child: _articleContentHtml(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 7.5, right: 7.5),
        child: _shareContent(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 7.5, right: 7.5),
        child: _authorCard(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 7.5, right: 7.5),
        child: _sameAuthorContents(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 7.5, right: 7.5),
        child: _relatedContents(),
      ),
    ];
  }

  Widget _relatedContents() {
    {
      return Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 5),
              child: Text("Dans la même thématique : ",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontFamily: "Poppins", fontSize: 15)),
            ),
          ),
          widget.read.article.previous == null
              ? const SizedBox.shrink()
              : __articleRelatedCard(widget.read.article.previous!),
          widget.read.article.next == null
              ? const SizedBox.shrink()
              : __articleRelatedCard(widget.read.article.next!),
        ],
      );
    }
  }

  Widget _sameAuthorContents() {
    List<Article> fromAuthor = JekyllBlog.fromAuthor(
      widget.read.article.author!,
      limit: 2,
      excludes: [widget.read.article],
    );

    if (fromAuthor.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 5),
              child: Text("Du même auteur : ",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontFamily: "Poppins", fontSize: 15)),
            ),
          ),
          fromAuthor.isNotEmpty
              ? _articleRelatedCard(fromAuthor[0])
              : const SizedBox.shrink(),
          fromAuthor.length > 1
              ? _articleRelatedCard(fromAuthor[1])
              : const SizedBox.shrink(),
        ],
      );
    }
  }

  Widget __articleRelatedCard(ArticleRelated? article) {
    return (article == null || article.author == null)
        ? const SizedBox.shrink()
        : articleRelatedCard(
            article.url, article.image, article.title, article.dateFr);
  }

  Widget _articleRelatedCard(Article? article) {
    return (article == null || article.author == null)
        ? const SizedBox.shrink()
        : articleRelatedCard(
            article.url,
            article.image,
            article.title,
            article.dateFr.complete,
          );
  }

  Widget articleRelatedCard(
    String url,
    String? image,
    String title,
    String date,
  ) {
    return GestureDetector(
      onTap: () {
        goToArticleUrl(
          url,
          offlineMode: widget.read.app.offline,
          context: context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).textTheme.headline6?.color ??
                    AppColors.main,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6)),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.screenWidth / 3.5,
                  height: getProportionateScreenHeight(99),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).textTheme.headline5?.color ??
                            AppColors.main,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6))),
                  child: Images.network(
                    image!,
                    usePlaceHolder: !LocalStorage.loadImagesMainPostsAuto,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.5,
                        child: RichText(
                          text: TextSpan(
                            text: title,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                          ),
                          textWidthBasis: TextWidthBasis.parent,
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutUtils.iconText(
                        const Icon(
                          Icons.timer,
                          size: 18,
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: "Poppins",
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  void sharePost() {
    Share.share(widget.read.article.url, subject: widget.read.article.title);
  }

  Widget _shareIcon() {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
        sharePost();
      },
    );
  }

  Widget _shareContent() {
    return SizedBox(
      height: 96,
      child: Center(
        child: OutlinedButton(
          style: ButtonStyle(
              animationDuration: const Duration(seconds: 1),
              backgroundColor: MaterialStateProperty.resolveWith((_) {
                return Colors.red[200];
              })),
          onPressed: () {
            sharePost();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text("Partager l'article ! ",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Icon(Icons.share, size: 36, color: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

  Widget _authorCard() {
    return GestureDetector(
      onTap: () => goToAuthorPage(widget.read.article, context),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).textTheme.headline6?.color ??
                  AppColors.main,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => goToAuthorPage(widget.read.article, context),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.read.authorAvator,
                  ),
                  radius: 36,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.read.article.author!.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Poppins",
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: SizeConfig.screenWidth / 1.8,
                      child: RichText(
                        text: TextSpan(
                          text: widget.read.article.author!.bio,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                        ),
                        textWidthBasis: TextWidthBasis.parent,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (widget.read.article.author!.twitter != null &&
                                widget.read.article.author!.twitter!.isNotEmpty)
                            ? IconButton(
                                icon: const Icon(LineAwesomeIcons.twitter,
                                    size: 36, color: Colors.blue),
                                onPressed: () async {
                                  if (await canLaunch(
                                    widget.read.article.author!.twitter!,
                                  )) {
                                    await launch(
                                      widget.read.article.author!.twitter!,
                                    );
                                  } else {
                                    snackbar(
                                      'Erreur',
                                      "Nous n'avons pas pu ouvrir la page Twitter de l'auteur.",
                                    );
                                  }
                                },
                              )
                            : const SizedBox.shrink(),
                        SizedBox(width: SizeConfig.screenWidth / 12),
                        (widget.read.article.author!.email != null &&
                                widget.read.article.author!.email!.isNotEmpty)
                            ? IconButton(
                                icon: const Icon(Icons.email,
                                    size: 36, color: Colors.purple),
                                onPressed: () async {
                                  if (await canLaunch(
                                    widget.read.article.author!.email!,
                                  )) {
                                    await launch(
                                      widget.read.article.author!.email!,
                                    );
                                  } else {
                                    snackbar(
                                      'Erreur',
                                      "Nous n'avons pas pu ouvrir la page sociale principale de l'auteur.",
                                    );
                                  }
                                },
                              )
                            : const SizedBox.shrink(),
                        SizedBox(width: SizeConfig.screenWidth / 12),
                        (widget.read.article.author!.site != null &&
                                widget.read.article.author!.site!.isNotEmpty &&
                                widget.read.article.author!.site !=
                                    widget.read.article.author!.instagram)
                            ? IconButton(
                                icon: const Icon(
                                    LineAwesomeIcons
                                        .alternate_external_link_square,
                                    size: 36,
                                    color: Colors.teal),
                                onPressed: () async {
                                  goTo(
                                    context,
                                    WebViewPage(
                                      title: widget.read.article.author!.name,
                                      url: widget.read.article.author!.site!,
                                    ),
                                  );
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.read.article.author!.instagram != null &&
                                widget
                                    .read.article.author!.instagram!.isNotEmpty)
                            ? IconButton(
                                icon: const Icon(
                                  LineAwesomeIcons.instagram,
                                  size: 36,
                                  color: Colors.purple,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                    widget.read.article.author!.instagram!,
                                  )) {
                                    await launch(
                                      widget.read.article.author!.instagram!,
                                    );
                                  } else {
                                    snackbar('Erreur',
                                        "Nous n'avons pas pu ouvrir la page Instagram de l'auteur.");
                                  }
                                },
                              )
                            : const SizedBox.shrink(),
                      ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateArticle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => goToDateArticlesPage(widget.read.article, context),
          child: Container(
            child: LayoutUtils.iconText(const Icon(Icons.timer),
                Text(widget.read.article.dateFr.complete)),
          ),
        ),
        GestureDetector(
          onTap: () => goToAuthorPage(widget.read.article, context),
          child: Container(
            child: LayoutUtils.iconText(
                const Icon(Icons.person_pin_sharp),
                Text(
                  widget.read.article.author!.name,
                )),
          ),
        )
      ],
    );
  }

  // ignore: unused_element
  Widget _articleDetailsContent() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _articleTopInfo(),
            _dateArticle(),
            const SizedBox(height: 21),
            _articleTitle(),
            _dividerUnderTItle(),
            _articleContentHtml(),
          ],
        ));
  }

  Widget _articleContentHtml() {
    return Html(
      shrinkWrap: true,
      style: {
        "strong": Style(
          fontWeight: FontWeight.bold,
          textDecorationStyle: TextDecorationStyle.solid,
        ),
        "em": Style(
          fontStyle: FontStyle.italic,
        ),
        "h1": Style(
          fontSize: const FontSize(24),
          whiteSpace: WhiteSpace.PRE,
        ),
        "h5": Style(
          fontSize: const FontSize(12),
          whiteSpace: WhiteSpace.PRE,
          alignment: Alignment.center,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
        "h2": Style(
          fontSize: const FontSize(21),
          whiteSpace: WhiteSpace.PRE,
          fontWeight: FontWeight.w600,
        ),
        "h3": Style(
          fontSize: const FontSize(18),
          whiteSpace: WhiteSpace.PRE,
          fontWeight: FontWeight.w300,
        ),
        "h4": Style(
          fontSize: const FontSize(15),
          whiteSpace: WhiteSpace.PRE,
          fontWeight: FontWeight.bold,
        ),
        "li": Style(
          fontStyle: FontStyle.italic,
          lineHeight: const LineHeight(1.5),
          padding: EdgeInsets.only(left: SizeConfig.screenWidth / 10),
          whiteSpace: WhiteSpace.NORMAL,
          display: Display.BLOCK,
        ),
        "p": Style(
          whiteSpace: WhiteSpace.PRE,
        ),
        "a": Style(
          whiteSpace: WhiteSpace.PRE,
          before: "  \t",
        ),
        "blockquote": Style(
          fontStyle: FontStyle.italic,
          textDecoration: TextDecoration.underline,
          color: LocalStorage.nightMode ? Colors.white70 : Colors.black87,
          padding: const EdgeInsets.all(0),
          margin: EdgeInsets.only(
            left: SizeConfig.screenWidth / 18,
            right: SizeConfig.screenWidth / 18,
          ),
        ),
        "html": Style(
          padding: const EdgeInsets.all(1),
          fontFamily: "Poppins",
          textAlign: TextAlign.justify,
          whiteSpace: WhiteSpace.PRE,
          fontSize: FontSize(double.parse(LocalStorage.fontSize.toString())),
          lineHeight: const LineHeight(1.5),
          color: Theme.of(context).textTheme.headline6!.color,
        ),
      },
      data: widget.read.article.content,
      customRender: {
        "img": (RenderContext ctx, Widget child) {
          Map<String, String> attributes = ctx.tree.attributes;

          String? source = attributes['src'];

          if (source == null) {
            return child;
          }

          String url =
              hasHost(source) ? source : ("${JekyllBlog.baseUrl}/$source");

          Widget image = Images.network(url);

          if (LocalStorage.loadImagesInPostsAuto) {
            return GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) => Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.screenHeight / 8,
                      bottom: SizeConfig.screenHeight / 8,
                    ),
                    child: ImagePopup(image: url),
                  ),
                );
              },
              child: image,
            );
          } else {
            return child;
          }
        },
      },
      onImageError: (exception, stack) {},
      onLinkTap: (link, ctx, attributes, element) {
        if (link != null) _goToLink(link, context);
      },
      //navigationDelegateForIframe: (NavigationRequest request) {},
    );
  }

  void ___goToLink(String url, BuildContext context) {
    goTo(context, WebViewPage(title: "Lien externe", url: url));
  }

  void __goToLink(String url, BuildContext context) async {
    if (widget.read.app.online) {
      ___goToLink(
        url,
        context,
      );
    } else {
      if (await widget.read.app.testConnectivity()) {
        ___goToLink(
          url,
          context,
        );
      } else {
        snackbar(
          "Mode Hors Ligne",
          "Veillez vous connecter à Internet pour accéder à ce lien exerne.",
        );
      }
    }
  }

  void _goToLink(String url, BuildContext context) {
    try {
      if (url.contains(JekyllBlog.baseUrl
          .replaceAll("https://", "")
          .replaceAll("http://", "")
          .split("/")[0])) {
        Article? article = articleFromUrl(url);
        if (article == null) {
          __goToLink(url, context);
        } else {
          goToArticle(article, context: context);
        }
      } else {
        __goToLink(url, context);
      }
    } catch (e) {
      __goToLink(url, context);
    }
  }

  // ignore: unused_element
  void _goToYoutubeVideo(Widget child) {
    goTo(
      context,
      Material(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: child,
        ),
      ),
    );
  }

  Widget _dividerUnderTItle() {
    return SizedBox(
        child: const Divider(
          color: Colors.teal,
          thickness: 2,
        ),
        width: MediaQuery.of(context).size.width / 1.5);
  }

  Widget _premiumIcon() {
    bool locked = LocalStorage.lockedPremiumArticle(widget.read.article);
    if (widget.read.article.premium) {
      return IconButton(
        icon: Icon(Icons.stars,
            color: locked ? Colors.amber[900] : Colors.amber[300]),
        onPressed: () {
          if (locked) {
            snackbar("Contenu Premium Bloqué",
                "Vous serez invité à effectuer une action pour débloquer ce contenu.");
          } else {
            snackbar("Contenu Premium Débloqué",
                "Vous pouvez désormais bénéficier de ce contenu sans aucune restriction.");
          }
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _favoriteIcon() {
    if (widget.read.isFavorite) {
      return GestureDetector(
          onTap: () {
            widget.read.removeFromFavorite();
          },
          child: const Icon(Icons.favorite, color: Colors.red));
    } else {
      return GestureDetector(
          onTap: () {
            widget.read.addToFavorite();
          },
          child: const Icon(Icons.favorite_border));
    }
  }

  Widget _themeIcon() {
    if (widget.read.articleTheme == ArticleReadMode.night) {
      return GestureDetector(
        onTap: () {
          widget.read.lightTheme();
        },
        child: const Icon(
          WeatherIcons.day_sunny,
          color: Colors.yellow,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          widget.read.darkTheme();
        },
        child: const Icon(
          WeatherIcons.night_clear,
        ),
      );
    }
  }

  Widget _articleTitle() {
    return Text(
      htmlParse(widget.read.article.title),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _articleTopInfo() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => goToCategoryPage(widget.read.article, context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9),
              ),
              child: _categoryArticleBuilder(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _premiumIcon(),
                const SizedBox(
                  width: 9,
                ),
                _shareIcon(),
                const SizedBox(
                  width: 9,
                ),
                _themeIcon(),
                const SizedBox(
                  width: 9,
                ),
                widget.read.bookMarkIcon,
                const SizedBox(
                  width: 9,
                ),
                _favoriteIcon(),
              ]),
        ),
      ],
    );
  }

  Widget _imgLoading() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 1],
            colors: [Colors.grey, Colors.black]),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  Widget _categoryLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey,
      child: Text(
        htmlParse("..."),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _categoryArticle() {
    return GestureDetector(
      onTap: () => goToCategoryPage(widget.read.article, context),
      child: Text(
        htmlParse(widget.read.article.categoryMain),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _categoryArticleBuilder() {
    return _categoryArticle();
  }

  /* Widget _imageBuilder() {
    return CachedNetworkImage(
      imageUrl: widget.read.article.image,
      placeholder: (_, __) {
        return _imgLoading();
      },
      errorWidget: (_, __, ___) {
        return _imgLoading();
      },
      fit: BoxFit.cover,
    );
  } */

  Widget _imageBuilder() {
    return Images.network(
      widget.read.article.image!,
      fit: BoxFit.cover,
      loader: _imgLoading(),
      usePlaceHolder: !LocalStorage.loadImagesMainPostsAuto,
    );
  }

  Widget _imageArticleBuilder() {
    return _imageBuilder();
  }
}

bool hasHost(String attribute) {
  try {
    return attribute.contains("www") || attribute.contains("http");
  } catch (e) {
    return false;
  }
}

class ImagePopup extends StatelessWidget {
  final String image;

  final BoxDecoration decoration = const BoxDecoration(
    color: Colors.transparent,
  );

  const ImagePopup({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      tightMode: true,
      backgroundDecoration: decoration,
      imageProvider: NetworkImage(image),
    );
  }
}
