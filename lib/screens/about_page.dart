import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:jekylltoflutter/services/jekyll_blog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/styles.dart';
import '../utils/utils.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  final String title = "A propos";

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                const SiteLogo(),
                const SizedBox(
                  height: 45,
                ),
                const SocialIcons(),
                const SizedBox(height: 30),
                Text(
                  JekyllBlog.description,
                  textAlign: TextAlign.center,
                  style: body1,
                ),
                Visibility(
                  visible: JekyllBlog.email.isNotEmpty,
                  child: TextButton(
                    onPressed: () => launch("mailto:${JekyllBlog.email}"),
                    child: Text(
                      JekyllBlog.email,
                      textAlign: TextAlign.center,
                      style: body1,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "© Copyright ${JekyllBlog.name} " +
                      DateTime.now().year.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SiteLogo extends StatelessWidget {
  const SiteLogo({Key? key}) : super(key: key);

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

class SocialIcons extends StatelessWidget {
  const SocialIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: JekyllBlog.facebook.isNotEmpty,
              child: SocialIcon(
                color: const Color(0xFF102397),
                iconData: CommunityMaterialIcons.facebook,
                url: JekyllBlog.facebook,
              ),
            ),
            Visibility(
              visible: JekyllBlog.instagram.isNotEmpty,
              child: SocialIcon(
                color: Colors.purpleAccent,
                iconData: CommunityMaterialIcons.instagram,
                url: JekyllBlog.instagram,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: JekyllBlog.twitter.isNotEmpty,
              child: SocialIcon(
                color: Colors.blue,
                iconData: CommunityMaterialIcons.twitter,
                url: JekyllBlog.twitter,
              ),
            ),
            Visibility(
              visible: JekyllBlog.phoneNumber.isNotEmpty,
              child: SocialIcon(
                color: Colors.purple,
                iconData: Icons.phone,
                url: "tel:${JekyllBlog.phoneNumber}",
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SocialIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final String url;

  void _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      snackbar('Erreur', 'Nous n\'avons pas pu ouvrir ce lien.');
    }
  }

  const SocialIcon({
    required this.color,
    required this.iconData,
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 10,
        height: 45.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () {
            _launchURL();
          },
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}
