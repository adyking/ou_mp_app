import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_add.dart';
import 'package:ou_mp_app/screens/projects/project_edit.dart';
import 'package:ou_mp_app/screens/projects/project_page.dart';
import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ou_mp_app/screens/projects/project_add.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../main_screen.dart';


class ProjectDetails extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final _projectTitle = 'TM470 Project';
  final _projectDesc = 'Mobile app to manage OU projects.';
  final _category = 'Development';
  final _dateFromTo = 'Feb 08, 2020 - Sept 14, 2020';
  final double _currentProgress = 0.25;
  final  _calProgress = _currentProgress * 100;
  final _progress = _calProgress.toInt();
  final _name = 'Adilson Jacinto';

    final makeProjectDetailHeader = Container(
      color: DefaultThemeColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[

            CircularPercentIndicator(
              radius: 75.0,
              lineWidth: 5.0,
              percent: _currentProgress,
              center: new Text( _progress.toString()+"%", style: TextStyle(
                color: Colors.white,
              ),),
              progressColor: Colors.green,
            ),
            SizedBox(height: 5.0,),
            Text(_projectTitle, style: TextStyle(
                fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 10.0,),
            Text(_projectDesc, style: TextStyle(
                fontSize: 16.0, color: Colors.white,
            ),),

          ],


        ),
      ),

    );

  final makeProjectDetailBody = Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[

         Row(
           children: <Widget>[
             Icon(Icons.category, color: Colors.grey
             ),
             SizedBox(width: 10.0,),
             Text(_category,),
           ],
         ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Icon(Icons.date_range, color: Colors.grey
              ),
              SizedBox(width: 10.0,),
              Text(_dateFromTo,),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Icon(Icons.assignment_ind, color: Colors.grey
              ),
              SizedBox(width: 10.0,),
              Text(_name,),
            ],
          ),

        ],


      ),
    ),

  );


  final makeTasksTitle = Container(

    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Tasks', style: PanelTitleTextStyle,),


        ],


      ),
    ),

  );




  return Scaffold(
      appBar: AppBar(
        title: Text('', style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectPageEdit()),);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
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
              child: Column(
                children: <Widget>[

                  makeProjectDetailHeader,
                  makeProjectDetailBody,
                  makeTasksTitle,

               _myListView(context) ,
                  SizedBox(height: 50.0,),


                ],
              ),
            ),
          ),

        ],

      ),

      floatingActionButton:  _floatingButton(context),
    );
  }

}


Widget _myListView(BuildContext context) {

  final tasks = ['Read module material', 'Write up on topic'];
  final tasksStartDate = ['Feb 09', 'Feb 12'];
  final tasksId = [1, 2];


  final double hTasks = tasks.length.toDouble() * 80;


  return Container(

    height: hTasks,
    child: ListView.builder(

      itemCount: tasks.length,
      itemBuilder: (context, index) {

        return Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  Color(0xff326fb4),
                    width: 5.0,
                  ),

                ),
              ),
              child: ListTileTheme(

                child: ListTile(
                  // isThreeLine: true,
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Completed',
                        style: TextStyle(fontSize: 14.0),
                      ),


                      Text('0%',
                          style: TextStyle(fontSize: 14.0),
                        ),

                    ],
                  ),
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskDetails(id:tasksId[index])),);
                  },
                  // leading: Container(width: 10, color: Colors.red,),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(tasks[index]
                      ),

                      Text(tasksStartDate[index],
                      ),

                    ],
                  ),
             //     trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
            ),

        );
      },
    ),
  );



}

Widget _floatingButton(context) {

        return SpeedDial(
          child: Icon(Icons.add),
          backgroundColor: Color(0xff326fb4),
          overlayColor: Colors.grey,

          tooltip: 'More options',
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                labelBackgroundColor: Color(0xff326fb4),

                backgroundColor: Color(0xff326fb4),
                foregroundColor: Colors.white,

                labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                child: Icon(Icons.chrome_reader_mode),
                label: 'Return to projects',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 1,)),);
                }

            ),
            SpeedDialChild(
                labelBackgroundColor: Color(0xff326fb4),

                backgroundColor: Color(0xff326fb4),
                foregroundColor: Colors.white,

                labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                child: Icon(Icons.event_note),
                label: 'Create a log sheet',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogSheetPageAdd()),);
                }

            ),
            SpeedDialChild(
                labelBackgroundColor: Color(0xff326fb4),
                backgroundColor: Color(0xff326fb4),
                //foregroundColor: Colors.black,
                foregroundColor: Colors.white,
                labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                child: Icon(Icons.assignment),
                // labelWidget: Text('Auto Join', style: TextStyle(color: Colors.white),),
                label: 'Add new task',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskPageAdd()),);
                }
            ),

          ],
        );

}