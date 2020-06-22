
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class SignUpPageAdd extends StatefulWidget{

  SignUpPageAddState  createState() => SignUpPageAddState();
}

class SignUpPageAddState extends State<SignUpPageAdd> {

  String appBarTitle = 'Sign Up';
  bool termsOfUse = false;
  String userHelpText;


  FocusNode txtFieldFocus = new FocusNode();


  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  bool read = false;

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _setColorFocus() {
    Color c ;
    setState(() {
      if(txtFieldFocus.hasFocus){
        c =  DefaultThemeColor ;
      } else {
        c = Colors.grey;
      }
    });
    return c;
  }

  Future getData() async {
    var url = 'http://www.jteki.com/api/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data[0]['ID'].toString());

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

                if (title=='Error') {

                  Navigator.pop(context);

                } else {

                  if (title=='Warning') {
                    Navigator.pop(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          LoginPage()),);
                  }

                }



              },
            ),
          ],
        );
      },
    );
  }


  void doSignUp() async {

    String activationCode = getRandomString(7);


    int id = await ServicesAPI.addStudent(fullNameController.text,
        emailController.text,  passwordConfirmController.text, activationCode);

    if(id !=0) {
      int resp = await ServicesAPI.sendEmailRegStudent(fullNameController.text,
          emailController.text,  passwordConfirmController.text, activationCode);

      if(resp==1) {
        _showAlertDialog('Info', 'Your account has been created successfully!\n'
            'An email has been sent to you with an activation code.');
      } else {
        _showAlertDialog('Warning', 'Your account has been created but could not '
            'send an email, please try registering again.');
      }


    } else {
      _showAlertDialog('Error', 'Could not create your account, please try again.');

    }



  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(
        length,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);
  }

  @override
  Widget build(BuildContext context) {

    final makeFullName = TextField(
      controller: fullNameController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'First and last name*',
      ),
    );

    final makeEmail = TextField(

      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'OU email address*',
      ),
    );

    final makePassword = TextField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'password*',
      ),
    );

    final makePasswordConfirm = TextField(
      obscureText: true,
      controller: passwordConfirmController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'Confirm password*',
      ),
    );

    final makeTSCheckBox = Checkbox(
      value: read,
      onChanged: (bool value) {
        setState(() {
          read = value;

        });
      },

    );

    final makeUserHelp = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Please correct the following error(s):',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.red,
                  width: 6.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$userHelpText',
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );



    void checkEmailExists () async {
      var student = await ServicesAPI.checkStudentEmailExists(emailController.text);
      if (student!=null){

        setState(() {
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Email address already exists, please use a different one.';
        });

      }

    }

    bool checkFields()  {
      bool errors = false;
      setState(() {
        if (fullNameController.text == '') {
          errors = true;
          userHelpText = userHelpText + 'Name field is required.';
        }

        if (emailController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Email address field is required.';
        }

        if (passwordController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Password field is required.';
        }

        if (passwordConfirmController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Confirm password field is required.';
        }

        if(passwordController.text != '' && passwordConfirmController.text != ''){
          if (passwordController.text != passwordConfirmController.text) {
            errors = true;
            if (userHelpText != '') {
              userHelpText = userHelpText + '\n\n';
            }
            userHelpText = userHelpText + 'Passwords don\'t match, please retype them.';
          } else {

            int chars = passwordController.text.length;
            if (chars < 6) {
              errors = true;

              if (userHelpText != '') {
                  userHelpText = userHelpText + '\n\n';
                }
                userHelpText = userHelpText + 'Password length must be greater than 6 characters long.';
            }

          }

        }

        if (read == false) {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'To be able to sign up you must read and agree to the terms of service.';
        }



      });
      return errors;
    }


    void createUser () {
      doSignUp();

      //displaySuccessAlert();


    }
    double readWidth = MediaQuery.of(context).size.width*0.80;

    return Scaffold(

      appBar: AppBar(
        title: Text(appBarTitle, style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              userHelpText = '';
              //print(sCategory);
              bool errors = false;
             // checkEmailExists();
              errors = checkFields();

              if (errors == false) {
                ServicesAPI.checkStudentEmailExists(emailController.text).then((value) {

                  setState(() {
                    if (value!=null){
                      if (userHelpText != '') {
                        userHelpText = userHelpText + '\n\n';
                      }
                      userHelpText = userHelpText + 'Email address already exists, please use a different one.';

                    } else {

                      userHelpText = null;
                      createUser();
                    }


                  });


                });


              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                           makeFullName,
                            makeEmail,
                            makePassword,
                            makePasswordConfirm,
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(

                              mainAxisAlignment: MainAxisAlignment.start,

                              children: <Widget>[
                                makeTSCheckBox,

                                Container(
                                    width: readWidth,
                                    child: Text('* I have read and agree to the Terms of Service ')),

                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(

                                onTap: () {

                                },
                                child: Text(
                                  'Read Terms of Service',
                                  style: TextStyle(
                                      color: DefaultThemeColor, decoration: TextDecoration.underline ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),

                            Row(
                              children: <Widget>[Text('* required field')],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      child: makeUserHelp,
                      visible: userHelpText == null ? false : true,
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],

      ),
    );




  }

  void displaySuccessAlert() {

    Alert(
      context: context,
      type: AlertType.success,
      title: "Sucess",
      desc: "New account has been created sucessfully!\nYou will receive an email with an activation code.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pushNamed(context,'/login'),
          width: 120,
        )
      ],
    ).show();

  }

}