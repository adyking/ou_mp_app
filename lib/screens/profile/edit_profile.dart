
import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProfile extends StatefulWidget{

  EditProfileState  createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {

  String appBarTitle = 'Edit Profile';
  bool termsOfUse = false;
  String userHelpText;

  FocusNode txtFieldFocus = new FocusNode();


  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fullNameController.text = 'Adilson Jacinto';
    emailController.text = 'apaj2@ou.ac.uk';
    passwordController.text = 'Angolano87';
    passwordConfirmController.text = 'Angolano87';
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
            userHelpText = userHelpText + 'Paswwords don\'t matach, please retype them.';
          } else {

            int chars = passwordController.text.length;
            if (chars < 6) {
              errors = true;

              if (userHelpText != '') {
                userHelpText = userHelpText + '\n\n';
              }
              userHelpText = userHelpText + 'Paswword length must be greater than 6 characters long.';
            }

          }

        }



      });
      return errors;
    }


    void createUser () {
      displaySuccessAlert();


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
                createUser();
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