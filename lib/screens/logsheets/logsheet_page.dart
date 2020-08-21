import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/models/logsheet.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_add.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_details.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:intl/intl.dart';

import '../../main_screen.dart';



class LogSheetPage extends StatefulWidget{
  final Project project;

  LogSheetPage({Key key, this.project}) : super(key : key);

  LogSheetPageState  createState() => LogSheetPageState(project: project);
}

class LogSheetPageState extends State<LogSheetPage> {
  final Project project;
  List<LogSheet> _logSheetList = new List<LogSheet>();
  bool _loading = true;
  bool _showPage = false;

  LogSheetPageState({Key key, this.project});

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

    _logSheetList = await ServicesAPI.getLogSheetsByProjectId(project.id);

    setState(() {

      _loading = false;
      _showPage = true;
    });



  }

  @override
  Widget build(BuildContext context) {





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
      /*  leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 0,)),
            );
          },
        ),*/
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Log Sheets'),
            Text(project.name, style: TextStyle(
              fontSize: 14.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,


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
                        _logSheetsListView(context) ,
                        SizedBox(height: 50.0,),
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

  Widget _logSheetsListView(BuildContext context) {



    //final logSheetId = [1, 2, 3];
    //final dateCreated = ['Feb 09', 'Feb 10', 'Feb 12'];
    // final title = ['Sunday, 16:43', 'Monday, 18:34', 'Wednesday, 15:22'];
    //final work = ['Finished off the last bits and pieces for the TMA. Reread the guide on structuring, styling and editing reports to see if I had covered everything. Rechecked TMA material to make sure that I’d included everything I was asked for. Carried out spell check. Print out – sort out – that’s it. TMA finished.', 'Finished off the last bits and pieces for the TMA. Reread the guide on structuring, styling and editing reports to see if I had covered everything. Rechecked TMA material to make sure that I’d included everything I was asked for. Carried out spell check. Print out – sort out – that’s it. TMA finished.','Finished off the last bits and pieces for the TMA. Reread the guide on structuring, styling and editing reports to see if I had covered everything. Rechecked TMA material to make sure that I’d included everything I was asked for. Carried out spell check. Print out – sort out – that’s it. TMA finished.'];


    //final double hLogSheets = logSheetId.length.toDouble() * 200;
    // full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// height without SafeArea
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

// height without status bar
    double height2 = height - padding.top;

// height without status and toolbar
    double height3 = height - padding.top - kToolbarHeight - 15;

    String formattedDate(DateTime dt){

      var formattedDate =  DateFormat.MMMd('en_US').format(dt);

      return formattedDate;

    }


    String dayTime(DateTime d, String t){

      var formattedDay =  DateFormat.EEEE('en_US').format(d);
     // var formatter =   DateFormat('HH:mm');
     

      return formattedDay + ', ' + t.substring(0,5);

    }

    return Container(

      height: height3 ,

      //height: hLogSheets,
      child: ListView.builder(

        itemCount: _logSheetList.length,
        itemBuilder: (context, index) {

          return Card(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(formattedDate(_logSheetList[index].loggedDate)),
                  ),
                ),
                Container(
                  child: ListTileTheme(
                    child: ListTile(
                      // isThreeLine: true,
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Text(_logSheetList[index].work),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)
                            => LogSheetDetails(id:_logSheetList[index].id,
                              projectTitle: project.name,)),);
                      },
                      // leading: Container(width: 10, color: Colors.red,),

                      title:  Text(dayTime((_logSheetList[index].loggedDate),
                          _logSheetList[index].loggedTime),
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
            label: 'Return to Dashboard',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    MainScreen(tabIndex: 0,studentId: project.studentId,)),);
            }

        ),


        SpeedDialChild(
            labelBackgroundColor: Color(0xff326fb4),

            backgroundColor: Color(0xff326fb4),
            foregroundColor: Colors.white,

            labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
            child: Icon(Icons.chrome_reader_mode),
            label: 'Project details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => ProjectDetails(projectId: project.id,)),);
            }

        ),

        SpeedDialChild(
            labelBackgroundColor: Color(0xff326fb4),
            backgroundColor: Color(0xff326fb4),
            //foregroundColor: Colors.black,
            foregroundColor: Colors.white,
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
            child: Icon(Icons.event_note),
            // labelWidget: Text('Auto Join', style: TextStyle(color: Colors.white),),
            label: 'Record new log sheet',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => LogSheetPageAdd(project: project,)),);
            }
        ),

      ],
    );


  }
}

