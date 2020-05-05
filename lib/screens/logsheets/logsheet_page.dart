import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_add.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_add.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_details.dart';
import 'package:ou_mp_app/screens/tasks/task_edit.dart';
import 'package:ou_mp_app/style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class LogSheetPage extends StatefulWidget{
  final int projectId;

  LogSheetPage({Key key, this.projectId}) : super(key : key);

  LogSheetPageState  createState() => LogSheetPageState(projectId: projectId);
}

class LogSheetPageState extends State<LogSheetPage> {
  final int projectId;

  LogSheetPageState({Key key, this.projectId});

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

    final _projectTitle = 'TM470 Project';
    final _dateFromTo = 'Feb 08 - Sept 14';


    final makeLogSheetList = Container(

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
            Text('Log Sheets'),
            Text(_projectTitle + ' | ' + _dateFromTo, style: TextStyle(
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  _logSheetsListView(context) ,
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


Widget _logSheetsListView(BuildContext context) {


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
  final logSheetId = [1, 2, 3];
  final datecreated = ['Feb 09', 'Feb 10', 'Feb 12'];
  final title = ['Sunday, 16:43', 'Monday, 18:34', 'Wednesday, 15:22'];
  final work = ['Logging on to module website, reading through the various guides...', 'Logging on to module website, reading through the various guides...','Logging on to module website, reading through the various guides...'];


 final double hLogSheets = logSheetId.length.toDouble() * 80;


  return Container(
    width: MediaQuery.of(context).size.width,
    height:MediaQuery.of(context).size.height,


    //height: hLogSheets,
    child: ListView.builder(

      itemCount: logSheetId.length,
      itemBuilder: (context, index) {

        return Card(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(datecreated[index]),
                ),
              ),
              Container(
                child: ListTileTheme(
                  child: ListTile(
                    // isThreeLine: true,
                    subtitle: Text(work[index]),
                    onTap: () {
                    //  Navigator.push(
                     //   context,
                    //    MaterialPageRoute(builder: (context) => SubtaskDetails(id:subtasksId[index])),);
                    },
                    // leading: Container(width: 10, color: Colors.red,),

                    title:      Text(title[index],
                      style: TextStyle(fontSize: 14.0),
                    ),
                    //     trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ),
            ],
          ),

        );
      },
    ),
  );



}

Widget _floatingButton(context) {

  return FloatingActionButton(
    onPressed: () {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogSheetPageAdd()),);

    },
    child: Icon(Icons.add),
    backgroundColor: Color(0xff326fb4),
  );

}