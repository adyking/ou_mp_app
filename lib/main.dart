import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/screens/notifications/notification_page.dart';
import 'package:ou_mp_app/screens/reminder/reminder_page.dart';
import 'package:ou_mp_app/screens/splash_screen.dart';
import 'package:ou_mp_app/utils/locator.dart';
import 'package:ou_mp_app/utils/navigation_service.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'main_screen.dart';
import 'style.dart';


void main() {
  setupLocator();
  runApp(MyApp());
}


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
      navigatorKey: locator<NavigationService>().navigationKey,
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            case 'login':
              return MaterialPageRoute(builder: (context) => LoginPage());
            case 'reminder_page':
              var project = routeSettings.arguments as Project;
              return MaterialPageRoute(builder: (context) => ReminderPage(project: project,));
            case 'notification_page':
              var arr = routeSettings.arguments as List<dynamic>;
              var title = arr[0];
              var body = arr[1];
              var project = arr[2];

              return MaterialPageRoute(builder: (context) => NotificationPage(title: title ,
                body: body,project: project, ));
            default:
              return MaterialPageRoute(builder: (context) =>  SplashScreenPage());
          }
        },
        debugShowCheckedModeBanner: false,
        home: SplashScreenPage(),
       /* routes: <String, WidgetBuilder> {
          '/login': (BuildContext context) => LoginPage(),
          '/main': (BuildContext context) => MainScreen(tabIndex: 0,),

        },*/
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