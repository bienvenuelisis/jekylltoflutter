import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/screens/tour.dart';

import '../constants/colors.dart';
import '../providers/app_status_provider.dart';
import '../utils/size_config.dart';
import 'main_screen.dart';

class Splash extends ConsumerWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    SizeConfig.init(context);

    AppStatusProvider app = ref.watch(appProvider);

    return app.isAppInit
        ? (app.firstAppUse
            ? const Tour(goTo: Splash())
            : app.offline
                ? NoInternetConnectionPage(
                    goTo: const Splash(),
                    hasLocalBackup: app.offline,
                    retryErrorMessage:
                        "Nous n'avons à nouveau pas pu joindre nos serveurs.",
                    testConnection: () {
                      return app.testConnectivity();
                    },
                  )
                : MainScreen(offlineMode: app.offline))
        : Scaffold(
            body: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              color: AppColors.main,
              child: Stack(
                children: [
                  Positioned(
                    top: SizeConfig.screenHeight / 9,
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: SizeConfig.screenHeight / 2,
                        width: SizeConfig.screenWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    right: SizeConfig.screenWidth / 3,
                    bottom: SizeConfig.screenHeight / 5,
                    width: SizeConfig.screenWidth / 3,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  Positioned(
                    right: SizeConfig.screenWidth / 3,
                    bottom: 25,
                    width: SizeConfig.screenWidth / 3,
                    child: const Center(
                      child: Text(
                        "Chargement...",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
