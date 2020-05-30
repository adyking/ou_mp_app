import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';


class TodayPanels extends StatelessWidget {

final int nTasks;
final double nHours;
final int nSubtasks;


TodayPanels({Key key, this.nTasks, this.nHours, this.nSubtasks}) : super(key:key);

  @override
  Widget build(BuildContext context) {

    final _pad = 10.0;


    final makeTasks = Container(
    // width: MediaQuery.of(context).size.width - 230,

      decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          setBoxShadow
        ],
      ),
      margin: EdgeInsets.only(
          top: _pad, bottom: _pad, left: _pad, right: _pad),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Icon(Icons.assignment,
                  color: Colors.green,
                  size: 50,
                )
                ),
                SizedBox(height: 10),
                Text('Tasks/Subtasks'),
                SizedBox(height: 10),
                Text(nTasks.toString() + '/' + nSubtasks.toString(), style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.0
                )
                  ,)
              ],

            ),



      ),

    );

    final makeTimeAllocation = Container(
      // width: MediaQuery.of(context).size.width - 230,

      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          setBoxShadow
        ],
      ),
      margin: EdgeInsets.only(
          top: _pad, bottom: _pad, left: _pad, right: _pad),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Icon(Icons.timer,
              color: Colors.orangeAccent,
              size: 50,
            )
            ),
            SizedBox(height: 10),
            Text('Allocated Time'),
            SizedBox(height: 10),
            Text(nHours.toString().replaceAll('.0', '') + ' hour(s)', style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 26.0
            )
              ,)
          ],

        ),



      ),

    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text('Today', style: PanelTitleTextStyle,),
        ),
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             // makeTasks,
            //  makeTimeAllocation,
              Expanded(
                flex: 5, // 50% of space => (5/(5 + 4))
                child:  makeTasks,

              ),
              Expanded(
                flex: 5, // 50%
                child:  makeTimeAllocation,

              ),

            ],
          ),

      ],
    );
  }
}