import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/providers/articles/articles_recents_model.dart';

import '../screens/home.dart';

final menuProvider = ChangeNotifierProvider(
  (ref) => MenuNotifier(
    index: 0,
    view: ref.read(articlesRecentsProvider),
  ),
);

class MenuNotifier extends ChangeNotifier {
  late int _index;

  late PageController _pageController;

  PageController get controller => _pageController;

  int get index => _index;

  final ArticlesRecentsModel view;

  MenuNotifier({int index = 0, required this.view}) {
    _index = index;
    _pageController = PageController(initialPage: index, keepPage: true);
    notifyListeners();
  }

  void scrollToTop() {
    view.scroller.animateTo(
      0.0,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1800),
    );
  }

  void changeMenu(int index) {
    if (index == _index && index == 0) {
      scrollToTop();
    } else {
      _index = index;
      _pageController.jumpToPage(index);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }
}
