import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Credits Attribution'),
        centerTitle: true,
        backgroundColor: AppBarBackgroundColor,


      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: <Widget>[
                            Image.asset('assets/images/project-management-white.png', height: 50.0,),
                          SizedBox(width: 10,),
                            Row(
                              children: <Widget>[
                                Text('Icon made by '),
                                InkWell(
                                  child: Text("Ddara", style: TextStyle(color: DefaultThemeColor,),),
                                  onTap: () async {
                                    if (await canLaunch("https://www.flaticon.com/authors/ddara")) {
                                      await launch("https://www.flaticon.com/authors/ddara");
                                    }
                                  },
                                ),
                                Text(" from ",),
                                InkWell(
                                  child: Text("www.flaticon.com", style: TextStyle(color: DefaultThemeColor,),),
                                  onTap: () async {
                                    if (await canLaunch("https://www.flaticon.com/")) {
                                      await launch("https://www.flaticon.com/");
                                    }
                                  },
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),

                  ),



                ],
              ),
            ),
          ),

        ],

      ),

    );
  }
}
