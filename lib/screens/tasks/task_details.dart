import 'package:flutter/material.dart';

import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/style.dart';

import 'package:ou_mp_app/screens/projects/project_add.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class TaskDetails extends StatefulWidget{

  TaskDetailsState  createState() => TaskDetailsState();
}

class TaskDetailsState extends State<TaskDetails> {
  bool completed = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _projectTitle = 'TM470 Project';
    final _taskName = 'Read module material.';
    final double _taskDuration = 2.0;
    final  _duration = _taskDuration.toString().replaceAll('.0', '') + ' hours';
    final _dateFromTo = 'Feb 08 - Sept 14';
    final _taskDateFromTo = 'Feb 09, 2020 - Feb 12, 2020';
    final double _currentProgress = 0.15;
    final  _calProgress = _currentProgress * 100;
    final _progress = _calProgress.toInt();





    final makeTaskDetailHeader = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              children: <Widget>[
                Icon(Icons.assignment, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_taskName,),
              ],
            ),
            SizedBox(height: 10.0,),

            Row(
              children: <Widget>[
                Icon(Icons.date_range, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_taskDateFromTo,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_duration,),
              ],
            ),
            SizedBox(height: 10.0,),
            LinearPercentIndicator(
              // width: MediaQuery.of(context).size.width - 40,
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2500,
              percent: _currentProgress,
              // trailing: Icon(Icons.flag),
              center: Text(_progress.toString() +'%', style: TextStyle(
                  fontSize: 12.0
              ),),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Color(0xff326fb4),
              backgroundColor: Colors.grey[300],
            ),


          ],


        ),
      ),

    );



    final makeCompletedCheckBox = Checkbox(
        value: completed,
         onChanged: (bool value) {
          setState(() {
          completed = value;
        });
      },

    );

    final makeTaskStatus = Container(

      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Status', style: PanelTitleTextStyle,),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Completed'),
                    makeCompletedCheckBox,
                  ],
                ),
              ),
            ),

          ],


        ),


    );



    final makeTasksTitle = Container(

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Subtasks', style: PanelTitleTextStyle,),


          ],


        ),
      ),

    );




    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Task'),
            Text(_projectTitle + ' | ' + _dateFromTo, style: TextStyle(
              fontSize: 14.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
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

                  makeTaskDetailHeader,
                  makeTaskStatus,
                  makeTasksTitle,

                  _subtasksListView(context) ,
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


Widget _subtasksListView(BuildContext context) {


  Color _setColorStatus(int status) {
    Color c;
      switch (status) {
        case 0 :{
          c = DefaultThemeColor;
        }
        break;
        case 1 : {
          c = Colors.green;
        }
        break;
        case 2 : {
          c = Colors.red;
        }
        break;
        default:
          {
            c = DefaultThemeColor;
          }
      }

    return c;
  }
  final subtasks = ['Choose topic', 'Research on chosen topic'];
  final subtasksStartDate = ['Feb 09', 'Feb 10'];
  final subtasksEstimatedTime = ['2 hours', '2 hours'];
  final subtasksStatus = [1, 0];


  final double hTasks = subtasks.length.toDouble() * 80;


  return Container(

    height: hTasks,
    child: ListView.builder(

      itemCount: subtasks.length,
      itemBuilder: (context, index) {

        return Card(

          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color:  _setColorStatus(subtasksStatus[index]),
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
                    Text('Allocated time',
                      style: TextStyle(fontSize: 14.0),
                    ),


                    Text(subtasksEstimatedTime[index],
                      style: TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
                onTap: () => print(hTasks.toString()),
                // leading: Container(width: 10, color: Colors.red,),

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(subtasks[index]
                    ),

                    Text(subtasksStartDate[index],
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
          child: Icon(Icons.event_note),
          label: 'Create a log sheet',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProjectPageAdd()),);
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