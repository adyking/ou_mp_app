import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/agenda/agenda_page.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/screens/projects/project_add.dart';
import 'package:ou_mp_app/screens/projects/project_page.dart';
import 'package:ou_mp_app/screens/settings/settings_page.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'screens/home/home.dart';
import 'package:ou_mp_app/utils/sys_update.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final int tabIndex;
  final int studentId;

  MainScreen({Key key, this.tabIndex, this.studentId}) : super(key:key);

  @override
  MainScreenState createState() => MainScreenState(selectedScreen:tabIndex, studentId: studentId);

}

class MainScreenState extends State<MainScreen>{
  int selectedScreen;
  final int studentId;
  final colorActive = BottomBarColorActive;
  final colorInactive = BottomBarColorInactive;
  Student student;
  bool _loading = true;
  bool _showPage = false;
  static bool _isConfigured = false;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  MainScreenState({Key key, this.selectedScreen, this.studentId});


  @override
  void initState() {
    super.initState();

      ServicesAPI.getStudentById(studentId).then((value) {
        setState(() {
          student = value;
          _loading = false;
          _showPage = true;


          DateTime today = DateTime.now();
          var formatter = DateFormat('yyyy-MM-dd');
          var formattedToday = formatter.format(today);
          SysUpdate.updateProjectOverdue(studentId, DateTime.parse(formattedToday));

          if (student==null){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),);
          }

        });

      });


    if (!_isConfigured) {

      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          //_showItemDialog(message);
          String title = message['notification']['title'];
          String body = message['notification']['body'];
          print(title + ' ---- ' + body);


        },

        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          //_navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // _navigateToItemDetail(message);
          String title = message['data']['title'];
          String body = message['data']['body'];
          print(title + ' ---- ' + body);
        },
      );

      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true)
      );
      _isConfigured = true;
    }



  }

  @override
  Widget build(BuildContext context) {

  // Pages for the bottom navigation bar
  final _screenOption = [
    Home(student: student),
    ProjectPage(student: student),
    AgendaPage(student: student),
    SettingsPage(student: student),

  ];

  return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(

      body: Visibility(
        visible: _showPage,
        child: Container(

          child: student == null ? _screenOption[0] : _screenOption[selectedScreen],
        ),
      ),

      //student == null ? _screenOption[0] : _screenOption[selectedScreen],

      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: selectedScreen,
        onTap: (int index) {
          setState(() {
            selectedScreen = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              color: selectedScreen == 0 ? colorActive : colorInactive,
            ),
            title: Text(
              'Dashboard',
              style: TextStyle(
                  color: selectedScreen == 0 ? colorActive : colorInactive),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.border_color,
              color: selectedScreen == 1 ? colorActive : colorInactive,
            ),
            title: Text(
              'Projects',
              style: TextStyle(
                  color: selectedScreen == 1 ? colorActive : colorInactive),
            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: selectedScreen == 2 ? colorActive : colorInactive,
            ),
            title: Text(
              'Agenda',
              style: TextStyle(
                  color: selectedScreen == 2 ? colorActive : colorInactive),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: selectedScreen == 3 ? colorActive : colorInactive,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                  color: selectedScreen == 3 ? colorActive : colorInactive),
            ),
          ),
        ],
      ),
   //  floatingActionButton: _floatingButton(context),
    ),
  );


  }

  Widget _floatingButton(BuildContext context) {
    switch (selectedScreen) {
      case 1:
        {
          return FloatingActionButton(
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectPageAdd()),);
             /* Alert(
                  context: context,
                  style: AlertStyle(isOverlayTapDismiss: false,
                  ),

                  title: "NEW PROJECT",
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          labelText: 'Username',
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();*/
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xff326fb4),
          );
        }
        break;
      case 2:
        {
          return null;
        }
        break;

      default:
        {
          return null;
        }
    }
  }

}


