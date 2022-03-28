import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_settings_model.dart';

class FavoriteAutoRemoveSettings extends ConsumerWidget {
  final List<String> sizes = [
    '0',
    '7',
    '15',
    '30',
    '45',
    '60',
    '90',
    '120',
    '150'
  ];

  FavoriteAutoRemoveSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    AppSettingsModel settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        title: const Text(
          'Favoris',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Supprimer automatiquement un favori après :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Flexible(
              child: ListView(
                children: sizes
                    .map((l) => ListTile(
                          onTap: () {},
                          title: Text(
                            l == "0" ? "Jamais" : l + " jours",
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: (settings.favoriteDateDelay.toString() == l)
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.teal,
                                  size: 16,
                                )
                              : const SizedBox(),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
