import 'package:flutter/material.dart';

const AppBarLargeTextSize = 35.0;
const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const AppBarTextSize = 18.0;
const BodyTextSize = 16.0;
const BodySubTextSize = 14.0;
const AppBarHeight = 100.0;
const AppBarBackgroundColor = Color(0xff326fb4);
const BottomBarColorActive = Color(0xff326fb4);
const DefaultThemeColor = Color(0xff326fb4);
const BottomBarColorInactive = Colors.grey;

const MaterialColor buttonTextColor = const MaterialColor(
  0xff326fb4,
  const <int, Color>{
    50: const Color(0xff326fb4),
    100: const Color(0xff326fb4),
    200: const Color(0xff326fb4),
    300: const Color(0xff326fb4),
    400: const Color(0xff326fb4),
    500: const Color(0xff326fb4),
    600: const Color(0xff326fb4),
    700: const Color(0xff326fb4),
    800: const Color(0xff326fb4),
    900: const Color(0xff326fb4),
  },
);

const String FontNameDefault = 'OpenSans';

const AppBarTextStyle = TextStyle (
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w600,
  fontSize: AppBarTextSize,
  color: Colors.white,

);

const PanelTitleTextStyle = TextStyle (
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w600,
  fontSize: MediumTextSize,
  color: Colors.black,

);


const TitleTextStyle = TextStyle (
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: Colors.black,
);

const Body1TextStyle = TextStyle (
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: BodyTextSize,
  color: Colors.black,
);


const setBoxShadow = BoxShadow(
  color: Colors.grey,
  blurRadius: 10.0,
  spreadRadius: 0.0,
  offset: Offset(
    1.0,
    1.0,
  ),
);

const setBoxShadowLogin = BoxShadow(
  color: Colors.white,
  blurRadius: 10.0,
  spreadRadius: 0.0,
  offset: Offset(
    1.0,
    1.0,
  ),
);