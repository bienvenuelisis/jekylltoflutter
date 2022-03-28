import 'package:jekylltoflutter/providers/app_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../constants/themes.dart';
import '../../utils/utils.dart';
import 'ui_font_size.dart';

class UISettings extends ConsumerWidget {
  const UISettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    AppSettingsModel settings = ref.watch(appSettingsProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        child: SettingsList(
          darkTheme: Themes.settingsDarkTheme,
          lightTheme: Themes.settingsLightTheme,
          sections: [
            SettingsSection(
              title: const Text('Interface Utilisateur'),
              margin: const EdgeInsetsDirectional.all(15),
              tiles: [
                SettingsTile(
                  title: const Text('Taille des Caractères'),
                  description: Text(settings.fontSize.toString()),
                  leading: const Icon(Icons.font_download_outlined),
                  onPressed: (BuildContext context) {
                    goTo(context, UIFontSizeSettings());
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Thème sombre'),
                  leading: const Icon(Icons.nights_stay_sharp),
                  initialValue: settings.nightMode,
                  onToggle: (bool value) {
                    settings.nightMode = value;
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
