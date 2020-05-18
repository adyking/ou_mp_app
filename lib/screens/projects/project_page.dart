import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/projects/project_add.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:intl/intl.dart';


class ProjectPage extends StatefulWidget{
  final Student student;

  ProjectPage({Key key, this.student}) : super(key : key);

  ProjectPageState  createState() => ProjectPageState(student:student);
}


class ProjectPageState extends State<ProjectPage> {
  final Student student;
  List<Project> _projectsList = List<Project>();
  bool loadingProgress = true;
  ProjectPageState({Key key, this.student});


  @override
  void initState() {

    ServicesAPI.getProjectByStudentId(student.id).then((value) {
      setState(() {
        _projectsList.addAll(value);
        loadingProgress = false;
      });


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Projects', style: AppBarTheme.of(context).textTheme.title,),
          backgroundColor: AppBarBackgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectPageAdd(studentId: student.id,)),);
              },
            ),


          ],
          centerTitle: true,
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
                      visible:  loadingProgress,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0,),
                          CircularProgressIndicator(),
                          SizedBox(height: 10.0,),
                        ],
                      ) ,
                    ),

                    Container(

                      child: _myListView(context) ,
                    ),

                  ],
                ),
              ),
            ),

          ],

        ),


      ),
    );
  }

  Widget _myListView(BuildContext context) {


    String dateFormatted (DateTime dt) {

      var formattedDate =  DateFormat.yMMMd('en_US').format(dt);

      return formattedDate;

    }

    final double listH = _projectsList.length.toDouble() * 80;

    return Container(
      height: listH,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _projectsList.length,
        itemBuilder: (context, index) {

          return Card( //                           <-- Card widget
            child: Container(

              color: Colors.white,
              child: ListTileTheme(

                child: ListTile(
                  // isThreeLine: true,
                  subtitle: Text(_projectsList[index].category + '\n' +
                     dateFormatted(_projectsList[index].startDate) + ' - ' +
                    dateFormatted(_projectsList[index].endDate),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ProjectDetails(projectId: _projectsList[index].id,)),);
                  },
                  // leading: icons[index],
                  title: Text(_projectsList[index].name),
                  trailing: Icon(Icons.keyboard_arrow_right)
                  ,
                ),
              ),
            ),
          );
        },
      ),
    );
  }



}


