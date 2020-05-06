import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_details.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LogSheetPageEdit extends StatefulWidget {
  LogSheetPageEditState createState() => LogSheetPageEditState();
}

class LogSheetPageEditState extends State<LogSheetPageEdit> {
  String _projectTitle = 'TM470 Project';
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

    timeSpentController.text = '1.5 hours';
    workController.text = 'Finished off the last bits and pieces for the TMA. Reread the guide on structuring, styling and editing reports to see if I had covered everything. Rechecked TMA material to make sure that I’d included everything I was asked for. Carried out spell check. Print out – sort out – that’s it. TMA finished.';
    problemsController.text = 'Found it difficult to organise my TMA in what would seem a logical manner for reading. Great difficulty in writing about how I tackled the TMA. Must continue to go over the sections on effective report writing.';
    commentsController.text = 'Great relief in getting to this point. Finally I have a project skeleton. But shouldn’t wait for the verdict before pressing on!';
    nextWorkPlannedController.text = 'Final check of TMA. Finished on time but still apprehensive about the work I have to do.';

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



    void createLogSheet() {

      displaySuccessAlert();

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
            Text(_projectTitle, style: TextStyle(
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
