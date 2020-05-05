import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubTaskPageEdit extends StatefulWidget {
  SubTaskPageEditState createState() => SubTaskPageEditState();
}

class SubTaskPageEditState extends State<SubTaskPageEdit> {
  String appBarTitle = 'Edit Subtask';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;
  String sPriority;
  DateTime sStartDate;
  DateTime sEndDate;

  final subtaskNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final estimatedTimeController = TextEditingController();
  final durationController = TextEditingController();
  final priorityController = TextEditingController();


  bool isTaskNameEmpty = false;



  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    txtFieldFocus.addListener(_setColorFocus);
    txtFieldFocusDesc.addListener(_setColorFocus);
    subtaskNameController.text = 'Choose topic.';
    appBarTitle = 'Choose topic.';

    durationController.text = '1 day';
    estimatedTimeController.text = '2.0';
    sPriority = 'Medium';
    sStartDate = new DateFormat("dd-MM-yyyy").parse('09-02-2020');
    sEndDate = new DateFormat("dd-MM-yyyy").parse('09-02-2020');


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
        appBarTitle = 'Edit Subtask';
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
      controller: subtaskNameController,
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
        labelText: 'Subtask name*',
      ),
    );


    void estimatedTimeValidator(String value) {
      setState(() {
        final n = double.tryParse(value);
        if (n == null) {
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
                  color: Colors.red,
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
      initialValue: sStartDate,
      format: DateFormat("dd-MM-yyyy"),
      decoration: InputDecoration(labelText: "Start date*"),
    );

    final makeEndDate = FormBuilderDateTimePicker(
      controller: endDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: sEndDate,
      format: DateFormat("dd-MM-yyyy"),
      decoration: InputDecoration(labelText: "End date*"),
    );

    final makeDDPriority = FormBuilderDropdown(
      onChanged: (value) {
        sPriority = value;
      },
      attribute: "priority",
      decoration: InputDecoration(labelText: "Priority"),
      initialValue: sPriority,
      hint: Text('Select priority'),
      validators: [FormBuilderValidators.required()],
      items: ['Low', 'Medium', 'High']
          .map((p) => DropdownMenuItem(
                value: p,
                child: Text("$p"),
              ))
          .toList(),
    );

    void editSubtask() {
      displaySuccessAlert();
    }

    bool checkFields() {
      bool errors = false;
      setState(() {
        if (subtaskNameController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Subtask name field is required.';
        }

        if (startDateController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Start date field is required.';
        }

        if (endDateController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'End date field is required.';
        }

        if (estimatedTimeController.text == '' ||
            estimatedTimeController.text == '0.0') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
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
            if (userHelpText != '') {
              userHelpText = userHelpText + '\n\n';
            }
            userHelpText =
                userHelpText + 'End date cannot be before start date.';
          } else {
            if (diffDays == 1) {
              durationController.text = diffDays.toString() + ' day';
            } else {
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
              print(sPriority);
              bool errors = false;
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;
                editSubtask();
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
      title: "Sucess",
      desc: "Subtask has been edited sucessfully!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskDetails()),
            );
          },
          width: 120,
        )
      ],
    ).show();
  }
}
