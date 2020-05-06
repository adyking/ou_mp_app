import 'package:flutter/material.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_edit.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_page.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_edit.dart';
import 'package:ou_mp_app/style.dart';




class LogSheetDetails extends StatelessWidget {

  final int id;

  LogSheetDetails({Key key, this.id}) : super (key:key);



  @override
  Widget build(BuildContext context) {
    final _projectTitle = 'TM470 Project';
    final _date = 'Monday, Feb 09, 2020';
    final _time = '16:43';
    final _work = 'Finished off the last bits and pieces for the TMA. Reread the guide on structuring, styling and editing reports to see if I had covered everything. Rechecked TMA material to make sure that I’d included everything I was asked for. Carried out spell check. Print out – sort out – that’s it. TMA finished.';
    final _timeSpent = '1.5 hours';
    final _problems = 'Found it difficult to organise my TMA in what would seem a logical manner for reading. Great difficulty in writing about how I tackled the TMA. Must continue to go over the sections on effective report writing.';
    final _comments = 'Great relief in getting to this point. Finally I have a project skeleton. But shouldn’t wait for the verdict before pressing on!';
    final _nextWorkPlanned = 'Final check of TMA. Finished on time but still apprehensive about the work I have to do.';
    // print(id.toString());


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
                Text(_date,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_time,),
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
                child:  Text('$_timeSpent')
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
              child:  Text('$_work')
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
                child:  Text('$_problems')
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
                child:  Text('$_comments')
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
                child:  Text('$_nextWorkPlanned')
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
            Text(_projectTitle, style: TextStyle(
              fontSize: 14.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogSheetPageEdit()),);
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

                  makeLogSheetDetailHeader,
                  Visibility(
                    child: makeTimeSpent,
                    visible: _timeSpent != '' ? true : false,
                  ),
                  makeWork,
                  Visibility(
                    child: makeProblems,
                    visible: _problems != '' ? true : false,
                  ),
                  Visibility(
                    child: makeComments,
                    visible: _comments != '' ? true : false,
                  ),
                  Visibility(
                    child: makeNextWorkPlanned,
                    visible: _nextWorkPlanned != '' ? true : false,
                  ),
                  SizedBox(height: 20.0,),


                ],
              ),
            ),
          ),

        ],

      ),

    );
  }

}



