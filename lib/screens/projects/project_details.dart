import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_add.dart';
import 'package:ou_mp_app/screens/projects/project_edit.dart';
import 'package:ou_mp_app/screens/tasks/task_add.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../../main_screen.dart';
import 'package:ou_mp_app/models/task.dart';

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

  ProjectDetailsState({Key key, this.projectId});



  @override
  void initState() {

    ServicesAPI.getProjectById(projectId).then((value) {
      setState(() {

        _project = value;

        ServicesAPI.getTasksByProjectId(projectId).then((value) {
          setState(() {

            _tasksList.addAll(value);
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



    super.initState();
  }


  @override
  void dispose() {


    _project = null;
    _student = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


  final double _currentProgress = 0.25;
  final  _calProgress = _currentProgress * 100;
  final _progress = _calProgress.toInt();
//  final _name = 'jjjj';

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
              center: new Text( _progress.toString()+"%", style: TextStyle(
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
              children: <Widget>[
                Container(color: DefaultThemeColor,width: 10.0,height: 10.0, child: Text(''),),
                SizedBox(width: 10.0,),
                Text('In progress'),
                SizedBox(width: 10.0,),
                Container(color: Colors.green,width: 10.0,height: 10.0, child: Text(''),),
                SizedBox(width: 10.0,),
                Text('Completed'),
                SizedBox(width: 10.0,),
                Container(color: Colors.red,width: 10.0,height: 10.0, child: Text(''),),
                SizedBox(width: 10.0,),
                Text('Overdue'),
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
                MaterialPageRoute(builder: (context) => ProjectPageEdit(projectId: projectId,)),);
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
                      MaterialPageRoute(builder: (context) =>
                          TaskDetails(id:_tasksList[index].id)),);
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


