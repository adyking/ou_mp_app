import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/models/subtask.dart';
import 'package:ou_mp_app/models/task.dart';
import 'package:ou_mp_app/models/tasksubtask.dart';
import 'package:ou_mp_app/screens/home/all_items_panel.dart';
import 'package:ou_mp_app/screens/home/today_panels.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/push_services.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/utils/sys_update.dart';
import 'projects_in_progress_panel.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {

  final Student student;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel:"navigator");

  Home({Key key, this.student}) : super(key: key);
  @override
  HomeState createState() => HomeState(student: student);

}


class HomeState extends State<Home> {

  final Student student;

  Project _project;
  bool showCurrentProgress = false;
  List<Task> _tasksList = List<Task>();
  List<int> taskIds = List<int>();
  List<int> taskIdsList = List<int>();
  List<TaskSubtask> _tasksSubtasksList = List<TaskSubtask>();
  List<Subtask> _subtasksList = List<Subtask>();
  int nInProgress = 0;
  int nCompleted = 0;
  int nOverdue = 0;
  double _currentProgress = 0.0;
  int  _currentProgressPercentage = 0;
  bool _loading = true;
  bool _showPage = false;
  int countTodayTasks = 0;
  double countTodayTasksHours = 0.0;
  int countTodaySubtasks = 0;
  double countTodaySubtasksHours = 0.0;

  HomeState({Key key, this.student});
  final PushServices pushNotifications = PushServices();



  @override
  void initState() {


    loadData2();
    registerNotification();
    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }



  void loadData2() async {

    _project = await ServicesAPI.getCurrentProjectByStudentId(student.id);


    DateTime today = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedToday = formatter.format(today);



    //int diffDays = today.difference(_project.endDate).inDays;

    //if (diffDays > 0) {

  //  }

    if(_project==null){
      setState(() {
        _loading = false;
        _showPage = true;
      });


    } else {

      await SysUpdate.updateTasksSubtasksOverdue(_project.id, DateTime.parse(formattedToday));
      await SysUpdate.updateSubtasksOverdue(_project.id);
      DateTime todayDefault = DateTime.now();



//     var taskSubtasksList =
//          await ServicesAPI.getTasksSubtasksByProjectId(_project.id, todayDefault
//              , todayDefault, 2);


     ServicesAPI.getTasksSubtasksByProjectId(_project.id, todayDefault
         , todayDefault, 2).then((taskSubtasksList) {


       for(var i=0; i < taskSubtasksList.length; i++){




         //_subtasksList = await ServicesAPI.getSubtasksByTaskId(_tasksList[i].id);

         int subtaskId = taskSubtasksList[i].subtaskId;
         int taskId = taskSubtasksList[i].taskId;

         if(!taskIdsList.contains(taskId)){
           taskIdsList.add(taskId);
         }

         if(subtaskId!=0) {
           DateTime today = DateTime.now();

           var formattedTodayDate =  DateFormat('dd-MM-yyyy').format(today);
           var formattedStartDate
           = DateFormat('dd-MM-yyyy').format(taskSubtasksList[i].subtaskStartDate);

           if (formattedTodayDate==formattedStartDate){

             if(!taskIds.contains(taskId)){
               taskIds.add(taskId);
             }

             countTodaySubtasks = countTodaySubtasks + 1;
             countTodaySubtasksHours = countTodaySubtasksHours + taskSubtasksList[i].subtaskAllocatedHours;
           }
         }

         /*     for(var s= 0; s < _subtasksList.length; s++){

          DateTime today = DateTime.now();

          var formattedTodayDate =  DateFormat('dd-MM-yyyy').format(today);
          var formattedStartDate = DateFormat('dd-MM-yyyy').format(_subtasksList[s].startDate);

          if (formattedTodayDate==formattedStartDate){

            if(!taskIds.contains(_subtasksList[s].id)){
              taskIds.add(_subtasksList[s].id);
            }

            countTodaySubtasks = countTodaySubtasks + 1;
            countTodaySubtasksHours = countTodaySubtasksHours + _subtasksList[s].allocatedHours;
          }

        }*/

         DateTime today = DateTime.now();

         var formattedTodayDate =  DateFormat('dd-MM-yyyy').format(today);
         var formattedStartDate =
         DateFormat('dd-MM-yyyy').format(taskSubtasksList[i].taskStartDate);

         if (formattedTodayDate==formattedStartDate){

           if(!taskIds.contains(taskId)){
             countTodayTasks = countTodayTasks + 1;
             taskIds.add(taskId);
             countTodayTasksHours = countTodayTasksHours + taskSubtasksList[i].taskAllocatedHours;
           }


         }



         switch(taskSubtasksList[i].taskStatus) {
           case 0 : {
             nInProgress = nInProgress + 1;
           }
           break;

           case 1: {
             nCompleted = nCompleted + 1;
           }
           break;

           case 2: {
             nOverdue = nOverdue + 1;
           }
           break;

           default: {
             //
           }
           break;
         }

       }



       setState(() {
         _currentProgress = nCompleted / taskIdsList.length;
         var percentage = (_currentProgress * 100).round();
         _currentProgressPercentage = percentage;



         countTodayTasks = taskIds.length;
         countTodayTasksHours = countTodayTasksHours + countTodaySubtasksHours;



         if(_project!=null){
           showCurrentProgress = true;
         }
       });


     });






      int total = taskIdsList.length;

      setState(() {

        _loading = false;
        _showPage = true;
      });



    }


  }


