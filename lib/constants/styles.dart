import 'package:flutter/material.dart';

const Color yellow = Color(0xffFDC054);
const Color mediumYellow = Color(0xffFDB846);
const Color darkYellow = Color(0xffE99E22);
const Color transparentYellow = Color.fromRGBO(253, 184, 70, 0.7);
const Color darkGrey = Color(0xff202020);

const int defaultFontSize = 16;

const LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(236, 60, 3, 1),
  Color.fromRGBO(234, 60, 3, 1),
  Color.fromRGBO(216, 78, 16, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}

const TextStyle body1 = TextStyle(fontSize: 15, fontFamily: "Poppins");

Color kAppPrimaryColor = Colors.grey.shade200;
Color kWhite = Colors.white;
Color kLightBlack = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;

const IconData twitter = IconData(0xe900, fontFamily: "CustomIcons");
const IconData facebook = IconData(0xe901, fontFamily: "CustomIcons");
const IconData youtube = IconData(0xe901, fontFamily: "CustomIcons");
const IconData googlePlus = IconData(0xe902, fontFamily: "CustomIcons");
const IconData linkedin = IconData(0xe903, fontFamily: "CustomIcons");

const kSpacingUnit = 10;

const kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

BoxDecoration avatarDecoration = BoxDecoration(
  shape: BoxShape.circle,
  color: kAppPrimaryColor,
  boxShadow: [
    BoxShadow(
      color: kWhite,
      offset: const Offset(10, 10),
      blurRadius: 10,
    ),
    BoxShadow(
      color: kWhite,
      offset: const Offset(-10, -10),
      blurRadius: 10,
    ),
  ],
);
