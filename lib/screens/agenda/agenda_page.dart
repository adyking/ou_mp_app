import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';

import 'package:ou_mp_app/models/student.dart';

import 'package:ou_mp_app/screens/subtasks/subtask_details.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';

import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/models/TaskSubtask.dart';

import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/utils/storage_util.dart';


class AgendaPage extends StatefulWidget{

  final Student student;


  AgendaPage({Key key, this.student}) : super(key : key);

  AgendaPageState  createState() => AgendaPageState(student: student);
}

class AgendaPageState extends State<AgendaPage> {
  final Student student;
  Project _project;
  List _selectedTasks;
  DateTime _selectedDay;
  List<TaskSubtask> _tasksSubtasksList = List<TaskSubtask>();
  List<TaskSubtask> _tasksSubtasksListPercentage = List<TaskSubtask>();
  Map<DateTime, List> _agendaTasksSubtasks = Map<DateTime, List>() ;

  bool _loading = true;
  bool _showPage = false;

  AgendaPageState({Key key, this.student});

  @override
  void initState() {


    loadData();
   
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  
  void loadData() async {

    _project = await ServicesAPI.getCurrentProjectByStudentId(student.id);


    _tasksSubtasksListPercentage = await ServicesAPI.getTasksSubtasksByProjectIdWithPercentage(_project.id);
    
    _tasksSubtasksList = await ServicesAPI.getTasksSubtasksByProjectIdAgenda(_project.id);


   // _agendaTasksSubtasks = await ServicesAPI.getTasksSubtasksByProjectIdAgenda2(_project.id);



 /*   _tasksSubtasksList.forEach((taskSubtask) => _agendaTasksSubtasks[taskSubtask.subtaskStartDate] = [

    {

      'task_id': taskSubtask.taskId,
      'subtask_id': taskSubtask.subtaskId,
      'task_name': taskSubtask.taskName,
      'subtask_name': taskSubtask.subtaskName,
      'task_time': taskSubtask.taskAllocatedHours,
      'subtask_time': taskSubtask.subtaskAllocatedHours,
      'taskStatus': taskSubtask.taskStatus,
      'subtaskStatus': taskSubtask.subtaskStatus,
      'percent': '0%',
      'isDone': true

    },

    ],

    );*/



    _tasksSubtasksList.forEach((taskSubtask) {

      var keyDate = taskSubtask.subtaskStartDate;

      var tasksSubtasks2List = new List();


      for (var i = 0; i < _tasksSubtasksList.length; i++){

        if(keyDate== _tasksSubtasksList[i].subtaskStartDate){

          var newMap = {
            'task_id': _tasksSubtasksList[i].taskId,
            'subtask_id': _tasksSubtasksList[i].subtaskId,
            'task_name': _tasksSubtasksList[i].taskName,
            'subtask_name': _tasksSubtasksList[i].subtaskName,
            'task_time': _tasksSubtasksList[i].taskAllocatedHours,
            'subtask_time': _tasksSubtasksList[i].subtaskAllocatedHours,
            'taskStatus': _tasksSubtasksList[i].taskStatus,
            'subtaskStatus': _tasksSubtasksList[i].subtaskStatus,
            'percent': '0%',
            'isDone': _tasksSubtasksList[i].isDone== 1 ? true : false

          };

          tasksSubtasks2List.add(newMap);
        }


      }

      _agendaTasksSubtasks[taskSubtask.subtaskStartDate] = tasksSubtasks2List;




    }

    );



    setState(() {
      _selectedTasks = _agendaTasksSubtasks[_selectedDay] ?? [];
      _loading = false;
      _showPage = true;
    });

  }

  String getPercentage(int taskId) {

    int percentage = 0;
    for(var i =0; i < _tasksSubtasksListPercentage.length; i++){

      if (taskId== _tasksSubtasksListPercentage[i].taskId){

        percentage = _tasksSubtasksListPercentage[i].percentageCompleted;

        break;
      }

    }

    return percentage.toString() + '%';
  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedTasks = _agendaTasksSubtasks[_selectedDay] ?? [];
    });
 //   print(_selectedTasks);



  }

  /*final Map<DateTime, List> _tasks = {
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
  };*/

  @override
  Widget build(BuildContext context) {

    Color _setEventColor (Map<DateTime, List> agenda) {

      Color c;
      c = Colors.red;
      agenda.forEach((key, value) {


        value.forEach((element) {

          var taskId = element[0].toString();
          var lol = element['isDone'];


          if(lol==true) {
            c = Colors.black;
          }

          print(element);

        });

        print(key.toString() + ' ' + value.toString());
      });

        return c;
    }


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
              Visibility(
                visible:  _loading,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    CircularProgressIndicator(),
                    SizedBox(height: 10.0,),
                  ],
                ) ,
              ),

              Visibility(
              visible: _showPage ,
              child:  Container(
                color: Colors.white,
                child: Calendar(
                  startOnMonday: true,
                  weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                  events: _agendaTasksSubtasks,
                  onRangeSelected: (range) =>
                      print("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: true,
                  hideTodayIcon: true,
                  eventDoneColor: Colors.green,
                  selectedColor: DefaultThemeColor,
                  todayColor: DefaultThemeColor,

                  eventColor: Colors.grey,
                  dayOfWeekStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 11),
                ),
              ),

              ),

              _buildEventList(),

            ],
          ),
        ),

      ),


    );


  }
  Widget _buildEventList() {


    if(_showPage==true) {

      Color _setColorStatus(int subtaskId, int taskStatus, int subtaskStatus) {
        int status;
        if (subtaskId==0){

          status = taskStatus;

        } else {

          status = subtaskStatus;
        }


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

      String timeAllocated(int subtaskId, String taskTime, String subtaskTime){

        if (subtaskId==0){

          return taskTime.replaceAll('.0', '') + ' hour(s)';

        } else {

          return subtaskTime.replaceAll('.0', '') + ' hour(s)';
        }

      }



      return Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  _setColorStatus(
                        _selectedTasks[index]['subtask_id'],
                        _selectedTasks[index]['taskStatus'],
                        _selectedTasks[index]['subtaskStatus']),
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


                      Text(getPercentage(_selectedTasks[index]['task_id']),
                        style: TextStyle(fontSize: 14.0),
                      ),

                    ],
                  ),
                  onTap: () {

                    _loading = true;
                    _showPage = false;
                  _selectedDay = DateTime.now();

                    if(_selectedTasks[index]['subtask_id']!=0){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            SubtaskDetails(id:_selectedTasks[index]['subtask_id'],
                                taskName: _selectedTasks[index]['task_name'])),).then((value) {
                        bool refresh = StorageUtil.getBool('RefreshAgenda');

                        if(refresh){
                          StorageUtil.removeKey('RefreshAgenda');
                          setState(() {

                            loadData();
                          });
                        }

                      });

                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskDetails(id:_selectedTasks[index]['task_id'])),).then((value)  {
                        bool refresh = StorageUtil.getBool('RefreshAgenda');

                        if(refresh){
                          StorageUtil.removeKey('RefreshAgenda');
                          setState(() {

                            loadData();
                          });
                        }

                      });

                    }


                  },
                  // leading: Container(width: 10, color: Colors.red,),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_selectedTasks[index]['subtask_name'].toString()
                      ),

                      Text(
                          timeAllocated(_selectedTasks[index]['subtask_id'],
                            _selectedTasks[index]['task_time'].toString(),
                            _selectedTasks[index]['subtask_time'].toString()
                          )

                      ),

                    ],
                  ),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
            ),

          ),
          itemCount:  _selectedTasks.length,
        ),
      );
    } else {

      return Container(height: 1,);
    }


  }


}

