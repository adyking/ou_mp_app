import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ou_mp_app/models/project.dart';

class TaskPageAdd extends StatefulWidget {
  final projectId;

  TaskPageAdd({Key key, this.projectId}) : super(key :key);

  TaskPageAddState createState() => TaskPageAddState(projectId: projectId);
}

class TaskPageAddState extends State<TaskPageAdd> {
  final projectId;

  TaskPageAddState({Key key, this.projectId});

  String appBarTitle = 'New Task';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;
  String sPriority;
  DateTime sStartDate;
  DateTime sEndDate;
  double sEstimatedTime;
  Project _project;


  final taskNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final estimatedTimeController = TextEditingController();
  final durationController = TextEditingController();

  bool isTaskNameEmpty = false;

  @override
  void initState() {

    ServicesAPI.getProjectById(projectId).then((value) {
      _project = value;
    });

    sPriority = 'Low';
    sStartDate = DateTime.now();
    sEndDate = DateTime.now();
    sEstimatedTime = 0.0;
    // Start listening to changes.
    txtFieldFocus.addListener(_setColorFocus);
    txtFieldFocusDesc.addListener(_setColorFocus);
    super.initState();


  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    txtFieldFocus.dispose();
    super.dispose();
  }

  Color _setColorFocus() {
    Color c;
    setState(() {
      if (txtFieldFocus.hasFocus) {
        c = DefaultThemeColor;
      } else {
        c = Colors.grey;
      }
    });
    return c;
  }

  Color _setColorFocusDesc() {
    Color c;
    setState(() {
      if (txtFieldFocusDesc.hasFocus) {
        c = DefaultThemeColor;
      } else {
        c = Colors.grey;
      }
    });
    return c;
  }

