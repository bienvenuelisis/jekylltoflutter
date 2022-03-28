import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../constants/themes.dart';
import '../../utils/utils.dart';
import 'favorite_delete_after.dart';

class FavoritesSettings extends StatefulWidget {
  const FavoritesSettings({Key? key}) : super(key: key);

  @override
  State<FavoritesSettings> createState() => _FavoritesSettingsState();
}

class _FavoritesSettingsState extends State<FavoritesSettings> {
  bool _keepFavorite = true;

  bool get keepFavorite => _keepFavorite;

  set keepFavorite(bool value) {
    setState(() {
      _keepFavorite = value;
    });
  }

  int _favoriteDateDelay = 0;

  int get favoriteDateDelay => _favoriteDateDelay;

  set favoriteDateDelay(int value) {
    setState(() {
      _favoriteDateDelay = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoris"),
      ),
      body: Container(
        color: Colors.black,
        child: SettingsList(
          darkTheme: Themes.settingsDarkTheme,
          lightTheme: Themes.settingsLightTheme,
          sections: [
            SettingsSection(
              title: const Text('Durée de validité'),
              margin: const EdgeInsetsDirectional.all(15),
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Conserver les favoris'),
                  leading: keepFavorite
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(
                          Icons.favorite,
                        ),
                  initialValue: keepFavorite,
                  onToggle: (bool value) {
                    keepFavorite = value;
                  },
                ),
                SettingsTile(
                  title: const Text('Supprimer après'),
                  leading: const Icon(Icons.delete),
                  description: Text(
                    favoriteDateDelay == 0
                        ? 'Jamais'
                        : favoriteDateDelay.toString() + " jours",
                  ),
                  onPressed: (BuildContext context) {
                    pushTo(context, FavoriteAutoRemoveSettings());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
