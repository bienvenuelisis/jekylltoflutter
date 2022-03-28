import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../services/local_storage.dart';
import '../constants/themes.dart';
import '../services/jekyll_blog.dart';

final appProvider = ChangeNotifierProvider(
  (ref) => AppStatusProvider(),
);

class AppStatusProvider extends ChangeNotifier {
  bool _isAppInit = false;

  bool get isAppInit => _isAppInit;

  bool _testingConnectivity = false;

  bool get testingConnectivity => _testingConnectivity;

  bool _online = false;

  bool get online => _online;

  bool get offline => !online;

  Future<void> refresh() async {
    _online = await testConnectivity();

    notifyListeners();
  }

  Future<bool> _testConnectivity() async {
    try {
      http.Response connected = await http.get(Uri.parse(JekyllBlog.baseUrl));
      return connected.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> testConnectivity() async {
    _testingConnectivity = true;
    notifyListeners();

    bool online = (await _testConnectivity());

    _testingConnectivity = false;
    notifyListeners();
    return online;
  }

  bool get firstAppUse => LocalStorage.isFirstAppUse();

  AppStatusProvider() {
    initApp();
  }

  Future<void> initApp() async {
    await JekyllBlog.startup();

    _isAppInit = false;
    _online = await _testConnectivity();
    _testingConnectivity = false;
    notifyListeners();

    await setupInitialization();

    await setupBlogContents();

    notifyListeners();
  }

  Future<void> setupInitialization() async {
    await LocalStorage.init();

    Themes.init(LocalStorage.nightMode);

    notifyListeners();
  }

  Future<bool> setupBlogContents() async {
    try {
      if (await testConnectivity()) {
        try {
          _isAppInit = await JekyllBlog.init();

          notifyListeners();
        } catch (e) {
          await tryRestoreBackUp();
        }
      } else {
        await tryRestoreBackUp();
      }
    } catch (e) {
      await tryRestoreBackUp();
    }

    return _isAppInit;
  }

  Future<void> tryRestoreBackUp() async {
    try {
      _online = (JekyllBlog.hasBackUp && await JekyllBlog.restoreBackUp());
      _isAppInit = true;
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
  }
}
