import 'package:flutter/material.dart';
import 'package:ou_mp_app/utils/storage_util.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:splashscreen/splashscreen.dart';

import '../main_screen.dart';
import '../style.dart';

class DefaultPage extends StatefulWidget {
  DefaultPageState createState() => DefaultPageState();
}

class DefaultPageState extends State<DefaultPage> {

  var _navTo;


  @override
  Widget build(BuildContext context) {

    if (StorageUtil.checkBool('KeepMeLoggedIn')) {
      bool isSet = StorageUtil.getBool('KeepMeLoggedIn');
      int userId = StorageUtil.getInt('UserId');
      if (isSet) {
        _navTo = new MainScreen(tabIndex: 0,studentId: userId,);
      } else {
        _navTo = new LoginPage();
      }
    } else {
      _navTo = new LoginPage();
    }

    return new SplashScreen(
      seconds: 0,
      navigateAfterSeconds: _navTo,

      backgroundColor: DefaultThemeColor,

      photoSize: 100.0,
      onClick: (){},

    );
  }

}
