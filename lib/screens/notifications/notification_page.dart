import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/message.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/tasks_subtasks/tasks_subtasks_list.dart';
import 'package:ou_mp_app/style.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final String title;
  final String body;
  final Project project;
  final int notificationType;
  final int status;



  NotificationPage({Key key, this.title, this.body,
    this.project, this.notificationType, this.status}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: new Container(),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title:  Text('New Notification'),
        centerTitle: true,
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
                  _notificationListView(context, title, body, DateTime.now(),
                      project, notificationType, status) ,
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
Widget _notificationListView(BuildContext context, String title, String body,
    DateTime dt, Project project, int notificationType, int status) {

  final List<Message> messages = [];
  messages.add(Message(title: title, body: body));

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

    var formattedDate =  DateFormat.yMMMd('en_US').format(dt);

    return formattedDate;

  }

  return Container(

    height: height3 ,

    child: ListView.builder(

      itemCount: messages.length,
      itemBuilder: (context, index) {

        return Card(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(formattedDate(dt)),
                ),
              ),
              Container(
                child: ListTileTheme(
                  child: ListTile(
                    // isThreeLine: true,
                    onTap: () {

                      if (notificationType==0) {

                        if (status==0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                            => TasksSubtasksList(project: project,view: 0,)),);
                        } else {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                            => TasksSubtasksList(project: project,view: 1,)),);

                        }

                      } else {
                          // do nothing
                      }



                    },
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Text(messages[index].body),
                    ),

                    title:  Text(messages[index].title, style: TextStyle(fontSize: 14.0),
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