  void changeTitle(String title) {
    setState(() {
      if (title == '') {
        appBarTitle = 'New Task';
        isTaskNameEmpty = true;
      } else {
        appBarTitle = title;
        isTaskNameEmpty = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    showAlertNoteDialog(BuildContext context, String msg) {

      // set up the buttons
      Widget okButton = FlatButton(
        child: Text('OK'),
        onPressed:  () {

          Navigator.pop(context);

        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text('Note'),
        content: Text(msg),
        actions: [
          okButton,

        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


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
                          ProjectDetails(projectId: projectId,)),);
                  }



                },
              ),
            ],
          );
        },
      );
    }


    final makeTaskField = TextField(
      controller: taskNameController,
      focusNode: txtFieldFocus,
      onChanged: (String str) {
        changeTitle(str);
      },
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        errorText: isTaskNameEmpty == true ? 'required field' : null,
        //icon: Icon(Icons.edit),
        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'Task name*',
      ),
    );


    void estimatedTimeValidator(String value) {

      setState(() {

        final n = double.tryParse(value);
        if(n == null) {
           estimatedTimeController.text = '0.0';
        }

        sEstimatedTime = double.parse(estimatedTimeController.text);

      });

    }


    final makeEstimatedTimeField = TextFormField(

      controller: estimatedTimeController,
      keyboardType: TextInputType.number,
      onChanged: estimatedTimeValidator,

      //onFieldSubmitted: estimatedTimeValidator,
      decoration: InputDecoration(
        icon: IconButton(
          tooltip: 'Hint',
          color: DefaultThemeColor,
          onPressed: () {
            var msg = 'Estimate time may change automatically if subtasks '
                'are added to this main task, if so this field will then be in read-only mode.';
            showAlertNoteDialog(context, msg);


          },
          icon: Icon(Icons.info
        ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        labelStyle: TextStyle(
          color: _setColorFocusDesc(),
        ),
        labelText: 'Estimate time (hours)*',
      ),
    );

    final makeDurationField = TextField(

      controller: durationController,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        labelStyle: TextStyle(
          color: _setColorFocusDesc(),
        ),
        labelText: 'Duration',
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

    final makeStartDate = FormBuilderDateTimePicker(
      onChanged: (value){
        sStartDate = value;
        setState(() {
          if (sStartDate != null && sEndDate != null) {
            DateTime str = sStartDate;
            //new DateFormat("dd-MM-yyyy").parse(startDateController.text);
            DateTime end = sEndDate;
            //new DateFormat("dd-MM-yyyy").parse(endDateController.text);

            int diffDays = end.difference(str).inDays;

            if (diffDays < 0) {

            } else {
              if (diffDays==1) {
                durationController.text = diffDays.toString() + ' day';
              }else{
                durationController.text = diffDays.toString() + ' days';
              }

            }
          }

        });

      },
      controller: startDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),
      decoration: InputDecoration(labelText: "Start date*"),
    );

    final makeEndDate = FormBuilderDateTimePicker(
      onChanged: (value){
        setState(() {
          sEndDate = value;

          if (sStartDate != null && sEndDate != null) {
            DateTime str = sStartDate;
            //new DateFormat("dd-MM-yyyy").parse(startDateController.text);
            DateTime end = sEndDate;
            //new DateFormat("dd-MM-yyyy").parse(endDateController.text);

            int diffDays = end.difference(str).inDays;

            if (diffDays < 0) {

            } else {
              if (diffDays==1) {
                durationController.text = diffDays.toString() + ' day';
              }else{
                durationController.text = diffDays.toString() + ' days';
              }

            }
          }

        });

      },
      controller: endDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),
      decoration: InputDecoration(labelText: "End date*"),
    );

    final makeDDPriority = FormBuilderDropdown(

      onChanged: (value) {
        setState(() {
          sPriority = value;
        });

      },
      attribute: "priority",
      decoration: InputDecoration(labelText: "Priority"

      ),
      initialValue: 'Low',
      hint: Text('Select priority'),
      validators: [FormBuilderValidators.required()],
      items: ['Low', 'Medium', 'High']
          .map((priority) => DropdownMenuItem(
          value: priority,
          child: Text("$priority")
      )).toList(),
    );



    void createTask() {

      ServicesAPI.addTask(projectId, taskNameController.text, sStartDate,
          sEndDate, durationController.text, sPriority, sEstimatedTime).then((value) {

        if(value !=0) {
          _showAlertDialog('Info', 'A new task has been created successfully!');
        } else {
          _showAlertDialog('Error', 'Could not create a new task, please try again.');

        }


      });

    }

    String dateFormatted (DateTime dt) {

      var formattedDate =  DateFormat('dd-MM-yyyy').format(dt);

      return formattedDate;

    }
    bool checkFields() {
      bool errors = false;
      setState(() {
        if (taskNameController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Task name field is required.';
        }

        if (startDateController.text == '') {
          errors = true;
          if (userHelpText != ''){
            userHelpText =  userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Start date field is required.';
        }

        if (endDateController.text == '') {
          errors = true;
          if (userHelpText != ''){
            userHelpText =  userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'End date field is required.';
        }

        if (estimatedTimeController.text == '' || estimatedTimeController.text == '0.0' ) {
          errors = true;
          if (userHelpText != '' ){
            userHelpText =  userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Estimated time field is required.';
        }

        if (startDateController.text != '' && endDateController.text != '') {
          DateTime str =
              new DateFormat("dd-MM-yyyy").parse(startDateController.text);
          DateTime end =
              new DateFormat("dd-MM-yyyy").parse(endDateController.text);

          int errorStart = 0;
          int errorEnd = 0;
          int diffStartDays = str.difference(_project.startDate).inDays;
          int diffStartEndDays = str.difference(_project.endDate).inDays;
          int diffEndDays = end.difference(_project.endDate).inDays;
          int diffEndStartDays = end.difference(_project.startDate).inDays;

          if (diffStartDays < 0) {
            errorStart = 1;
          }

          if (diffStartEndDays > 0) {
            errorStart = 1;
          }

          if (diffEndDays > 0) {
            errorEnd = 1;
          }

          if (diffEndStartDays < 0) {
            errorEnd = 1;
          }

          if (errorStart == 1) {

            errors = true;
            if (userHelpText != ''){
              userHelpText =  userHelpText + '\n\n';
            }
            userHelpText =
                userHelpText + 'Start date can only be between ' +
                    dateFormatted(_project.startDate) + ' and ' +
                    dateFormatted(_project.endDate) + ' of the main project.';
          }

          if (errorEnd == 1) {

            errors = true;
            if (userHelpText != ''){
              userHelpText =  userHelpText + '\n\n';
            }
            userHelpText =
                userHelpText + 'End date can only be between ' +
                    dateFormatted(_project.startDate) + ' and ' +
                    dateFormatted(_project.endDate) + ' of the main project.';
          }





          int diffDays = end.difference(str).inDays;

          if (diffDays < 0) {
            errors = true;
            if (userHelpText != ''){
              userHelpText =  userHelpText + '\n\n';
            }
            userHelpText =
                userHelpText + 'End date cannot be before start date.';
          } else {
            if (diffDays==1) {
              durationController.text = diffDays.toString() + ' day';
            }else{
              durationController.text = diffDays.toString() + ' days';
            }

          }
        }
      });
      return errors;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
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
                createTask();

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
                            makeTaskField,
                            makeStartDate,
                            makeEndDate,
                            makeDurationField,
                            makeEstimatedTimeField,

                            makeDDPriority,
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
      title: "Success",
      desc: "New task has been created successfully!",
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
