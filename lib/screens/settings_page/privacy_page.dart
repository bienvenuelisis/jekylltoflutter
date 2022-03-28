import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String privacyPolicyTest = 'Chargement en cours...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _privacyContentEl(),
    );
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Widget _privacyContentEl() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 24)),
          _privacyPolicyTestBuilder(),
        ],
      ),
    );
  }

  FutureBuilder<String> _privacyPolicyTestBuilder() {
    return FutureBuilder<String>(
      future: getFileData("assets/privacy-policy.html"),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Html(
                data: snapshot.data,
              )
            : Html(data: privacyPolicyTest);
      },
    );
  }
}