  void loadData()  {
    ServicesAPI.getCurrentProjectByStudentId(student.id).then((value) {

      setState(() {
        _project = value;

        if(_project==null){
          _loading = false;
          _showPage = true;

        } else {

          ServicesAPI.getTasksByProjectId(_project.id).then((value) {

            setState(() {
              _tasksList.addAll(value);

              if(_tasksList.length>0){
                nInProgress = 0;
                nCompleted = 0;
                nOverdue = 0;
                _tasksList.removeRange(0, _tasksList.length);
              }
              _tasksList.addAll(value);



              for(var i=0; i < _tasksList.length; i++){




                DateTime today = DateTime.now();

                var formattedTodayDate =  DateFormat('dd-MM-yyyy').format(today);
                var formattedStartDate = DateFormat('dd-MM-yyyy').format(_tasksList[i].startDate);

                if (formattedTodayDate==formattedStartDate){
                  countTodayTasks = countTodayTasks + 1;
                  countTodayTasksHours = countTodayTasksHours + _tasksList[i].allocatedHours;

                }

                switch(_tasksList[i].status) {
                  case 0 : {
                    nInProgress = nInProgress + 1;
                  }
                  break;

                  case 1: {
                    nCompleted = nCompleted + 1;
                  }
                  break;

                  case 2: {
                    nOverdue = nOverdue + 1;
                  }
                  break;

                  default: {
                    //
                  }
                  break;
                }

              }

              _currentProgress = nCompleted / _tasksList.length;
              var percentage = (_currentProgress * 100).round();
              _currentProgressPercentage = percentage;

              if(_project!=null){
                showCurrentProgress = true;
              }
              _loading = false;
              _showPage = true;
            });


          });

        }


      });

    });

  }


  @override
  Widget build(BuildContext context) {



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
       //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[


         Expanded(
           child: SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
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
                   child: ProjectsProgress(project: _project,
                     currentProgress: _currentProgress,
                   currentProgressPercentage: _currentProgressPercentage,),
                   visible: showCurrentProgress,
                 ),
                 TodayPanels(nTasks: countTodayTasks,
                 nHours: countTodayTasksHours,nSubtasks: countTodaySubtasks,),
                 Visibility(
                   child:  AllItemsPanel(project: _project,),
                   visible: showCurrentProgress,
                 ),

               ],
             ),
           ),
         ),
        ],
      ),
    );
  }

  void registerNotification() async {

    await pushNotifications.initialise();

  }



}