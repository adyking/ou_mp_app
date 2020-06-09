import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/login/login_page.dart';
import 'package:ou_mp_app/screens/tasks_subtasks/tasks_subtasks_list.dart';
import 'package:ou_mp_app/style.dart';




class SettingsPage extends StatelessWidget {

 final Student student;

  SettingsPage({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appName = 'OU Project Management';
    final _appVersion = '1.0.0';
    final _userFullName = student.name;
    final _userEmail = student.email;


    final makeSettingsHeader = Container(
      color: DefaultThemeColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[

            Image.asset('assets/images/project-management-white.png', height: 100.0,),
            SizedBox(height: 5.0,),
            Center(
              child: Text(_appName, style: TextStyle(
                  fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600
              ),),
            ),
            SizedBox(height: 10.0,),
            Center(
              child: Text(_appVersion, style: TextStyle(
                fontSize: 16.0, color: Colors.white,
              ),),
            ),
            SizedBox(height: 10.0,),
          ],


        ),
      ),

    );

    final makeSettingsBody = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              children: <Widget>[
                Icon(Icons.account_circle, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text('$_userFullName'),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.email, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text('$_userEmail'),
              ],
            ),


          ],


        ),
      ),

    );


    final makeAccount = Container(

      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('ACCOUNT', style: PanelTitleTextStyle,),
            ),
              _accountListView(context,)

          ],


        ),
      ),

    );

    final makeAbout = Container(

      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('ABOUT', style: PanelTitleTextStyle,),
            ),
            _aboutListView(context,)

          ],


        ),
      ),

    );




    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Settings', style: AppBarTheme.of(context).textTheme.title,),
          backgroundColor: AppBarBackgroundColor,
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    makeSettingsHeader,
                    makeSettingsBody,
                    makeAccount,
                    makeAbout,



                  ],
                ),
              ),
            ),

          ],

        ),


      ),
    );
  }

}



Widget _accountListView(BuildContext context) {

  final titles = ['Logout', 'Edit profile'];
  final titlesSub = ['Logout from the app','Edit your account information e.g. password, name'];
  final double hAccount = titles.length.toDouble() * 80;
  final icons = [Icon(Icons.phonelink_lock,color: Color(0xff326fb4)),
    Icon(Icons.edit,color: Color(0xff326fb4)),];


  return Container(

    height: hAccount,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: titles.length,
      itemBuilder: (context, index) {

        return Card(
          color: Colors.white,
          child: Container(

            child: ListTileTheme(

              child: ListTile(
                onTap: () {
                  switch (index) {
                    case 0:
                      {
                      //  Navigator.pushNamed(context, '/l');

                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => LoginPage()),);
                      }
                      break;
                    case 1:
                      {


                      }
                      break;
                    default:
                      {

                      }
                  }

                },

                title: Text(titles[index]),
                subtitle: Text(titlesSub[index]),
                trailing: icons[index],

              ),
            ),
          ),

        );
      },
    ),
  );



}


Widget _aboutListView(BuildContext context) {

  final titles = ['Give your feedback', 'Terms of service'];
  final titlesSub = ['What do you think of this app?','Legal information about this app'];
  final double hAccount = titles.length.toDouble() * 80;
  final icons = [Icon(Icons.send,color: Color(0xff326fb4)),
    Icon(Icons.perm_device_information,color: Color(0xff326fb4)),];


  return Container(

    height: hAccount,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: titles.length,
      itemBuilder: (context, index) {

        return Card(

          color: Colors.white,
          child: Container(

            child: ListTileTheme(

              child: ListTile(
                onTap: () {
                  switch (index) {
                    case 0:
                      {


                      }
                      break;
                    case 1:
                      {


                      }
                      break;
                    default:
                      {

                      }
                  }

                },

                title: Text(titles[index]),
                subtitle: Text(titlesSub[index]),
                trailing: icons[index],

              ),
            ),
          ),

        );
      },
    ),
  );



}