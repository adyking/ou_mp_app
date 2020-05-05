import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/subtasks/subtask_edit.dart';
import 'package:ou_mp_app/style.dart';


class SubtaskDetails extends StatefulWidget{
final int id;

SubtaskDetails({Key key, this.id}) : super (key:key);

  SubtaskDetailsState  createState() => SubtaskDetailsState(id: id);
}

class SubtaskDetailsState extends State<SubtaskDetails> {
  bool completed = false;
  final int id;

  SubtaskDetailsState({Key key, this.id});


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

    final _taskName = 'Read module material';
    final _subtaskName = 'Choose topic.';
    final double _taskDuration = 2.0;
    final  _duration = _taskDuration.toString().replaceAll('.0', '') + ' hours';
    final _subtaskDateFromTo = 'Feb 09, 2020 - Feb 09, 2020';
    final _priority = 'Medium';
    // print(id.toString());


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
                Text(_subtaskName,),
              ],
            ),
            SizedBox(height: 10.0,),

            Row(
              children: <Widget>[
                Icon(Icons.date_range, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_subtaskDateFromTo,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_duration,),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Colors.grey
                ),
                SizedBox(width: 10.0,),
                Text(_priority,),
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







    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Subtask'),
            Text(_taskName, style: TextStyle(
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
                MaterialPageRoute(builder: (context) => SubTaskPageEdit()),);
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



