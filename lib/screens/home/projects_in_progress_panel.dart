import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ou_mp_app/style.dart';


class ProjectsProgress extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final _pad = 10.0;

    final makeProgress = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('CURRENT PROGRESS'),
        SizedBox(height: 10),
        Text("TM470 Project", style: TextStyle(
            fontSize: 14.0
        ),),
        SizedBox(height: 10),
        LinearPercentIndicator(
         // width: MediaQuery.of(context).size.width - 40,
          animation: true,
          lineHeight: 14.0,
          animationDuration: 2500,
          percent: 0.25,
         // trailing: Icon(Icons.flag),
          center: Text("25%", style: TextStyle(
            fontSize: 12.0
          ),),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Color(0xff326fb4),
          backgroundColor: Colors.grey[300],
        ),

      ],
    );


    return Container(
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
            child: makeProgress,
          ),

    );
  }
}