import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../constants/themes.dart';

class DataUsageSettings extends StatefulWidget {
  const DataUsageSettings({Key? key}) : super(key: key);

  @override
  State<DataUsageSettings> createState() => _DataUsageSettingsState();
}

class _DataUsageSettingsState extends State<DataUsageSettings> {
  bool _loadImagesMainPostsAuto = true;

  bool get loadImagesMainPostsAuto => _loadImagesMainPostsAuto;

  set loadImagesMainPostsAuto(bool value) {
    setState(() {
      _loadImagesMainPostsAuto = value;
    });
  }

  bool _loadImagesInPostsAuto = true;

  bool get loadImagesInPostsAuto => _loadImagesInPostsAuto;

  set loadImagesInPostsAuto(bool value) {
    setState(() {
      _loadImagesInPostsAuto = value;
    });
  }

  bool _loadVideosInPostsAuto = true;

  bool get loadVideosInPostsAuto => _loadVideosInPostsAuto;

  set loadVideosInPostsAuto(bool value) {
    setState(() {
      _loadVideosInPostsAuto = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Utilisation des données mobiles"),
      ),
      body: SettingsList(
        darkTheme: Themes.settingsDarkTheme,
        lightTheme: Themes.settingsLightTheme,
        contentPadding: const EdgeInsets.all(0),
        applicationType: ApplicationType.material,
        sections: [
          SettingsSection(
            title: const Text('Charger par défaut les affiches des articles.'),
            margin: const EdgeInsetsDirectional.all(15),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Charger les affiches des articles.'),
                description: const Text("Page d'accueil, des catégories, favoris..."),
                initialValue: loadImagesMainPostsAuto,
                onToggle: (bool value) {
                  loadImagesMainPostsAuto = value;
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Charger les images contenues dans les articles.'),
            margin: const EdgeInsetsDirectional.all(15),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Charger les contenus images.'),
                description: const Text("Charger par défaut les images dans un article."),
                initialValue: loadImagesInPostsAuto,
                onToggle: (bool value) {
                  loadImagesInPostsAuto = value;
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Charger les vidéos contenues dans les articles.'),
            margin: const EdgeInsetsDirectional.all(15),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Charger les contenus vidéos.'),
                description: const Text("Charger par défaut les vidéos dans un article."),
                initialValue: loadVideosInPostsAuto,
                onToggle: (bool value) {
                  loadVideosInPostsAuto = value;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
