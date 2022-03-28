import 'package:jekylltoflutter/providers/app_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/styles.dart';

class UIFontSizeSettings extends ConsumerWidget {
  final List<String> sizes = [
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];

  UIFontSizeSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    AppSettingsModel settings = ref.watch(appSettingsProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        title: const Text(
          'Interface Utilisateur',
          style: TextStyle(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Définissez la taille des écritures',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              Flexible(
                child: ListView(
                  children: sizes
                      .map((l) => ListTile(
                            onTap: () {
                              settings.fontSize = int.parse(l);
                            },
                            title: Text(
                              l,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: l == settings.fontSize.toString()
                                ? const Icon(
                                    Icons.check_circle,
                                    color: yellow,
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
      ),
    );
  }
}
