import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/screens/splash_screen.dart';
import 'main_screen.dart';
import 'style.dart';


void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> {



  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenPage(),
        routes: <String, WidgetBuilder> {
          '/login': (BuildContext context) => LoginPage(),
          '/main': (BuildContext context) => MainScreen(tabIndex: 0,),

        },
        theme: ThemeData(
          appBarTheme:
          AppBarTheme(textTheme: TextTheme(title: AppBarTextStyle)),
          textTheme: TextTheme(
            title: TitleTextStyle,
            body1: Body1TextStyle,
          ),
          primaryColor: DefaultThemeColor,
          accentColor: DefaultThemeColor,
          primarySwatch: buttonTextColor,
        ));
  }
}