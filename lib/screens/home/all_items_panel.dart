import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_page.dart';
import 'package:ou_mp_app/screens/tasks_subtasks/tasks_subtasks_list.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/style.dart';
import 'package:intl/intl.dart';
import 'package:ou_mp_app/models/TaskSubtask.dart';


class AllItemsPanel extends StatefulWidget {
  final Project project;


  AllItemsPanel({Key key, this.project}) : super (key:key);

  AllItemsPanelState createState() => AllItemsPanelState(project: project);


}


class AllItemsPanelState extends State<AllItemsPanel> {

  final Project project;

  AllItemsPanelState({Key key, this.project}) ;

  List<TaskSubtask> _overDueTasksSubtasksList = List<TaskSubtask>();

  var list;
  @override
  void initState() {


    if(project!=null){
      loadData();
    }

    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }


  void loadData() async{

    DateTime today = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedToday = formatter.format(today);

    int pid = project.id;
   _overDueTasksSubtasksList = await ServicesAPI.getTasksSubtasksByProjectIdOverdue(project.id,
        DateTime.parse(formattedToday),  DateTime.parse(formattedToday));


   setState(() {
     int lol = _overDueTasksSubtasksList.length;

     int l = lol;
   });


  }


  @override
  Widget build(BuildContext context) {



    final _pad = 10.0;

    final makeAllItems = Container(
      height: 200,
      decoration:  BoxDecoration(
       // color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        //boxShadow: [
         // setBoxShadow
        //],
      ),
      margin: EdgeInsets.only(
          top: _pad, bottom: _pad, left: _pad, right: _pad),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: _myListView(context),
      ),

    );

    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text('All Items', style: PanelTitleTextStyle,),
        ),

         makeAllItems,


      ],
    );
  }


  Widget _myListView(BuildContext context) {

    final titles = ['All Tasks & Subtasks', 'Log Sheets', 'Overdue Tasks & Subtasks'];

    final icons = [Icon(Icons.assignment,color: Color(0xff326fb4)),
      Icon(Icons.event_note,color: Color(0xff326fb4)),
      Icon(Icons.assignment_late,color: Color(0xff326fb4))];

    return ListView.builder(
      itemCount: titles.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        return Card( //                           <-- Card widget
          child: Container(
            color: Colors.white,
            child: ListTileTheme(
              selectedColor: Colors.red,
              child: ListTile(
                onTap: () {
                  switch (index) {
                    case 0:
                      {
                        if(project!=null){

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                            => TasksSubtasksList(project: project,view: 0,)),);
                        }


                      }
                      break;
                    case 1:
                      {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              LogSheetPage(project: project,)),);
                      }
                      break;
                    case 2:
                      {
                        if(project!=null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                            => TasksSubtasksList(project: project,view: 1,)),);
                        }

                      }
                      break;

                    default:
                      {

                      }
                  }

                },
                leading: icons[index],
                title: Text(titles[index]),
                trailing: index == 2 ?
                Text(_overDueTasksSubtasksList.length.toString() +'+',
                  style: TextStyle(color: _overDueTasksSubtasksList.length > 0 ? Colors.red :
                    Colors.black,),) :
                Icon(Icons.keyboard_arrow_right)
                ,
              ),
            ),
          ),
        );
      },
    );
  }

}



