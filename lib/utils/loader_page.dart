import 'package:flutter/material.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
