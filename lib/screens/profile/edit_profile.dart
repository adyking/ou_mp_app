
import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ou_mp_app/utils/services_api.dart';

class EditProfile extends StatefulWidget{
  final Student student;

  EditProfile({Key key, this.student}) : super(key: key);
  EditProfileState  createState() => EditProfileState(student: student);
}

class EditProfileState extends State<EditProfile> {

  String appBarTitle = 'Edit Profile';
  bool termsOfUse = false;
  String userHelpText;
  final Student student;

  EditProfileState({Key key, this.student});

  FocusNode txtFieldFocus = new FocusNode();


  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fullNameController.text = student.name;
    emailController.text = student.email;
    passwordController.text = student.password;
    passwordConfirmController.text = student.password;
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
      readOnly: true,
      enabled: false,
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


    bool checkFields() {
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



      });
      return errors;
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

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          LoginPage()),);
                  }



                },
              ),
            ],
          );
        },
      );
    }

    void editUser () {
      setState(() {

        ServicesAPI.updateStudentProfile(student.id, fullNameController.text,
            passwordController.text).then((value) {

          if(value !=0) {
            _showAlertDialog('Info', 'Your profile has been updated successfully, you will be redirected to the login page!');
          } else {
            _showAlertDialog('Error', 'Could not update your profile, '
                'please try again.');

          }


        });
      });


    }

    Future<void> _showAlertConfirmDialog(String title, String msg) async {
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
                child: Text('YES'),
                onPressed: () {
                  //  setState(() {

                  Navigator.pop(context);
                  ServicesAPI.deleteStudentProfile(student.id).then((value) {

                    if(value==1){
                      var msg = 'Your profile has been deleted successfully!';
                      _showAlertDialog('Info', msg);
                    } else {
                      var msg = 'Could not delete your profile, please try again.';
                      _showAlertDialog('Error', msg);
                    }

                  });
                  // });
                },
              ),

              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

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
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;
                editUser();
              }
            },
          ),

          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

              var msg = 'Are you sure you want to delete your profile?\n\nNote that all the data associated to your profile will be removed!';
              _showAlertConfirmDialog('Confirm', msg);


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
      title: "Success",
      desc: "New account has been created successfully!\nYou will receive an email with an activation code.",
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