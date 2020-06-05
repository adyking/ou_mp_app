import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/models/logsheet.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_edit.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_page.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:intl/intl.dart';


class LogSheetDetails extends StatefulWidget {

  final int id;
  final String projectTitle;


  LogSheetDetails({Key key, this.id, this.projectTitle}) : super (key: key);

  LogSheetDetailsState createState() =>
      LogSheetDetailsState(id: id, projectTitle: projectTitle);

}


class LogSheetDetailsState extends State<LogSheetDetails> {

  final int id;
  final String projectTitle;

  LogSheetDetailsState({Key key, this.id, this.projectTitle}) ;

  LogSheet _logSheet;
  Project _project;
  bool _loading = true;
  bool _showPage = false;


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

    _logSheet = await ServicesAPI.getLogSheetById(id);

    _project = await ServicesAPI.getProjectById(_logSheet.projectId);

    setState(() {

      _loading = false;
      _showPage = true;
    });




  }



  @override
  Widget build(BuildContext context) {

   // final _projectTitle = 'TM470 Project';
  //  final _date = 'Monday, Feb 09, 2020';
  //  final _time = '16:43';
  //  final _work = 'Finished off the last bits and pieces for the TMA. Reread the guide on structuring, styling and editing reports to see if I had covered everything. Rechecked TMA material to make sure that I’d included everything I was asked for. Carried out spell check. Print out – sort out – that’s it. TMA finished.';
  //  final _timeSpent = '1.5 hours';
 //   final _problems = 'Found it difficult to organise my TMA in what would seem a logical manner for reading. Great difficulty in writing about how I tackled the TMA. Must continue to go over the sections on effective report writing.';
  //  final _comments = 'Great relief in getting to this point. Finally I have a project skeleton. But should not wait for the verdict before pressing on!';
  //  final _nextWorkPlanned = 'Final check of TMA. Finished on time but still apprehensive about the work I have to do.';
    // print(id.toString());


    String formattedDate(DateTime dt){

      var formattedDate =  DateFormat.yMMMd('en_US').format(dt);
      var formattedDay =  DateFormat.EEEE('en_US').format(dt);

      return formattedDay + ' - ' + formattedDate;

    }
    final makeLogSheetDetailHeader = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              children: <Widget>[
                Icon(Icons.calendar_today, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_logSheet == null ? '' : formattedDate(_logSheet.loggedDate),),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_logSheet == null ? '' : _logSheet.loggedTime.substring(0,5),),
              ],
            ),

          ],


        ),
      ),

    );

    final makeTimeSpent = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Time Spent', style: PanelTitleTextStyle,),
          ),
          Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:  Text(_logSheet == null ? '' : _logSheet.timeSpent)
            ),
          ),

        ],

      ),

    );



    final makeWork = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Work', style: PanelTitleTextStyle,),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:  Text(_logSheet == null ? '' : _logSheet.work)
            ),
          ),

        ],

      ),

    );

    final makeProblems = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Problems', style: PanelTitleTextStyle,),
          ),
          Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:  Text(_logSheet == null ? '' : _logSheet.problems)
            ),
          ),

        ],

      ),

    );

    final makeComments = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Comments', style: PanelTitleTextStyle,),
          ),
          Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:  Text(_logSheet == null ? '' : _logSheet.comments)
            ),
          ),

        ],

      ),

    );

    final makeNextWorkPlanned = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Next Work Planned', style: PanelTitleTextStyle,),
          ),
          Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:  Text(_logSheet == null ? '' : _logSheet.nextWorkPlanned)
            ),
          ),

        ],

      ),

    );


    return Scaffold(
      appBar: AppBar(

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Log Sheet View'),
            Text(projectTitle + ' - Log sheet no. ' + id.toString(), style: TextStyle(
              fontSize: 14.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              print(id.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    LogSheetPageEdit(id: id,projectTitle: projectTitle,)),);
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
                        makeLogSheetDetailHeader,
                        Visibility(
                          child: makeTimeSpent,
                          visible: _logSheet != null ? true : false,
                        ),
                        makeWork,
                        Visibility(
                          child: makeProblems,
                          visible: _logSheet != null ? true : false,
                        ),
                        Visibility(
                          child: makeComments,
                          visible: _logSheet != null ? true : false,
                        ),
                        Visibility(
                          child: makeNextWorkPlanned,
                          visible: _logSheet != null ? true : false,
                        ),
                        SizedBox(height: 20.0,),
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
                MaterialPageRoute(builder: (context)
                => ProjectDetails(projectId: _project.id,)),);
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
            label: 'Return to log sheets',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => LogSheetPage(project: _project,)),);
            }
        ),

      ],
    );


  }
}



