import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/subtask.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_details.dart';
import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/models/TaskSubtask.dart';
import '../../main_screen.dart';
import 'package:intl/intl.dart';


class TasksSubtasksList extends StatefulWidget{
  final Project project;
  final int view; // 0 - all, 1 - overdue

  TasksSubtasksList({Key key, this.project, this.view}) : super(key : key);

  TasksSubtasksListState  createState()
      => TasksSubtasksListState(project: project,view: view);
}

class TasksSubtasksListState extends State<TasksSubtasksList> {
  final Project project;
  final int view; // 0 - all, 1 - overdue
  List<TaskSubtask> _todayTasksSubtasksList = List<TaskSubtask>();
  List<TaskSubtask> _tomorrowTasksSubtasksList = List<TaskSubtask>();
  List<TaskSubtask> _allUpcomingTasksSubtasksList = List<TaskSubtask>();
  int nInProgress = 0;
  int nCompleted = 0;
  int nOverdue = 0;
  bool _loading = true;
  bool _showPage = false;


  TasksSubtasksListState({Key key, this.project,this.view});

  bool completed = false;



  @override
  void initState() {

      loadData();


    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  void loadData() async{

    DateTime today = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedToday = formatter.format(today);
    DateTime tomorrow = DateTime.now();
    tomorrow = tomorrow.add(Duration(days: 1));
    var formattedTomorrow = formatter.format(tomorrow);

   _todayTasksSubtasksList =
      await ServicesAPI.getTasksSubtasksByProjectId(project.id,
          DateTime.parse(formattedToday),  DateTime.parse(formattedToday), 0);

    _tomorrowTasksSubtasksList =
    await ServicesAPI.getTasksSubtasksByProjectId(project.id,
        DateTime.parse(formattedTomorrow),  DateTime.parse(formattedTomorrow), 0);

    _allUpcomingTasksSubtasksList =
    await ServicesAPI.getTasksSubtasksByProjectId(project.id,
        DateTime.parse(formattedTomorrow),  DateTime.parse(formattedTomorrow), 1);

    setState(() {
      //refresh
      for(var i =0; i < _todayTasksSubtasksList.length; i++){

        switch(_todayTasksSubtasksList[i].subtaskStatus) {
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

      for(var i =0; i < _tomorrowTasksSubtasksList.length; i++){

        switch(_tomorrowTasksSubtasksList[i].subtaskStatus) {
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

      for(var i =0; i < _allUpcomingTasksSubtasksList.length; i++){

        switch(_allUpcomingTasksSubtasksList[i].subtaskStatus) {
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

      _loading = false;
      _showPage = true;
    });

  }

  @override
  Widget build(BuildContext context) {

    bool _viewToday = false;
    bool _viewTomorrow = false;
    bool _viewAllUpcoming = false;
    bool _viewOverdue = false;



    if (view==1){
      _viewOverdue =true;
    } else {
      _viewToday =true;
      _viewTomorrow=true;
      _viewAllUpcoming=true;
    }


    final makeBody = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(color: DefaultThemeColor,width: 10.0,height: 10.0, child: Text(''),),
                  SizedBox(width: 5.0,),
                  Text('In progress' + ' (' + nInProgress.toString() + ')'),
                  SizedBox(width: 5.0,),
                  Container(color: Colors.green,width: 10.0,height: 10.0, child: Text(''),),
                  SizedBox(width: 5.0,),
                  Text('Completed' + ' (' + nCompleted.toString() + ')'),
                  SizedBox(width: 5.0,),
                  Container(color: Colors.red,width: 10.0,height: 10.0, child: Text(''),),
                  SizedBox(width: 5.0,),
                  Text('Overdue'+ ' (' + nOverdue.toString() + ')'),
                ],
              ),
            ),

          ],


        ),
      ),

    );


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
            Text(project==null ? '' : project.name, style: TextStyle(
              fontSize: 14.0,
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
          makeBody,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Visibility(
                    visible: _showPage,
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

                ],
              ),
            ),
          ),

        ],

      ),

      floatingActionButton:  _floatingButton(context),
    );
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
   // final subtasksId = [1];
   // final subtasks = ['Choose topic'];
   // final tasks = ['Read module material'];
   // final subtasksStartDate = ['Feb 09'];
   // final taskProgress = ['15%'];
    //final subtasksStatus = [0];


    final double hTasks = _todayTasksSubtasksList.length.toDouble() * 80;
    double height = MediaQuery.of(context).size.height;

