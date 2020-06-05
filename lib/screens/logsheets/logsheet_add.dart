import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_page.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LogSheetPageAdd extends StatefulWidget {

  final Project project;

  LogSheetPageAdd({Key key, this.project}) : super(key:key);

  LogSheetPageAddState createState()
    => LogSheetPageAddState(project: project);
}

class LogSheetPageAddState extends State<LogSheetPageAdd> {

  final Project project;

  LogSheetPageAddState({Key key, this.project});

  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;

  final timeSpentController = TextEditingController();
  final workController = TextEditingController();
  final problemsController = TextEditingController();
  final commentsController = TextEditingController();
  final nextWorkPlannedController = TextEditingController();



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



    final makeTimeSpentField = TextFormField(
      controller: timeSpentController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Time Spent',
      ),
    );

    final makeWorkField = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: workController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Work*',
      ),
    );


    final makeProblemsField = TextFormField(
      controller: problemsController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Problems',
      ),
    );

    final makeCommentsField = TextFormField(
      controller: commentsController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Comments',
      ),
    );

    final makeNextWorkPlannedField = TextFormField(
      controller: nextWorkPlannedController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Next Work Planned',
      ),
    );


    final makeUserHelp = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Please correct the following error(s):',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color:  Colors.red,
                  width: 6.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$userHelpText',
              ),
            ),
          ),
        ),

        SizedBox(
          height: 30.0,
        ),
      ],
    );

    Future<void> _showAlertDialog(String title, String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$msg'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        LogSheetPage(project: project,)),);

                },
              ),
            ],
          );
        },
      );
    }

    void createLogSheet() async {


      DateTime today = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      var formatter2 = DateFormat('HH:mm:ss');
      var formattedToday = formatter.format(today);
      var formattedToday2 = formatter2.format(today);

      //var formattedTime = today.hour.toString() + ':' + today.minute.toString() +
        //  ':' + today.second.toString();

      int lastId =  await ServicesAPI.addLogSheet(project.id, timeSpentController.text,
          workController.text, problemsController.text, commentsController.text,
          nextWorkPlannedController.text, DateTime.parse(formattedToday), formattedToday2);

      if(lastId !=0) {
        _showAlertDialog('Info', 'A new log sheet has been recorded successfully!');
      }


    }

    bool checkFields() {
      bool errors = false;
      setState(() {
        if (workController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Work field is required.';
        }



      });
      return errors;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          project.name,
          style: AppBarTheme.of(context).textTheme.title,
        ),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              userHelpText = '';
              bool errors = false;
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;
                createLogSheet();

              }

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
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            makeTimeSpentField,
                            makeWorkField,
                            makeProblemsField,
                            makeCommentsField,
                            makeNextWorkPlannedField,
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              children: <Widget>[Text('* required field')],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      child: makeUserHelp,
                      visible: userHelpText == null ? false : true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void displaySuccessAlert() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Sucess",
      desc: "New log sheet has been created sucessfully!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskDetails()),);
          },
          width: 120,
        )
      ],
    ).show();

  }
}
