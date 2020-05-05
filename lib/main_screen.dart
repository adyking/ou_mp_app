import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/projects/project_add.dart';
import 'package:ou_mp_app/screens/projects/project_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/style.dart';
import 'screens/home/home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MainScreen extends StatefulWidget {
  final int tabIndex;

  MainScreen({Key key, this.tabIndex}) : super(key:key);

  @override
  MainScreenState createState() => MainScreenState(selectedScreen:tabIndex);

}

class MainScreenState extends State<MainScreen>{
  int selectedScreen;
  final colorActive = BottomBarColorActive;
  final colorInactive = BottomBarColorInactive;

  MainScreenState({Key ke, this.selectedScreen});


@override
  Widget build(BuildContext context) {

  // Pages for the bottom navigation bar
  final _screenOption = [
    Home(),
    ProjectPage(),

  ];

  return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(

      body: _screenOption[selectedScreen],

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


