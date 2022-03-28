import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../constants/themes.dart';
import '../../providers/app_settings_model.dart';

class NotificationsSettings extends ConsumerWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

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
              title: const Text('Nouveaux articles'),
              margin: const EdgeInsetsDirectional.all(15),
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Envoyer une notification'),
                  leading: settings.sendNotifications
                      ? const Icon(Icons.notifications, color: Colors.red)
                      : const Icon(Icons.notifications),
                  initialValue: true,
                  onToggle: (bool value) {
                    settings.sendNotifications = value;
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
