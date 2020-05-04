import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TaskPageAdd extends StatefulWidget {
  TaskPageAddState createState() => TaskPageAddState();
}

class TaskPageAddState extends State<TaskPageAdd> {
  String appBarTitle = 'New Task';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;

  final taskNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final estimatedTimeController = TextEditingController();
  final durationController = TextEditingController();

  bool isTaskNameEmpty = false;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    txtFieldFocus.addListener(_setColorFocus);
    txtFieldFocusDesc.addListener(_setColorFocus);
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

      });

    }


    final makeEstimatedTimeField = TextFormField(
      controller: estimatedTimeController,
      keyboardType: TextInputType.number,
      onChanged: estimatedTimeValidator,
      //onFieldSubmitted: estimatedTimeValidator,
      decoration: InputDecoration(
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



    final makeUserhelp = Column(
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
      controller: startDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),
      decoration: InputDecoration(labelText: "Start date*"),
    );

    final makeEndDate = FormBuilderDateTimePicker(
      controller: endDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),
      decoration: InputDecoration(labelText: "End date*"),
    );

    void createTask() {

      diplaySuccessAlert();

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
                      child: makeUserhelp,
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

  void diplaySuccessAlert() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Sucess",
      desc: "New task has been created sucessfully!",
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
