import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/register/sign_up.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/storage_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ou_mp_app/utils/services_api.dart';


class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();

}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  bool isKeepMeLoggedIn = false;
  bool valid = false;
  Student _student;



  @override
  void initState() {


    //print(StorageUtil.getString('UserEmail'));
    if(StorageUtil.checkBool('KeepMeLoggedIn')){

      bool isSet = StorageUtil.getBool('KeepMeLoggedIn');

      if (isSet){
        isKeepMeLoggedIn = true;
        emailController.text = StorageUtil.getString('UserEmail');
        passwordController.text = StorageUtil.getString('UserPassword');
      }

    }

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


  doGoToMainScreen() {

    //print(' Correct password, your name is ' + _student.name);

    if(isKeepMeLoggedIn){

      StorageUtil.putBool('KeepMeLoggedIn', isKeepMeLoggedIn);
      StorageUtil.putString('UserEmail', _student.email);
      StorageUtil.putString('UserPassword', _student.password);
    } else {
      StorageUtil.removeKey('KeepMeLoggedIn');
      StorageUtil.removeKey('UserEmail');
      StorageUtil.removeKey('UserPassword');

    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 0, studentId: _student.id,)),);

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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future doLogin() async {
    var url = 'http://www.jteki.com/api/login.php';
    final response = await http.post(url, body: {
      'email': emailController.text,
      'password': passwordController.text,
    });


    var dataUser = json.decode(response.body);

    int _statusCode = dataUser['StatusCode'];


    if (_statusCode==200){

      print(' Correct password, your name is ' + dataUser['Response']['name']);

      if(isKeepMeLoggedIn){

        StorageUtil.putBool('KeepMeLoggedIn', isKeepMeLoggedIn);
        //print(StorageUtil.getBool('KeepMeLoggedIn').toString());
        StorageUtil.putString('UserEmail', emailController.text);
        StorageUtil.putString('UserPassword', passwordController.text);
      } else {
        StorageUtil.removeKey('KeepMeLoggedIn');
        StorageUtil.removeKey('UserEmail');
        StorageUtil.removeKey('UserPassword');

      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 0,)),);
    }else{


      print('wrong password ' );
    }

  }

   closeAlert(BuildContext context) {
    Navigator.pop(context);

  }

  forgotPasswordPopUp () {
    Alert(
     // style: AlertStyle(isCloseButton: false,),
        context: context,
        title: 'PASSWORD RECOVERY',
        content: Column(
          children: <Widget>[
           // Text('Please enter the ou email address you used to register and click on the resend button.\nIf your email exists then you will receive an email with a temporary password. '),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.mail),
                labelText: 'OU email address',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "RESEND",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

        ]).show();

  }

  @override
  Widget build(BuildContext context) {
    final _pad = 10.0;

     final activationCodeController = TextEditingController();


    Future<String> alertActivateAccount(BuildContext context) async {

      return showDialog(context: context, builder: (context) {
       return  AlertDialog(
         title: Text('Activation code required'),
         content: TextField(

           controller: activationCodeController,
         ),
         actions: <Widget>[
           MaterialButton(
             elevation: 5.0,
             child: Text('VALIDATE'),
             onPressed: () {
               if(activationCodeController.text != ''){
                 Navigator.of(context).pop(activationCodeController.text.toString());
               } else {
                _showAlertDialog('Error', 'Activation code must not be blank!');
               }

             },
           ),
           MaterialButton(
             elevation: 10.0,
             child: Text('CANCEL'),
             onPressed: () {
               Navigator.of(context).pop();
             },
           ),

         ],
       );
      },);

    }

    final makeLoginButton = Center(
      child: RaisedButton(
        onPressed: () {

          setState(() {

            if(emailController.text != '' && passwordController.text != ''){
              ServicesAPI.getStudentByLogin(emailController.text,
                  passwordController.text).then((value) {

                _student = value;

                if(_student == null){
                  _showAlertDialog('Error', 'Incorrect loging details or cannot find the account.');
                } else {

                  // check if active
                  if(_student.isActive == 1) {
                    doGoToMainScreen();
                  } else {
                    String _activationCode = '';
                    alertActivateAccount(context).then((onValue) {
                      _activationCode = onValue;


                      if (_activationCode != null){

                        if (_activationCode == _student.activationCode){

                          updateActiveFlag();

                        } else {
                          _showAlertDialog('Error', 'Incorrect activation code for this account.');
                        }

                      }
                    } );


                  }


                }

              });
            }

          });




        //  doLogin();

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
      keyboardType: TextInputType.emailAddress,
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
              forgotPasswordPopUp();
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(
                  color: DefaultThemeColor, decoration: TextDecoration.underline ),
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
          InkWell(


            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPageAdd()),);
            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),
            ),
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

  void updateActiveFlag() {

    ServicesAPI.activateStudentAccount(_student.id).then((value) {

      if(value==true){

        doGoToMainScreen();

      }

    } );

  }


}