// height without SafeArea
    var padding = MediaQuery.of(context).padding;


// height without status and toolbar
    double heightList = height - padding.top - kToolbarHeight - 15;

    String initialDate(DateTime dt){

      var formattedDate =  DateFormat.MMMd('en_US').format(dt);

      return formattedDate;

    }


    Future <String> _getPercentage(int taskId, int status)  async  {

      int currentPercentage = 0;
      int nSubCompleted = 0;
      List<Subtask> listSubtask = List<Subtask>();

      listSubtask = await  ServicesAPI.getSubtasksByTaskId(taskId);

      for(var i=0; i < listSubtask.length; i++){

        switch(listSubtask[i].status) {


          case 1: {
            nSubCompleted = nSubCompleted + 1;
          }
          break;

          default: {
            //
          }
          break;
        }

      }


      if (listSubtask.length!=0){
        int total = 0;
        total = listSubtask.length.toInt();
        num _cProgress = nSubCompleted / total;
        num percentage = (_cProgress * 100).round();

        currentPercentage = percentage;

      } else {

        if (status==1){

          num percentage = (1 * 100).round();
          currentPercentage = percentage;
        }

      }

      return currentPercentage.toString() + '%' ;

    }

    return Container(

      height: hTasks,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _todayTasksSubtasksList.length,
        itemBuilder: (context, index) {

          return Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  _setColorStatus(_todayTasksSubtasksList[index].subtaskStatus),
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
                      Text(_todayTasksSubtasksList[index].taskName,
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text('%',
                        style: TextStyle(fontSize: 14.0),
                      ),


                    /*  FutureBuilder<String>(
                        future: _getPercentage(_todayTasksSubtasksList[index].taskId,
                            _todayTasksSubtasksList[index].taskStatus),
                        initialData: '0%',
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text('${snapshot.data}',style: TextStyle(fontSize: 14.0))
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 14.0))
                            ];
                          } else {
                            children = <Widget>[
                              Text('0%', style: TextStyle(fontSize: 14.0))
                            ];
                          }
                          return  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,

                          );
                        },

                      ),*/
                    ],
                  ),
                  onTap: () {

                    int subtaskId = _todayTasksSubtasksList[index].subtaskId;
                    int taskId = _todayTasksSubtasksList[index].taskId;
                    if (subtaskId==0){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskDetails(id:taskId)),);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                          => SubtaskDetails(id:subtaskId,taskName: _todayTasksSubtasksList[index].taskName ,)),);
                    }

                  },
                  // leading: Container(width: 10, color: Colors.red,),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_todayTasksSubtasksList[index].subtaskName
                      ),

                      Text(initialDate(_todayTasksSubtasksList[index].subtaskStartDate),
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

    final double hTasks = _tomorrowTasksSubtasksList.length.toDouble() * 80;
    double height = MediaQuery.of(context).size.height;

// height without SafeArea
    var padding = MediaQuery.of(context).padding;


// height without status and toolbar
    double heightList = height - padding.top - kToolbarHeight - 15;


    String initialDate(DateTime dt){

      var formattedDate =  DateFormat.MMMd('en_US').format(dt);

      return formattedDate;

    }


    Future <String> _getPercentage(int taskId, int status)  async  {

      int currentPercentage = 0;
      int nSubCompleted = 0;
      List<Subtask> listSubtask = List<Subtask>();

      listSubtask = await  ServicesAPI.getSubtasksByTaskId(taskId);

      for(var i=0; i < listSubtask.length; i++){

        switch(listSubtask[i].status) {


          case 1: {
            nSubCompleted = nSubCompleted + 1;
          }
          break;

          default: {
            //
          }
          break;
        }

      }


      if (listSubtask.length!=0){
        int total = 0;
        total = listSubtask.length.toInt();
        num _cProgress = nSubCompleted / total;
        num percentage = (_cProgress * 100).round();

        currentPercentage = percentage;

      } else {

        if (status==1){

          num percentage = (1 * 100).round();
          currentPercentage = percentage;
        }

      }

      return currentPercentage.toString() + '%' ;

    }


    return Container(

      height: hTasks,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tomorrowTasksSubtasksList.length,
        itemBuilder: (context, index) {

          return Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  _setColorStatus(_tomorrowTasksSubtasksList[index].subtaskStatus),
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
                      Text(_tomorrowTasksSubtasksList[index].taskName,
                        style: TextStyle(fontSize: 14.0),
                      ),

                      Text('%',
                        style: TextStyle(fontSize: 14.0),
                      ),

                      /*         FutureBuilder<String>(
                        future: _getPercentage(_tomorrowTasksSubtasksList[index].taskId,
                            _tomorrowTasksSubtasksList[index].taskStatus),
                        initialData: '0%',
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text('${snapshot.data}')
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text('Error: ${snapshot.error}')
                            ];
                          } else {
                            children = <Widget>[
                              Text('0%')
                            ];
                          }
                          return  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,

                          );
                        },

                      ),*/

                    ],
                  ),
                  onTap: () {
                    int subtaskId = _tomorrowTasksSubtasksList[index].subtaskId;
                    int taskId = _tomorrowTasksSubtasksList[index].taskId;
                    if (subtaskId==0){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskDetails(id:taskId)),);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                        => SubtaskDetails(id:subtaskId,taskName: _tomorrowTasksSubtasksList[index].taskName ,)),);
                    }
                  },
                  // leading: Container(width: 10, color: Colors.red,),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_tomorrowTasksSubtasksList[index].subtaskName
                      ),

                      Text(initialDate(_tomorrowTasksSubtasksList[index].subtaskStartDate),
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



    final double hTasks = _allUpcomingTasksSubtasksList.length.toDouble() * 80;
    double height = MediaQuery.of(context).size.height;

// height without SafeArea
    var padding = MediaQuery.of(context).padding;


// height without status and toolbar
    double heightList = height - padding.top - kToolbarHeight - 15;

    String initialDate(DateTime dt){

      var formattedDate =  DateFormat.MMMd('en_US').format(dt);

      return formattedDate;

    }


    Future <String> _getPercentage(int taskId, int status)  async  {

      int currentPercentage = 0;
      int nSubCompleted = 0;
      List<Subtask> listSubtask = List<Subtask>();

      listSubtask = await  ServicesAPI.getSubtasksByTaskId(taskId);

      for(var i=0; i < listSubtask.length; i++){

        switch(listSubtask[i].status) {


          case 1: {
            nSubCompleted = nSubCompleted + 1;
          }
          break;

          default: {
            //
          }
          break;
        }

      }


      if (listSubtask.length!=0){
        int total = 0;
        total = listSubtask.length.toInt();
        num _cProgress = nSubCompleted / total;
        num percentage = (_cProgress * 100).round();

        currentPercentage = percentage;

      } else {

        if (status==1){

          num percentage = (1 * 100).round();
          currentPercentage = percentage;
        }

      }

      return currentPercentage.toString() + '%' ;

    }


    return Container(

      height: hTasks,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _allUpcomingTasksSubtasksList.length,
        itemBuilder: (context, index) {

          return Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  _setColorStatus(_allUpcomingTasksSubtasksList[index].subtaskStatus),
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
                      Text(_allUpcomingTasksSubtasksList[index].taskName,
                        style: TextStyle(fontSize: 14.0),
                      ),

                      Text('%',
                        style: TextStyle(fontSize: 14.0),
                      ),


                      /*  FutureBuilder<String>(
                        future: _getPercentage(_allUpcomingTasksSubtasksList[index].taskId,
                            _allUpcomingTasksSubtasksList[index].taskStatus),
                        initialData: '0%',
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text('${snapshot.data}')
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text('Error: ${snapshot.error}')
                            ];
                          } else {
                            children = <Widget>[
                              Text('0%')
                            ];
                          }
                          return  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,

                          );
                        },

                      ),*/

                    ],
                  ),
                  onTap: () {
                    int subtaskId = _allUpcomingTasksSubtasksList[index].subtaskId;
                    int taskId = _allUpcomingTasksSubtasksList[index].taskId;
                    if (subtaskId==0){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskDetails(id:taskId)),);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                        => SubtaskDetails(id:subtaskId,taskName: _allUpcomingTasksSubtasksList[index].taskName ,)),);
                    }
                  },
                  // leading: Container(width: 10, color: Colors.red,),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_allUpcomingTasksSubtasksList[index].subtaskName
                      ),

                      Text(initialDate(_allUpcomingTasksSubtasksList[index].subtaskStartDate),
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
                MaterialPageRoute(builder: (context) => TaskPageAdd(projectId: project.id,)),);
            }
        ),

      ],
    );


  }


}


