import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';

class TermsDetails extends StatelessWidget {
  final String txt;
  final String title;

  TermsDetails({Key key, this.txt,this.title}) : super(key:key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(title),
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
                      child: Text(txt),
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
