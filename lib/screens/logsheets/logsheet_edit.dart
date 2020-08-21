import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/models/logsheet.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LogSheetPageEdit extends StatefulWidget {

  final int id;
  final String projectTitle;

  LogSheetPageEdit({Key key, this.id, this.projectTitle}) : super(key:key);

  LogSheetPageEditState createState()
      => LogSheetPageEditState(id: id, projectTitle: projectTitle);
}

class LogSheetPageEditState extends State<LogSheetPageEdit> {

  final int id;
  final String projectTitle;

  LogSheetPageEditState({Key key, this.id, this.projectTitle});

  LogSheet _logSheet;



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



    loadData();
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }



  void loadData() async {

    _logSheet = await ServicesAPI.getLogSheetById(id);


    setState(() {
      timeSpentController.text = _logSheet.timeSpent;
      workController.text = _logSheet.work;
      problemsController.text = _logSheet.problems;
      commentsController.text = _logSheet.comments;
      nextWorkPlannedController.text = _logSheet.nextWorkPlanned;
    });



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

                  if (title=='Error') {

                    Navigator.pop(context);

                  } else {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          LogSheetDetails(id: id,projectTitle: projectTitle,)),);
                  }



                },
              ),
            ],
          );
        },
      );
    }

    void updateLogSheet() {

      setState(() {

        ServicesAPI.updateLogSheet(id, timeSpentController.text,
            workController.text, problemsController.text, commentsController.text,
            nextWorkPlannedController.text).then((value) {

          if(value !=0) {
            _showAlertDialog('Info', 'Log sheet #' + id.toString() +  ' has been updated successfully!');
          } else {
            _showAlertDialog('Error', 'Could not update the log sheet, '
                'please try again.');

          }


        });
      });

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Log Sheet Update'),
            Text('Log sheet no. ' + id.toString(), style: TextStyle(
              fontSize: 14.0,
            ),),
          ],
        ),

        backgroundColor: AppBarBackgroundColor,
        //centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              userHelpText = '';
              bool errors = false;
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;
                updateLogSheet();

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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
      desc: "Log sheet has been updated sucessfully!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogSheetDetails()),);

          },
          width: 120,
        )
      ],
    ).show();

  }
}
