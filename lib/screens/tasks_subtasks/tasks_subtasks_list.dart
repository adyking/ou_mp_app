import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_add.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_details.dart';
import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/screens/tasks/task_edit.dart';
import 'package:ou_mp_app/style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../main_screen.dart';


class TasksSubtasksList extends StatefulWidget{
  final int id;
  final int view; // 0 - all, 1 - overdue

  TasksSubtasksList({Key key, this.id, this.view}) : super(key : key);

  TasksSubtasksListState  createState() => TasksSubtasksListState(id: id,view: view);
}

class TasksSubtasksListState extends State<TasksSubtasksList> {
  final int id;
  final int view; // 0 - all, 1 - overdue

  TasksSubtasksListState({Key key, this.id,this.view});

  bool completed = false;



  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bool _viewToday = false;
    bool _viewTomorrow = false;
    bool _viewAllUpcoming = false;
    bool _viewOverdue = false;

    final _projectTitle = 'TM470 Project';
    final _taskName = 'Read module material.';
    final double _taskDuration = 2.0;
    final  _duration = _taskDuration.toString().replaceAll('.0', '') + ' hours';
    final _dateFromTo = 'Feb 08 - Sept 14';
    final _taskDateFromTo = 'Feb 09, 2020 - Feb 12, 2020';
    final double _currentProgress = 0.15;
    final  _calProgress = _currentProgress * 100;
    final _progress = _calProgress.toInt();

    if (view==1){
      _viewOverdue =true;
    } else {
      _viewToday =true;
      _viewTomorrow=true;
      _viewAllUpcoming=true;
    }



    final makeDueToday = Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Due Today', style: PanelTitleTextStyle,),
            ),
            _dueTodayListView(context) ,
          ],
        ),
      ),
    );


    final makeDueTomorrow = Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Due Tomorrow', style: PanelTitleTextStyle,),
            ),
            _dueTomorrowListView(context) ,
          ],
        ),
      ),
    );

    final makeAllUpcoming = Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('All Upcoming', style: PanelTitleTextStyle,),
            ),
            _dueAllUpcomingListView(context) ,
          ],
        ),
      ),
    );

    final makeOverdue = Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Overdue', style: PanelTitleTextStyle,),
            ),
            _overDueListView(context) ,
          ],
        ),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Tasks & Subtasks'),
            Text(_projectTitle + ' | ' + _dateFromTo, style: TextStyle(
              fontSize: 12.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,

        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.more_vert),
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

                 Visibility(
                   child: makeDueToday,
                   visible: _viewToday,
                 ),
                  Visibility(
                    child: makeDueTomorrow,
                    visible: _viewTomorrow,
                  ),
                  Visibility(
                    child: makeAllUpcoming,
                    visible: _viewAllUpcoming,
                  ),
                  Visibility(
                    child: makeOverdue,
                    visible: _viewOverdue,
                  ),



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


Widget _dueTodayListView(BuildContext context) {


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
  final subtasksId = [1];
  final subtasks = ['Choose topic'];
  final tasks = ['Read module material'];
  final subtasksStartDate = ['Feb 09'];
  final taskProgress = ['15%'];
  final subtasksStatus = [0];


  final double hTasks = subtasks.length.toDouble() * 80;
  double height = MediaQuery.of(context).size.height;

// height without SafeArea
  var padding = MediaQuery.of(context).padding;


// height without status and toolbar
  double heightList = height - padding.top - kToolbarHeight - 15;

  return Container(

    height: hTasks,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
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
                    Text(tasks[index],
                      style: TextStyle(fontSize: 14.0),
                    ),


                    Text(taskProgress[index],
                      style: TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubtaskDetails(id:subtasksId[index])),);
                },
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

Widget _dueTomorrowListView(BuildContext context) {

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
  final subtasksId = [1];
  final subtasks = ['Research on chosen topic'];
  final tasks = ['Read module material'];
  final subtasksStartDate = ['Feb 10'];
  final taskProgress = ['15%'];
  final subtasksStatus = [0];


  final double hTasks = subtasks.length.toDouble() * 80;
  double height = MediaQuery.of(context).size.height;

// height without SafeArea
  var padding = MediaQuery.of(context).padding;


// height without status and toolbar
  double heightList = height - padding.top - kToolbarHeight - 15;

  return Container(

    height: hTasks,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
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
                    Text(tasks[index],
                      style: TextStyle(fontSize: 14.0),
                    ),


                    Text(taskProgress[index],
                      style: TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubtaskDetails(id:subtasksId[index])),);
                },
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

Widget _dueAllUpcomingListView(BuildContext context) {


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
  final subtasksId = [1];
  final subtasks = ['Initiate the draft of text'];
  final tasks = ['Write up on topic'];
  final subtasksStartDate = ['Feb 12'];
  final taskProgress = ['0%'];
  final subtasksStatus = [0];


  final double hTasks = subtasks.length.toDouble() * 80;
  double height = MediaQuery.of(context).size.height;

// height without SafeArea
  var padding = MediaQuery.of(context).padding;


// height without status and toolbar
  double heightList = height - padding.top - kToolbarHeight - 15;

  return Container(

    height: hTasks,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
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
                    Text(tasks[index],
                      style: TextStyle(fontSize: 14.0),
                    ),


                    Text(taskProgress[index],
                      style: TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubtaskDetails(id:subtasksId[index])),);
                },
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

Widget _overDueListView(BuildContext context) {


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
  final subtasksId = [1];
  final subtasks = ['Initiate the draft of text'];
  final tasks = ['Write up on topic'];
  final subtasksStartDate = ['Feb 12'];
  final taskProgress = ['0%'];
  final subtasksStatus = [2];


  final double hTasks = subtasks.length.toDouble() * 80;
  double height = MediaQuery.of(context).size.height;

// height without SafeArea
  var padding = MediaQuery.of(context).padding;


// height without status and toolbar
  double heightList = height - padding.top - kToolbarHeight - 15;

  return Container(

    height: hTasks,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
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
                    Text(tasks[index],
                      style: TextStyle(fontSize: 14.0),
                    ),


                    Text(taskProgress[index],
                      style: TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubtaskDetails(id:subtasksId[index])),);
                },
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
          child: Icon(Icons.dashboard),
          label: 'Return to dashboard',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 0,)),);
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