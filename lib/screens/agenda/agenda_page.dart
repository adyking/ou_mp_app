import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_add.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_details.dart';
import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/screens/tasks/task_edit.dart';
import 'package:ou_mp_app/style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../main_screen.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';


class AgendaPage extends StatefulWidget{

  final int projectId;


  AgendaPage({Key key, this.projectId}) : super(key : key);

  AgendaPageState  createState() => AgendaPageState(projectId: projectId);
}

class AgendaPageState extends State<AgendaPage> {
  final int projectId;
  List _selectedTasks;
  DateTime _selectedDay;


  AgendaPageState({Key key, this.projectId});

  @override
  void initState() {
    super.initState();
    _selectedTasks = _tasks[_selectedDay] ?? [];
  }

  @override
  void dispose() {

    super.dispose();
  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedTasks = _tasks[_selectedDay] ?? [];
    });
    print(_selectedTasks);
  }

  final Map<DateTime, List> _tasks = {
    DateTime(2020, 5, 7): [
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
    ],
    DateTime(2020, 5, 9): [
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
    ],
    DateTime(2020, 5, 10): [
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
    ],
    DateTime(2020, 5, 13): [
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': false},
    ],
    DateTime(2020, 5, 25): [
    {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},

    ],
    DateTime(2020, 6, 6): [
      {'subtask_id': 1,'subtask_name': 'Choose topic', 'time': '2 hours', 'task_name': 'Read module material','percent':'15%','isDone': true},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Agenda', style: AppBarTheme.of(context).textTheme.title,),
          backgroundColor: AppBarBackgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {

                setState(() {
                  print('lol');

                });
              },
            ),


          ],
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Calendar(
                  startOnMonday: true,
                  weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                  events: _tasks,
                  onRangeSelected: (range) =>
                      print("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: true,
                  hideTodayIcon: true,
                  eventDoneColor: Colors.green,
                  selectedColor: DefaultThemeColor,
                  todayColor: DefaultThemeColor,

                  eventColor: DefaultThemeColor,
                  dayOfWeekStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 11),
                ),
              ),
              _buildEventList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {

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


    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Card(

          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                 color:  _setColorStatus(_selectedTasks[index]['status']),
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
                    Text(_selectedTasks[index]['task_name'].toString(),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    Text(_selectedTasks[index]['percent'].toString(),
                      style: TextStyle(fontSize: 14.0),
                    ),

                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubtaskDetails(id:_selectedTasks[index]['subtask_id'])),);
                },
                // leading: Container(width: 10, color: Colors.red,),

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_selectedTasks[index]['subtask_name'].toString()
                    ),

                    Text(_selectedTasks[index]['time'].toString(),
                    ),

                  ],
                ),
                //     trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ),

        ),
        itemCount: _selectedTasks.length,
      ),
    );
  }

}

