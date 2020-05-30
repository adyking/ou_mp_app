import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ou_mp_app/style.dart';


class ProjectsProgress extends StatelessWidget {

  final Project project;
  final double currentProgress;
  final int currentProgressPercentage;

  ProjectsProgress({Key key, this.project,
    this.currentProgress,this.currentProgressPercentage}) : super(key:key);

  @override
  Widget build(BuildContext context) {

    final _pad = 10.0;


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

    final makeProgress = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('CURRENT PROGRESS'),
        SizedBox(height: 10),
        Text(project.name, style: TextStyle(
            fontSize: 14.0
        ),),
        SizedBox(height: 10),
        LinearPercentIndicator(
         // width: MediaQuery.of(context).size.width - 40,
          animation: true,
          lineHeight: 14.0,
          animationDuration: 2500,
          percent: currentProgress,
         // trailing: Icon(Icons.flag),
          center: Text(currentProgressPercentage.toString() + '%', style: TextStyle(
            fontSize: 12.0
          ),),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: _setColorStatus(project.status),
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