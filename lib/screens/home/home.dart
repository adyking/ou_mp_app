
import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/home/all_items_panel.dart';
import 'package:ou_mp_app/screens/home/today_panels.dart';
import 'package:ou_mp_app/style.dart';
import 'projects_in_progress_panel.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                 ProjectsProgress(),
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