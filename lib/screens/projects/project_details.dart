import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_add.dart';
import 'package:ou_mp_app/screens/projects/project_edit.dart';
import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/utils/storage_util.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../../main_screen.dart';
import 'package:ou_mp_app/models/task.dart';
import 'package:ou_mp_app/main_screen.dart';

class ProjectDetails extends StatefulWidget{

  final int projectId;

  ProjectDetails({Key key, this.projectId}) : super(key :key);

  @override
  ProjectDetailsState createState() => ProjectDetailsState(projectId: projectId);

}


class ProjectDetailsState extends State<ProjectDetails> {
  final int projectId;
  Project _project;
  Student _student;
  bool _loading = true;
  bool _showPage = false;
  List<Task> _tasksList = List<Task>();
  int nInProgress = 0;
  int nCompleted = 0;
  int nOverdue = 0;
  double _currentProgress = 0.0;
  int  _currentProgressPercentage = 0;


  ProjectDetailsState({Key key, this.projectId});



  @override
  void initState() {
    loadData();
    super.initState();
  }


  @override
  void dispose() {


    _project = null;
    _student = null;

    super.dispose();
  }

  loadData () async{
    ServicesAPI.getProjectById(projectId).then((value) {
      setState(() {

        _project = value;

        ServicesAPI.getTasksByProjectId(projectId).then((value) {
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

          });

        });

        ServicesAPI.getStudentById(_project.studentId).then((value) {
          setState(() {

            _student = value;
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
              center: new Text( _currentProgressPercentage.toString()+"%", style: TextStyle(
                color: Colors.white,
              ),),
              progressColor: Colors.green,
            ),
            SizedBox(height: 5.0,),
            Text(_project == null ? '' : _project.name, style: TextStyle(
                fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 10.0,),
            Text(_project == null ? '' : _project.description, style: TextStyle(
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
             Text(_project == null ? '' : _project.category,),
           ],
         ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Icon(Icons.date_range, color: Colors.grey
              ),
              SizedBox(width: 10.0,),
              Text(_project == null ? '' : dateFormatted(_project.startDate) + ' - ' +
                dateFormatted(_project.endDate),),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Icon(Icons.assignment_ind, color: Colors.grey
              ),
              SizedBox(width: 10.0,),
              Text(_student == null ? '' : _student.name,),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Icon(Icons.format_list_numbered, color: Colors.grey
              ),
              SizedBox(width: 10.0,),
              Text(_tasksList == null ? '' :
              _tasksList.length.toString() + ' Task(s)' ,),
            ],
          ),
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

                setState(() {
                  if (title=='Error') {

                    Navigator.pop(context);

                  } else {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MainScreen(tabIndex: 1,studentId: _student.id,)),);
                  }


                });




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
                  ServicesAPI.deleteProject(_project.id).then((value) {

                    if(value==1){
                      var msg = '' + _project.name + ' has been deleted successfully!';
                      _showAlertDialog('Info', msg);
                    } else {
                      var msg = 'Could not delete ' + _project.name + ', please try again.';
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

  showAlertConfirmDialog(BuildContext context, String projectName) {

    // set up the buttons
    Widget noButton = FlatButton(
      child: Text('NO'),
      onPressed:  () {

        Navigator.pop(context);

      },
    );
    Widget yesButton = FlatButton(
      child: Text('YES'),
      onPressed:  () {


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Confirm'),
      content: Text('Are you sure you want to delete ' + projectName + '?'),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  return Scaffold(
      appBar: AppBar(
        title: Text('', style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
                setState(() {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ProjectPageEdit(projectId: projectId,)),);
                });

            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {

                var msg = 'Are you sure you want to delete ' + _project.name + '?';
                _showAlertConfirmDialog('Confirm', msg);
               // showAlertConfirmDialog(context, _project.name);


              });
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
                    visible: _showPage ,
                    child: Column(
                      children: <Widget>[
                        makeProjectDetailHeader,
                        makeProjectDetailBody,

                        Visibility(
                          visible: _tasksList.length == 0 ? false : true,
                          child: Column(
                            children: <Widget>[
                              makeTasksTitle,
                              _myListView(context) ,
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

  Widget _myListView(BuildContext context) {

   // final tasks = ['Read module material', 'Write up on topic'];
  //  final tasksStartDate = ['Feb 09', 'Feb 12'];
   // final tasksId = [1, 2];


    final double hTasks = _tasksList.length.toDouble() * 80;


    int _percentage(int taskId, int status) {
      int _currentPercentage = 0;

      ServicesAPI.getSubtasksByTaskId(taskId).then((value) {

        setState(() {

          if (value.length!=0){
            int total = 0;
            total = value.length.toInt();
             num _cProgress = nCompleted / total;
            num percentage = (_cProgress * 100).round();
            _currentPercentage = percentage;
          } else {

            if (status==1){


              num percentage = (1 * 100).round();
              _currentPercentage = percentage;
            }

          }



        });

      });

      return _currentPercentage;

    }

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

    String initialDate(DateTime dt){

      var formattedDate =  DateFormat.MMMd('en_US').format(dt);

      return formattedDate;

    }


    return Container(

      height: hTasks,
      child: ListView.builder(

        itemCount: _tasksList.length,
        itemBuilder: (context, index) {

          return Card(

            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:  _setColorStatus(_tasksList[index].status),
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


                      Text( _percentage(_tasksList[index].id, _tasksList[index].status).toString() +'%',
                        style: TextStyle(fontSize: 14.0),
                      ),

                    ],
                  ),
                  onTap: () {

                    _loading = true;
                    _showPage = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          TaskDetails(id:_tasksList[index].id)),).then((value) {


                      bool refresh = StorageUtil.getBool('RefreshProjectDetails');

                      if(refresh){
                        StorageUtil.removeKey('RefreshProjectDetails');
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
                      Text(_tasksList[index].name
                      ),

                      Text(initialDate(_tasksList[index].startDate),
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
                MaterialPageRoute(builder: (context) => TaskPageAdd(projectId: projectId,)),);
            }
        ),

      ],
    );

  }

}


