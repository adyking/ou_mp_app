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
      if (isSet) {
        _navTo = new MainScreen(tabIndex: 0,);
      } else {
        _navTo = new LoginPage();
      }
    } else {
      _navTo = new LoginPage();
    }


    //Navigator.pushNamed(context, '/m');
  // Navigator.of(context).pushNamedAndRemoveUntil('/m', (Route<dynamic> route) => false);
  //  Navigator.push(
    //  context,
      //MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 0,)),);

    return new SplashScreen(
      seconds: 0,
      navigateAfterSeconds: _navTo,

      backgroundColor: DefaultThemeColor,

      photoSize: 100.0,
      onClick: (){},

    );
  }

}
