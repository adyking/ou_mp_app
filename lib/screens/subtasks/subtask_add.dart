import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ou_mp_app/models/subtask.dart';
import 'package:ou_mp_app/screens/tasks/task_details.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:ou_mp_app/models/task.dart';

class SubTaskPageAdd extends StatefulWidget {
  final int taskId;

  SubTaskPageAdd({Key key, this.taskId}) : super(key:key);
  SubTaskPageAddState createState() => SubTaskPageAddState(taskId:taskId);
}

class SubTaskPageAddState extends State<SubTaskPageAdd> {
  final int taskId;
  Task _task;

  SubTaskPageAddState({Key key, this.taskId});
  String appBarTitle = 'New Subtask';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;
  String sPriority;
  DateTime sStartDate;
  DateTime sEndDate;
  double sEstimatedTime;


  final subtaskNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final estimatedTimeController = TextEditingController();
  final durationController = TextEditingController();

  bool isTaskNameEmpty = false;

  @override
  void initState() {

    ServicesAPI.getTaskById(taskId).then((value) {

      setState(() {
        _task = value;
      });

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
        appBarTitle = 'New Subtask';
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
                        TaskDetails(id: taskId,)),);

                },
              ),
            ],
          );
        },
      );
    }

    void createSubtask() async {

      int lastId = await  ServicesAPI.addSubtask(taskId, subtaskNameController.text, sStartDate,
          sEndDate, durationController.text, sPriority, sEstimatedTime);

      if(lastId !=0) {

        // Update allocated hours for the main task
        List<Subtask> _subtasksList = List<Subtask>();
        _subtasksList = await ServicesAPI.getSubtasksByTaskId(taskId);

        double countTime = 0.0;
        for(var i=0; i < _subtasksList.length; i++){

          countTime = countTime + _subtasksList[i].allocatedHours;

        }

        DateTime today = DateTime.now();
        int status = 0;
        int diffDays = today.difference(_task.endDate).inDays;

        if (diffDays > 0) {
          status = 2;
          ServicesAPI.updateSubtaskStatus(lastId, status);
        }

        int val = await ServicesAPI.updateTaskEstimatedTime(taskId, countTime);

        if (val != 0) {
          _showAlertDialog(
              'Info', 'A new subtask has been created successfully '
              'for the current task!');
        }


      } else {
        _showAlertDialog('Error', 'Could not create a subtask, please try again.');

      }
    }
    String dateFormatted (DateTime dt) {

      var formattedDate =  DateFormat('dd-MM-yyyy').format(dt);

      return formattedDate;

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
          int diffStartDays = str.difference(_task.startDate).inDays;
          int diffStartEndDays = str.difference(_task.endDate).inDays;
          int diffEndDays = end.difference(_task.endDate).inDays;
          int diffEndStartDays = end.difference(_task.startDate).inDays;

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
               dateFormatted(_task.startDate) + ' and ' +
                    dateFormatted(_task.endDate) + ' of the main task.';
          }

          if (errorEnd == 1) {

            errors = true;
            if (userHelpText != ''){
              userHelpText =  userHelpText + '\n\n';
            }
            userHelpText =
                userHelpText + 'End date can only be between ' +
                    dateFormatted(_task.startDate) + ' and ' +
                    dateFormatted(_task.endDate) + ' of the main task.';
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
                createSubtask();

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
      desc: "New subtask has been created sucessfully!",
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
