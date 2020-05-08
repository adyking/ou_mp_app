import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  bool isKeepMeLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _setColorFocus() {
    Color c;
    setState(() {
      if (txtFieldFocus.hasFocus) {
        c = DefaultThemeColor;
      } else {
        c = Colors.grey;
      }
    });
    return c;
  }


  bool isUserValid (){
    bool valid = true;



    return valid;
  }

  @override
  Widget build(BuildContext context) {
    final _pad = 10.0;

    final makeKeepMeLoggedInCheckBox = Checkbox(
      value: isKeepMeLoggedIn,
      onChanged: (bool value) {
        setState(() {
          isKeepMeLoggedIn = value;
        });
      },
    );

    final makeLoginButton = Center(
      child: RaisedButton(
        onPressed: () {
          bool valid = isUserValid();
          if (valid){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 0,)),);
          }

        },
        textColor: Colors.white,
        color: DefaultThemeColor,
        padding: const EdgeInsets.all(0.0),
         shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: const Text('SIGN IN', style: TextStyle(fontSize: 18))),
        ),
      ),
    );

    final makeKeepMeLoggedInSwitch = Center(
        child: Switch(
      value: isKeepMeLoggedIn,
      onChanged: (value) {
        setState(() {
          isKeepMeLoggedIn = value;
          // print(isKeepMeLoggedIn);
        });
      },
      activeTrackColor: Colors.blueAccent,
      activeColor: DefaultThemeColor,
    ));

    final makeEmail = TextField(
      controller: emailController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        icon: Icon(Icons.email),
        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'OU email',
      ),
    );

    final makePassword = TextField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        icon: Icon(Icons.lock),
        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'Password',
      ),
    );
    final makeLoginPanel = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  'WELCOME TO',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  'OU PROJECT MANAGEMENT',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        makeEmail,
        SizedBox(height: 10),
        makePassword,
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerRight,
          child: InkWell(

            onTap: () {
              print('hello');
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(
                  color: DefaultThemeColor, decoration: TextDecoration.underline),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Keep me signed in',
              style: TextStyle(color: Colors.black),
            ),
            makeKeepMeLoggedInSwitch,
          ],
        ),
        SizedBox(height: 10),
        makeLoginButton,
      ],
    );
    final makeHeader = Column(
      children: <Widget>[
        SizedBox(height: 40),
        Image.asset(
          'assets/images/project-management-white.png',
          height: 100.0,
        ),
        SizedBox(height: 30),
      ],
    );
    final makeSignUp = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account?',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: DefaultThemeColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: makeHeader,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [setBoxShadowLogin],
                      ),
                      margin: EdgeInsets.only(
                          top: _pad, bottom: _pad, left: _pad, right: _pad),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: makeLoginPanel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: makeSignUp,
            ),
          ],
        ),
      ),
    );
  }
}
