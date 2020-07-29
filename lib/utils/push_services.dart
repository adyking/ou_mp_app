
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/notifications/notification_page.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ou_mp_app/utils/services_api.dart';

import 'locator.dart';
import 'navigation_service.dart';

class PushServices  {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();

  bool _showNotification = false;
  String title;
  String body;
  String projectId;
  static bool _isConfigured = false;




  Future initialise() async {
    if (!_isConfigured) {
      if(Platform.isIOS){
        _fcm.requestNotificationPermissions(
            const IosNotificationSettings(sound: true, badge: true, alert: true)
        );
      }
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          //_showItemDialog(message);
          title = message['data']['title'];
          body = message['data']['body'];
          projectId = message['data']['projectId'];
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            looping: true, // Android only - API >= 28
            volume: 0.5, // Android only - API >= 28
            asAlarm: false, // Android only - all APIs
          );
          await new Future.delayed(const Duration(seconds : 2));
          FlutterRingtonePlayer.stop();
          //navigatorKey.currentState.push(MaterialPageRoute(builder: (context) =>
          //    NotificationPage(title: title,body: body,)));



          ServicesAPI.getProjectById(int.parse(projectId)).then((value) {
            var arr= [title,body,value];
            _navigationService.navigateTo('notification_page', arguments: arr);
          });


        },

        onLaunch: (Map<String, dynamic> message) async {
          //print("onLaunch: $message");
          //_navigateToItemDetail(message);
          title = message['data']['title'];
          body = message['data']['body'];
          projectId = message['data']['projectId'];
          print(title + ' ---- ' + body);
          String nTitle = message['notification']['title'];

          ServicesAPI.getProjectById(int.parse(projectId)).then((value) {
            var arr= [title,body,value];
            _navigationService.navigateTo('notification_page', arguments: arr);
          });


        },
        onResume: (Map<String, dynamic> message) async {
          // print("onResume: $message");
          // _navigateToItemDetail(message);

          title = message['data']['title'];
          body = message['data']['body'];
          projectId = message['data']['projectId'];
          // print(title + ' ---- ' + body);


          ServicesAPI.getProjectById(int.parse(projectId)).then((value) {
            var arr= [title,body,value];
            _navigationService.navigateTo('notification_page', arguments: arr);
          });


        },
      );
      _isConfigured = true;
    }




  }


}

/*

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PushServices extends StatefulWidget {
  @override
  _PushServicesState createState() => _PushServicesState();
}

class _PushServicesState extends State<PushServices> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  //final List<Message> messages = [];
  bool _showNotification = false;
  String title;
  String body;
  static bool _isConfigured = false;


  @override
  void initState() {
    super.initState();


   // if (!_isConfigured) {
      if(Platform.isIOS){
        _fcm.requestNotificationPermissions(
            const IosNotificationSettings(sound: true, badge: true, alert: true)
        );
      }
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          //_showItemDialog(message);
          title = message['data']['title'];
          body = message['data']['body'];
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            looping: true, // Android only - API >= 28
            volume: 0.5, // Android only - API >= 28
            asAlarm: false, // Android only - all APIs
          );
          await new Future.delayed(const Duration(seconds : 2));
          FlutterRingtonePlayer.stop();

          setState(() {
            _showNotification = true;

          });
        },

        onLaunch: (Map<String, dynamic> message) async {
          //print("onLaunch: $message");
          //_navigateToItemDetail(message);
          title = message['data']['title'];
          body = message['data']['body'];
          print(title + ' ---- ' + body);
          String nTitle = message['notification']['title'];
          if(nTitle!=null){
            _showAlertDialog(title, body);
          }


        },
        onResume: (Map<String, dynamic> message) async {
          // print("onResume: $message");
          // _navigateToItemDetail(message);

          title = message['data']['title'];
          body = message['data']['body'];
          // print(title + ' ---- ' + body);
          _showAlertDialog(title, body);
        },
      );
      //_isConfigured = true;
   // }






  }

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _showAlertDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$msg'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: _showNotification,
      child: Padding(
        padding: const EdgeInsets.only(top:10.0, left: 10.0, bottom: 10.0),
        child: InkWell(
          onTap: () {
            setState(() {
              print(title + ' ' +  body);
              _showNotification = false;
              _showAlertDialog(title, body);
            });

          },
          child: Container(
            width: 225,
            decoration:  BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                setBoxShadow
              ],
            ),


            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.notifications, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text('Notification received', style: TextStyle(color: Colors.white),),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }


*/

