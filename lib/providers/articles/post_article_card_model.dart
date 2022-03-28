import 'package:jekylltoflutter/models/index.dart';
import 'package:jekylltoflutter/providers/articles/bookmark_provider.dart';
import 'package:jekylltoflutter/providers/articles/favorite_page.dart';
import 'package:jekylltoflutter/providers/articles/post_article_read_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../screens/article_content.dart';
import '../../services/local_storage.dart';
import '../../utils/layout_utilities.dart';
import '../../utils/size_config.dart';
import '../../utils/utils.dart';
import '../../widgets/image.dart';

class ArticleModelCard extends ChangeNotifier {
  final bool _errorWhenLoadingImage = false;

  bool get errorWhenLoadingImage => _errorWhenLoadingImage;

  final bool _errorWhenLoadingCategory = false;

  bool get errorWhenLoadingCategory => _errorWhenLoadingCategory;

  final Article article;

  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  bool _isInBookMarks = false;

  bool get isInBookMarks => _isInBookMarks;

  //Use full only when to have to execute another request (async to get right category information, eg. Wordpress).
  final bool _categoryIsLoading = false;

  //Use full only when to have to execute another request (async to get right image/image format, eg. Wordpress).
  final bool _imageIsLoading = false;

  bool get categoryIsLoading => _categoryIsLoading;

  bool get imageIsLoading => _imageIsLoading;

  Widget get bookMarkIcon => isInBookMarks
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
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () {
            removeFromFavorite();
          },
        )
      : IconButton(
          icon: const Icon(
            Icons.favorite_border,
            color: Colors.teal,
          ),
          onPressed: () {
            addToFavorite();
          },
        );

  final FavoriteProvider favorites;

  final BookmarkProvider bookmarks;

  ArticleModelCard(
    this.article,
    this.favorites,
    this.bookmarks,
  ) {
    updateInfos();
  }

  void updateInfos() {
    updateIsFavorite();
    updateIsBookmark();
  }

  void updateIsBookmark() {
    if (LocalStorage.isReadLaterArticle(article.id.toString())) {
      _isInBookMarks = true;

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

    favorites.refreshContents();
  }

  void removeFromFavorite() {
    LocalStorage.removeFromFavoritesPosts(article);
    _isFavorite = false;

    notifyListeners();

    favorites.refreshContents();
  }

  void addToBookmarks() {
    LocalStorage.addToReadLaterArticles(article);
    _isInBookMarks = true;

    notifyListeners();

    bookmarks.refreshContents();
  }

  void removeFromBookmarks() {
    LocalStorage.removeFromReadLaterArticles(article);
    _isInBookMarks = false;

    notifyListeners();

    bookmarks.refreshContents();
  }
}

class ArticleCard extends StatefulWidget {
  final ArticleModelCard articleModel;

  const ArticleCard({
    required this.articleModel,
    Key? key,
  }) : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return articleCategoryCard(context);
  }

  Widget _premiumIcon() {
    bool locked =
        LocalStorage.lockedPremiumArticle(widget.articleModel.article);
    if (widget.articleModel.article.premium) {
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
    if (widget.articleModel.isFavorite) {
      return IconButton(
        icon: const Icon(Icons.favorite, color: Colors.red),
        onPressed: () {
          widget.articleModel.removeFromFavorite();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.favorite_border),
        onPressed: () {
          widget.articleModel.addToFavorite();
        },
      );
    }
  }

  Widget  articleCategoryCard(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.5,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: [
          Stack(
            children: [
              GestureDetector(
                child: _imageArticleBuilder(),
                onTap: () {
                  goToArticle();
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    goToCategoryPage(widget.articleModel.article, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    child: _categoryArticleBuilder(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text(widget.articleModel.article.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  onTap: () {
                    goToArticle();
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        goToDateArticlesPage(
                            widget.articleModel.article, context);
                      },
                      child: Container(
                        child: LayoutUtils.iconText(
                          const Icon(Icons.timer),
                          Text(
                            widget.articleModel.article.dateFr.complete,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _premiumIcon(),
                        _shareIcon(),
                        widget.articleModel.bookMarkIcon,
                        _favoriteIcon(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void goToArticle() {
    goTo(
      context,
      ArticleContent(
        article: widget.articleModel.article,
      ),
    );
  }

  Widget _categoryArticle(String category) {
    return Text(
      htmlParse(category),
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  Widget _categoryLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey,
      child: const Text(
        "...",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  /* Widget _imageBuilder() {
    return ClipRRect(
      child: Image(
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return _imgLoading();
        },
        image: PCacheImage(widget.articleModel.article.image),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    );
  } */

  /* Widget _imageBuilder() {
    return ClipRRect(
      child: CachedNetworkImage(
        errorWidget: (_, __, ___) => _imgLoading(),
        placeholder: (_, __) => _imgLoading(),
        imageUrl: widget.articleModel.article.image,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    );
  } */

  void sharePost() {
    Share.share(
      widget.articleModel.article.url,
      subject: widget.articleModel.article.title,
    );
  }

  Widget _shareIcon() {
    return IconButton(
        icon: const Icon(Icons.share),
        onPressed: () {
          sharePost();
        });
  }

  Widget _imageBuilder() {
    double round = LocalStorage.nightMode ? 0 : 15;
    return ClipRRect(
      child: Images.network(
        widget.articleModel.article.image!,
        usePlaceHolder: !LocalStorage.loadImagesMainPostsAuto,
        loader: _imgLoading(),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(round),
        topRight: Radius.circular(round),
      ),
    );
  }

  Widget _imgLoading() {
    double round = LocalStorage.nightMode ? 0 : 15;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 1],
            colors: [Colors.grey, Colors.black]),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(round),
          topRight: Radius.circular(round),
        ),
      ),
    );
  }

  Widget _imageArticleBuilder() {
    if (widget.articleModel.imageIsLoading) {
      return _imgLoading();
    } else if (widget.articleModel.article.image == null ||
        widget.articleModel.errorWhenLoadingImage) {
      return _imgLoading();
    } else {
      return _imageBuilder();
    }
  }

  Widget _categoryArticleBuilder() {
    if (widget.articleModel.categoryIsLoading ||
        widget.articleModel.errorWhenLoadingCategory) {
      return _categoryLoading();
    } else {
      return _categoryArticle(widget.articleModel.article.categoryMain);
    }
  }
}
