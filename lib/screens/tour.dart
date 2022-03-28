import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../services/jekyll_blog.dart';
import '../services/local_storage.dart';
import '../utils/size_config.dart';
import '../utils/utils.dart';
import 'main_screen.dart';
// ignore: unused_import
import 'splash.dart';

typedef WaitFutureBool = Future<bool> Function();

class NoInternetConnectionPage extends StatelessWidget {
  const NoInternetConnectionPage({
    Key? key,
    this.hasLocalBackup = false,
    required this.testConnection,
    required this.goTo,
    this.retryErrorMessage,
  }) : super(key: key);

  final bool hasLocalBackup;

  final WaitFutureBool testConnection;

  final Widget goTo;

  final String? retryErrorMessage;

  void resolveIt() async {
    if (await testConnection()) {
      Get.offAll(() => goTo);
    } else {
      snackbar(
        "Erreur",
        retryErrorMessage ??
            "Nous avons du mal à accéder à ${JekyllBlog.name}.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 36, right: 36),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Image.asset(
                  "assets/error.png",
                  height: context.height / 4,
                  width: context.width / 2,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                  "Une erreur s'est produite lors de la connexion à notre serveur.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins')),
              const SizedBox(height: 36),
              const Text(
                "Vérifiez que votre appareil a un accès à Internet."
                " \n\n Si l'erreur provient de nous, nos équipes sont "
                "informées et travaillent pour y rémedier.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Center(
                    child: OutlinedButton(
                      style: ButtonStyle(
                          animationDuration: const Duration(seconds: 1),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((_) {
                            return Colors.black12;
                          })),
                      onPressed: () {
                        resolveIt();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Retenter la connexion.",
                              style: TextStyle(fontSize: 18)),
                          Icon(Icons.refresh, size: 36)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Ou'),
                  const SizedBox(height: 15),
                  hasLocalBackup
                      ? Center(
                          child: OutlinedButton(
                            style: ButtonStyle(
                                animationDuration: const Duration(seconds: 1),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((_) {
                                  return Colors.teal;
                                })),
                            onPressed: () {
                              Get.offAll(
                                  () => const MainScreen(offlineMode: true));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text("Utiliser en hors-ligne.",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                                Icon(Icons.offline_bolt,
                                    size: 36, color: Colors.white)
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: OutlinedButton(
                            style: ButtonStyle(
                                animationDuration: const Duration(seconds: 1),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((_) {
                                  return Colors.teal;
                                })),
                            onPressed: () {
                              // TODO: Require access to application scoped storage.
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Autoriser les sauvegardes.",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Icon(Icons.offline_bolt,
                                    size: 36, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class PermissionsDeniedPage extends StatelessWidget {
  const PermissionsDeniedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 36, right: 36),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Image.asset(
                  "assets/disappointed.png",
                  height: SizeConfig.screenHeight / 4,
                  width: SizeConfig.screenWidth / 2,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                  "Noir Meilleur a besoin de certains accès pour fonctionner correctement.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins')),
              const SizedBox(height: 36),
              const Text(
                  "Veillez donner les permissions nécessaires en cliquant sur le bouton ci-dessous.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, fontFamily: 'Poppins')),
              const SizedBox(height: 15),
              Column(
                children: [
                  Center(
                    child: OutlinedButton(
                      style: ButtonStyle(
                          animationDuration: const Duration(seconds: 1),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((_) {
                            return Colors.black12;
                          })),
                      onPressed: () {
                        // TODO: Require access to application scoped storage.
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Autoriser", style: TextStyle(fontSize: 18)),
                          Icon(Icons.check, size: 36)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Ou'),
                  const SizedBox(height: 15),
                  Center(
                    child: OutlinedButton(
                      style: ButtonStyle(
                          animationDuration: const Duration(seconds: 1),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((_) {
                            return Colors.teal;
                          })),
                      onPressed: () {
                        // ToDo : Now you have access to application scoped storage. So you need to backup/restore your application site information (general and posts).
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Continuer vers les articles ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Icon(Icons.article, size: 36, color: Colors.white)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class Tour extends StatelessWidget {
  final Widget goTo;

  const Tour({Key? key, required this.goTo}) : super(key: key);

  void onTourEnd() async {
    LocalStorage.setAppFirstUsage();
  }

  @override
  Widget build(BuildContext context) {
    return _introduction(context);
  }

  static PageViewModel one = PageViewModel(
    title: "Bienvenue !",
    bodyWidget: const Text(
      "Noir Meilleur, c'est le média d'Informations et d'Actualités sur l'Afrique et sa diaspora, par les Africains."
      "\n\n Quelques étapes pour profiter au mieux de cette application.",
      style: TextStyle(
        fontFamily: "Poppins",
      ),
      textAlign: TextAlign.justify,
    ),
    decoration: const PageDecoration(),
    image: Center(
      child: Image.asset(
        "assets/tour/africa_colors.png",
        height: SizeConfig.screenHeight / 3,
        width: SizeConfig.screenWidth / 1.5,
      ),
    ),
  );

  static PageViewModel two = PageViewModel(
    title: "Permissions",
    bodyWidget: const Text(
      "Noir Meilleur vous offre la possibilité de continuer à lire tous les articles "
      "même lorsque vous n'avez plus un accès Internet."
      "\n\n Nous enregistrons donc lors de vos lectures "
      "une version formatée et compressée des articles.",
      style: TextStyle(fontFamily: "Poppins"),
      textAlign: TextAlign.justify,
    ),
    decoration: const PageDecoration(),
    image: Center(
      child: Image.asset(
        "assets/tour/africa.png",
        height: SizeConfig.screenHeight / 3,
        width: SizeConfig.screenWidth / 1.5,
      ),
    ),
  );

  static PageViewModel three = PageViewModel(
    title: "La communauté",
    bodyWidget: const Text(
      "Noir Meilleur est une oeuvre commune."
      "\n\n Si vous souhaitez contribuer ou avoir de nos nouvelles, naviguez "
      "vers la section A propos de l'application pour accéder à nos pages "
      "sur les réseaux sociaux.",
      style: TextStyle(fontFamily: "Poppins"),
      textAlign: TextAlign.justify,
    ),
    decoration: const PageDecoration(),
    image: Center(
        child: Image.asset(
      "assets/tour/africa_elephant.png",
      height: SizeConfig.screenHeight / 3,
      width: SizeConfig.screenWidth / 1.5,
    )),
  );

  static PageViewModel four = PageViewModel(
    title: "Ensemble",
    bodyWidget: const Text(
      "Si vous appréciez les contenus, partagez les et l'application à votre entourage."
      "\n\n Nous sommes également ouverts aux critiques et remarques constructifs."
      "\n\n C'est l'Afrique qui gagne !",
      style: TextStyle(fontFamily: "Poppins"),
      textAlign: TextAlign.justify,
    ),
    decoration: const PageDecoration(),
    image: Center(
        child: Image.asset(
      "assets/tour/africa_smile.png",
      height: SizeConfig.screenHeight / 3,
      width: SizeConfig.screenWidth / 1.5,
    )),
  );

  static List<PageViewModel> introPages = [one, two, three, four];

  Widget _introduction(BuildContext context) {
    return IntroductionScreen(
      pages: introPages,
      onDone: () {
        onTourEnd();

        pushTo(context, goTo, true);
      },
      showSkipButton: false,
      next: Row(
        children: const [
          Text("Suivant"),
          Icon(Icons.navigate_next),
        ],
      ),
      done: const Text(
        "Terminer",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.teal,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
