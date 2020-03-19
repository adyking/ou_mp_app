import 'package:flutter/material.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'main_screen.dart';
import 'style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(textTheme: TextTheme(title: AppBarTextStyle)),
          textTheme: TextTheme(
            title: TitleTextStyle,
            body1: Body1TextStyle,
          ),
            primaryColor: DefaultThemeColor,
          accentColor: DefaultThemeColor,
          primarySwatch: buttonTextColor,

        )
    );
  }
}
