import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_add.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_details.dart';
import 'package:ou_mp_app/screens/tasks/task_edit.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/utils/storage_util.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ou_mp_app/models/task.dart';
import 'package:ou_mp_app/models/subtask.dart';
import 'package:intl/intl.dart';



class TaskDetails extends StatefulWidget{
  final int id;




  TaskDetails({Key key, this.id}) : super(key : key);

  TaskDetailsState  createState() => TaskDetailsState(id: id);
}

class TaskDetailsState extends State<TaskDetails> {
  final int id;
  Task _task;



  TaskDetailsState({Key key, this.id});

  bool _loading = true;
  bool _showPage = false;
  bool _showStatus = true;
  bool completed = false;
  List<Subtask> _subtasksList = List<Subtask>();
  String _projectName;
  int nInProgress = 0;
  int nCompleted = 0;
  int nOverdue = 0;
  String _projectDates;
  double _currentProgress = 0.0 ;
  int  _currentProgressPercentage = 0;

  @override
  void initState() {


    loadData();
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  loadData() async {
    ServicesAPI.getTaskById(id).then((value) {

      setState(() {
        _task = value;

        if(_task.status==1){
          completed = true;
        }

        ServicesAPI.getProjectById(_task.projectId).then((value) {

          setState(() {

            _projectName = value.name;

            var formattedStartDate =  DateFormat.yMMMd('en_US').format(value.startDate);
            var formattedEndDate =  DateFormat.yMMMd('en_US').format(value.endDate);

            _projectDates = formattedStartDate + ' - ' + formattedEndDate;
          });

        });

        ServicesAPI.getSubtasksByTaskId(id).then((value) {
          setState(() {
            if(_subtasksList.length>0){
              nInProgress = 0;
              nCompleted = 0;
              nOverdue = 0;
              _subtasksList.removeRange(0, _subtasksList.length);
            }
            _subtasksList.addAll(value);

            if(_subtasksList.length>0){
              _showStatus = false;
            }

            int countCompleted = 0;

            for(var i=0; i < _subtasksList.length; i++){

              switch(_subtasksList[i].status) {
                case 0 : {
                  nInProgress = nInProgress + 1;
                }
                break;

                case 1: {
                  nCompleted = nCompleted + 1;
                  countCompleted = countCompleted + 1;
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



            if(_subtasksList.length==countCompleted){
              // update main task status

              if(_subtasksList.length!=0) {
                ServicesAPI.updateTaskStatus(id, 1).then((value) {

                });
              }

            } else {

              DateTime today = DateTime.now();
              int status = 0;
              int diffDays = today.difference(_task.endDate).inDays;

              if (diffDays > 0) {
                status = 2;
              }

              ServicesAPI.updateTaskStatus(id, status).then((value) {

              });

            }

            if (_subtasksList.length!=0){
              int total = 0;
              total =_subtasksList.length.toInt();
              _currentProgress = nCompleted / total;
              num percentage = (_currentProgress * 100).round();
              _currentProgressPercentage = percentage;
            } else {

              if (completed){

                _currentProgress = 1 ;
                num percentage = (_currentProgress * 100).round();
                _currentProgressPercentage = percentage;
              }

            }


            _loading = false;
            _showPage = true;
          });

        });


      });



    });

  }


  @override
  Widget build(BuildContext context) {




    String dateFormatted (DateTime dt) {

      var formattedDate =  DateFormat.yMMMd('en_US').format(dt);

      return formattedDate;

    }

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
                Text(_task == null ? '' :_task.name,),
              ],
            ),
            SizedBox(height: 10.0,),

            Row(
              children: <Widget>[
                Icon(Icons.date_range, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_task == null ? '' : dateFormatted(_task.startDate) + ' - ' +
                    dateFormatted(_task.endDate),),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_task == null ? '' :
                _task.allocatedHours.toString().replaceAll('.0', '') + ' hour(s)' ,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.format_list_numbered, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_subtasksList == null ? '' :
                _subtasksList.length.toString() + ' Subtask(s)' ,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.priority_high, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_task == null ? '' : _task.priority,),
              ],
            ),

            Visibility(
              visible: _subtasksList.length ==0 ? false : true,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0,),
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
                  SizedBox(height: 15.0,),
                  LinearPercentIndicator(
                    // width: MediaQuery.of(context).size.width - 40,
                    animation: true,
                    lineHeight: 14.0,
                    animationDuration: 2500,
                    percent: _currentProgress,
                    // trailing: Icon(Icons.flag),
                    center: Text(_currentProgressPercentage.toString() +'%', style: TextStyle(
                        fontSize: 12.0
                    ),),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: completed ? Colors.green :  Color(0xff326fb4),
                    backgroundColor: Colors.grey[300],
                  ),
                ],
              ),
            ),



          ],


        ),
      ),

    );

    Future<void> _showAlertDialog(String title, String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$msg'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {

                  Navigator.pop(context);

                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showDeleteAlertDialog(String title, String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$msg'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)
                    => ProjectDetails(projectId: _task.projectId,)),);

                },
              ),
            ],
          );
        },
      );
    }


    final makeCompletedCheckBox = Checkbox(
        value: completed,
         onChanged: (bool value) {
           setState(() {
             completed = value;

             if(completed==false){

               _currentProgress =  0;
               num percentage = (_currentProgress * 100).round();
               _currentProgressPercentage = percentage;


             } else {
               _currentProgress =  1;
               num percentage = (_currentProgress * 100).round();
               _currentProgressPercentage = percentage;

             }


             StorageUtil.putBool('RefreshProjectDetails', true);

             int status;
             if(completed){
               status = 1;

             } else {
               status = 0;
               DateTime today = DateTime.now();

               int diffDays = today.difference(_task.endDate).inDays;

               if (diffDays > 0) {
                 status = 2; // overdue
               }

             }

             ServicesAPI.updateTaskStatus(id, status).then((value) {
               setState(() {

                 if(value==1){
                   //success
                   var statusText;
                   if (status==1){
                     statusText = 'completed.';
                   } else {
                     if(status==2){
                       statusText = 'overdue since the end date for this task has passed.';
                     } else {
                       statusText = 'in progress.';
                     }

                   }




                   var msg = 'Task has been updated and marked as ' + statusText;
                   _showAlertDialog('Info', msg);
                 }

               });


             });
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


    Future<void> _showAlertConfirmDialog(String title, String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$msg'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  //  setState(() {

                  Navigator.pop(context);
                  ServicesAPI.deleteTask(_task.id).then((value) {

                    if(value==1){

                      var msg = '' + _task.name + ' has been deleted successfully!';
                      _showDeleteAlertDialog('Info', msg);

                    } else {
                      var msg = 'Could not delete ' + _task.name + ', please try again.';
                      _showAlertDialog('Error', msg);
                    }

                  });
                  // });
                },
              ),

              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }



    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Task'),
            Text(_projectName  == null ? '' : _projectName
            ),

          ],
        ),

        backgroundColor: AppBarBackgroundColor,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              if(completed){
                var msg = 'Cannot edit this task because is marked as completed.';
                _showAlertDialog('Alert', msg);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskPageEdit(id: id,)),);
              }

            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {


              var msg = 'Are you sure you want to delete ' + _task.name + '?';
              _showAlertConfirmDialog('Confirm', msg);



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
                    visible: _showPage,
                    child: Column(
                      children: <Widget>[
                        makeTaskDetailHeader,
                        Visibility(
                          visible: _showStatus,
                          child: makeTaskStatus,
                        ),
                        Visibility(
                          visible: _subtasksList.length == 0 ? false : true,
                          child: Column(
                            children: <Widget>[
                              makeTasksTitle,
                              _subtasksListView(context) ,
                              SizedBox(height: 50.0,),
                            ],
                          ),
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
            label: 'Return to project details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ProjectDetails(projectId: _task.projectId,)),);
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
            label: 'Add new subtask',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubTaskPageAdd(taskId: id,)),);
            }
        ),

      ],
    );

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
    String dateFormatted (DateTime dt) {

      var formattedDate =  DateFormat.MMMd('en_US').format(dt);

      return formattedDate;

    }
    
    final subtasksId = [1, 2];
    final subtasks = ['Choose topic', 'Research on chosen topic'];
    final subtasksStartDate = ['Feb 09', 'Feb 10'];
    final subtasksEstimatedTime = ['2 hours', '2 hours'];
    final subtasksStatus = [1, 0];


    final double hTasks = _subtasksList.length.toDouble() * 80;


    return Container(

      height: hTasks,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _subtasksList.length,
        itemBuilder: (context, index) {

          return Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  _setColorStatus(_subtasksList[index].status),
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


                      Text(_subtasksList[index].allocatedHours.toString().replaceAll('.0', '') + ' hours',
                        style: TextStyle(fontSize: 14.0),
                      ),

                    ],
                  ),
                  onTap: () {

                    _currentProgressPercentage = 0;
                    _currentProgress = 0.0;
                    _loading = true;
                   _showPage = false;
                    Navigator.push(
                      context,
                     MaterialPageRoute(builder: (context) =>
                          SubtaskDetails(id:_subtasksList[index].id,taskName: _task.name,)),).then((value) {


                            bool refresh = StorageUtil.getBool('RefreshTaskDetails');

                            if(refresh){
                              StorageUtil.removeKey('RefreshTaskDetails');
                              setState(() {
                                loadData();
                              });
                            }


                    });
                  },
                  // leading: Container(width: 10, color: Colors.red,),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_subtasksList[index].name
                      ),

                      Text(dateFormatted(_subtasksList[index].startDate),
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

}


