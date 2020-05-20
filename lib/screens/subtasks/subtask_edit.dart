import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ou_mp_app/utils/services_api.dart';

class SubTaskPageEdit extends StatefulWidget {
  final int id;

  SubTaskPageEdit({Key key, this.id}) : super(key:key);

  SubTaskPageEditState createState() => SubTaskPageEditState(id: id);
}

class SubTaskPageEditState extends State<SubTaskPageEdit> {
  final int id;
  SubTaskPageEditState({Key key, this.id});

  String appBarTitle = 'Edit Subtask';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;
  String sPriority;
  DateTime sStartDate;
  DateTime sEndDate;
  double sEstimatedTime;
  bool _loaded = false;
  int _taskId = 0;
  double pvEstimatedTime;

  final subtaskNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final estimatedTimeController = TextEditingController();
  final durationController = TextEditingController();
  final priorityController = TextEditingController();


  bool isTaskNameEmpty = false;



  @override
  void initState() {


    ServicesAPI.getSubtaskById(id).then((value) {
      setState(() {


        subtaskNameController.text = value.name;
        appBarTitle = value.name;

        durationController.text = value.duration;
        estimatedTimeController.text = value.allocatedHours.toString();
        pvEstimatedTime = value.allocatedHours;
        sPriority = value.priority;
        sStartDate = value.startDate;
        sEndDate = value.endDate;
        sPriority = value.priority;
        _taskId = value.taskId;
        _loaded = true;



      });

    });

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
                        TaskDetails(id: id,)),);

                },
              ),
            ],
          );
        },
      );
    }
    void editSubtask() {


      ServicesAPI.updateTask(id, subtaskNameController.text, sStartDate,
          sEndDate, durationController.text, sPriority, sEstimatedTime).then((value) {

        if(value !=0) {

          if (pvEstimatedTime != sEstimatedTime){
            // Update allocated hours for the main task
            ServicesAPI.getSubtasksByTaskId(_taskId).then((value) {
              double countTime = 0.0;
              for(var i=0; i < value.length; i++){

                countTime = countTime + value[i].allocatedHours;

              }

              ServicesAPI.updateTaskEstimatedTime(_taskId, countTime).then((value) {
                if (value != 0) {
                  _showAlertDialog(
                      'Info', 'Subtask has been updated successfully!');
                }
              });

            });

          } else {
            _showAlertDialog(
                'Info', 'Subtask has been updated successfully!');
          }




        } else {
          _showAlertDialog('Error', 'Could not update the subtask, please try again.');

        }


      });

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
