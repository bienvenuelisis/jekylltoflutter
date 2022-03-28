import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/jekyll_blog.dart';
import '../../utils/utils.dart';
import '../about_page.dart';
import 'data_usage_settings.dart';
import 'favorites_page.dart';
import 'notifications_page.dart';
import 'settings_list_item.dart';
import 'ui_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  final String title = "Paramètres";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileListItems extends StatelessWidget {

  const ProfileListItems({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ProfileListItem(
            icon: LineAwesomeIcons.uikit,
            text: 'Interface',
            onPressed: () {
              goTo(context, const UISettings());
            },
            //DUI : Font, Dark Mode : Auto Dark Mode,
          ),
          ProfileListItem(
            icon: Icons.favorite,
            text: 'Favoris & A lire plus tard',
            onPressed: () {
              goTo(context, const FavoritesSettings());
            },
            //Bookmarks & Favorites
          ),
          ProfileListItem(
            icon: Icons.perm_data_setting,
            text: 'Utilisation des données',
            onPressed: () {
              goTo(context, const DataUsageSettings());
            },
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.bell,
            text: 'Notifications',
            onPressed: () {
              goTo(
                context,
                const NotificationsSettings(),
              );
            },
          ),
          ProfileListItem(
            icon: Icons.code,
            text: 'Voir le code',
            onPressed: () async {
              await launch(JekyllBlog.github);
            },
          ),
          /* ProfileListItem(
            icon: Icons.monetization_on,
            text: 'Soutenir le Média',
            onPressed: () {
              _supportUs(context);
            },
          ), */
          ProfileListItem(
            icon: LineAwesomeIcons.internet_explorer,
            text: 'Site Web de l\'éditeur',
            onPressed: () async{
              await launch(JekyllBlog.baseUrl);
            },
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.question_circle,
            text: 'A propos de l\'éditeur',
            onPressed: () {
              goTo(context, const AboutPage());
            },
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.copyright,
            text: 'Licenses tierces',
            onPressed: () {
              showLicensePage(
                context: context,
                applicationIcon: const Logo(),
                applicationLegalese: "© Copyright ${JekyllBlog.name} " +
                    DateTime.now().year.toString(),
                applicationName: JekyllBlog.name,
              );
            }, //Content policy, Privacy policy, User agrement, Acknowledgements, Licence
          ),
          ProfileListItem(
            icon: LineAwesomeIcons.door_open,
            text: 'Quitter',
            hasNavigation: false,
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/logo.png',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
      ),
    );
  }
}
