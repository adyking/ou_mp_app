
import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/home/all_items_panel.dart';
import 'package:ou_mp_app/screens/home/today_panels.dart';
import 'package:ou_mp_app/style.dart';
import 'projects_in_progress_panel.dart';

class Home extends StatelessWidget {

  final Student student;


  Home({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showCurrentProgress = false;




    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard', style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
         Expanded(
           child: SingleChildScrollView(
             child: Column(
               children: <Widget>[
                 Visibility(
                   child: ProjectsProgress(),
                   visible: showCurrentProgress,
                 ),
                 TodayPanels(),
                  AllItemsPanel(),
               ],
             ),
           ),
         ),
        ],
      ),
    );
  }
}