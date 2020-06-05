import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/subtask.dart';
import 'package:ou_mp_app/models/task.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_edit.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:intl/intl.dart';
import 'package:ou_mp_app/utils/storage_util.dart';

class SubtaskDetails extends StatefulWidget{
final int id;
final String taskName;

SubtaskDetails({Key key, this.id, this.taskName}) : super (key:key);

  SubtaskDetailsState  createState() => SubtaskDetailsState(id: id,taskName: taskName);
}

class SubtaskDetailsState extends State<SubtaskDetails> {
  bool completed = false;
  final int id;
  final String taskName;
  Subtask _subtask;

  SubtaskDetailsState({Key key, this.id, this.taskName});


  @override
  void initState() {



    ServicesAPI.getSubtaskById(id).then((value) {

      setState(() {

        _subtask = value;

        if(_subtask.status==1){
          completed = true;
        }


      });

    });


    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final _taskName = 'Read module material';
    final _subtaskName = 'Choose topic.';
    final double _taskDuration = 2.0;
    final  _duration = _taskDuration.toString().replaceAll('.0', '') + ' hours';
    final _subtaskDateFromTo = 'Feb 09, 2020 - Feb 09, 2020';
    final _priority = 'Medium';
    // print(id.toString());


    String dateFormatted (DateTime dt) {

      var formattedDate =  DateFormat.yMMMd('en_US').format(dt);

      return formattedDate;

    }

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


    final makeSubtaskDetailHeader = Container(
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
                Text(_subtask == null ? '' : _subtask.name,),
              ],
            ),
            SizedBox(height: 10.0,),

            Row(
              children: <Widget>[
                Icon(Icons.date_range, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_subtask == null ? '' : dateFormatted(_subtask.startDate) + ' - ' +
                    dateFormatted(_subtask.endDate),),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_subtask == null ? '' :
                _subtask.allocatedHours.toString().replaceAll('.0', '') + ' hour(s)' ,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.priority_high, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_subtask == null ? '' : _subtask.priority,),
              ],
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

          StorageUtil.putBool('RefreshTaskDetails', true);
          StorageUtil.putBool('RefreshProjectDetails', true);
          StorageUtil.putBool('RefreshTaskSubtasksList', true);



          int status;
          if(completed){
            status = 1;

          } else {
            status = 0;
            DateTime today = DateTime.now();

            int diffDays = today.difference(_subtask.endDate).inDays;

            if (diffDays > 0) {
              status = 2; // overdue
            }

          }

          ServicesAPI.updateSubtaskStatus(id, status).then((value) {
            if(value==1){
              //success
              var statusText;
              if (status==1){
                statusText = 'completed.';
              } else {
                if(status==2){
                  statusText = 'overdue since the end date for this subtask has passed.';
                } else {
                  statusText = 'in progress.';
                }

              }
              var msg = 'Subtask has been updated and marked as ' + statusText;
              _showAlertDialog('Info', msg);
            }

          });
        });
      },

    );

    final makeSubtaskStatus = Container(

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
                    => TaskDetails(id: _subtask.taskId,)),);

                },
              ),
            ],
          );
        },
      );
    }


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
                  ServicesAPI.deleteSubtask(_subtask.id).then((value) {

                    if(value==1){

                      // Update allocated hours for the main task
                      ServicesAPI.getSubtasksByTaskId(_subtask.taskId).then((value) {
                        double countTime = 0.0;
                        for(var i=0; i < value.length; i++){

                          countTime = countTime + value[i].allocatedHours;

                        }

                        ServicesAPI.updateTaskEstimatedTime(_subtask.taskId, countTime).then((value) {
                          if (value != 0) {
                            var msg = '' + _subtask.name + ' has been deleted successfully!';
                            _showDeleteAlertDialog('Info', msg);
                          }
                        });

                      });




                    } else {
                      var msg = 'Could not delete ' + _subtask.name + ', please try again.';
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
            Text('Subtask'),
            Text(taskName == null ? '' : taskName, style: TextStyle(
              fontSize: 14.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {

              setState(() {

                if (completed){
                  var msg = 'Cannot edit this subtask because is marked as completed.';
                  _showAlertDialog('Alert', msg);

                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubTaskPageEdit(id: id,)),);
                }

              });


            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

              var msg = 'Are you sure you want to delete ' + _subtask.name + '?';
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

                  makeSubtaskDetailHeader,
                  makeSubtaskStatus,
                  SizedBox(height: 50.0,),


                ],
              ),
            ),
          ),

        ],

      ),

    );
  }

}



