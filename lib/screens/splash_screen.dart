import 'package:flutter/material.dart';
import 'package:ou_mp_app/utils/storage_util.dart';
import 'package:ou_mp_app/screens/default.dart';
import 'package:splashscreen/splashscreen.dart';
import '../style.dart';


class SplashScreenPage extends StatefulWidget {
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    StorageUtil.getInstance();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: DefaultPage(),
        title: new Text('Starting up application...',
          style: new TextStyle(
            color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: Image.asset(
          'assets/images/project-management-white.png',
          height: 100.0,
        ),
        backgroundColor: DefaultThemeColor,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: (){},
        loaderColor: Colors.white,
    );
  }

}
