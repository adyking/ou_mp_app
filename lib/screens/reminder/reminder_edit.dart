import 'package:flutter/material.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/reminder.dart';
import 'package:ou_mp_app/screens/reminder/reminder_page.dart';

import '../../style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import 'package:ou_mp_app/utils/services_api.dart';
class ReminderPageEdit extends StatefulWidget {
  final int id;
  final Project project;


  ReminderPageEdit({Key key, this.id, this.project}) : super(key:key);

  @override
  _ReminderPageEditState createState() => _ReminderPageEditState(id: id, project: project);
}

class _ReminderPageEditState extends State<ReminderPageEdit> {

  final int id;
  final Project project;
  DateTime sCutOffDate;

  String userHelpText;

  //Reminder _reminder;
  bool _loaded =false;


  Map<String, bool> chkValues = {
    '1 day before': false,
    '1 week before': false,
    '2 weeks before': false
  };


  final reminderTextController = TextEditingController();
  final cutOffDateController = TextEditingController();


  _ReminderPageEditState({Key key, this.id,this.project});



  @override
  void initState() {
   // loadData();
    ServicesAPI.getReminderById(id).then((reminderValue) {

      setState(() {
        reminderTextController.text = reminderValue.reminderText;

        sCutOffDate = reminderValue.cutOffDate;

        chkValues.forEach((key, value) {
          switch(key) {
            case '1 day before': {
              if(reminderValue.alertDate1!=DateTime.parse('1900-01-01')){
                chkValues[key] = true;
              }
            }
            break;

            case '1 week before': {
              if(reminderValue.alertDate2!=DateTime.parse('1900-01-01')){
                chkValues[key] = true;
              }
            }
            break;

            case '2 weeks before': {
              if(reminderValue.alertDate3!=DateTime.parse('1900-01-01')){
                chkValues[key] = true;
              }
            }
            break;

            default: {
              //statements;
            }
            break;
          }

          _loaded = true;
        });
      });

    });

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


//  void loadData() async {
//
//    _reminder = await ServicesAPI.getReminderById(id);
//
//
//    setState(() {
//
//      reminderTextController.text = _reminder.reminderText;
//      sCutOffDate = _reminder.cutOffDate;
//
//
//      chkValues.forEach((key, value) {
//        switch(key) {
//          case '1 day before': {
//            if(_reminder.alertDate1!=DateTime.parse('1900-01-01')){
//              chkValues[key] = true;
//            }
//          }
//          break;
//
//          case '1 week before': {
//            if(_reminder.alertDate2!=DateTime.parse('1900-01-01')){
//              chkValues[key] = true;
//            }
//          }
//          break;
//
//          case '2 weeks before': {
//            if(_reminder.alertDate3!=DateTime.parse('1900-01-01')){
//              chkValues[key] = true;
//            }
//          }
//          break;
//
//          default: {
//            //statements;
//          }
//          break;
//        }
//
//
//      });
//
//    });
//
//
//
//  }


  @override
  Widget build(BuildContext context) {


    final reminderTextField = TextFormField(
      controller: reminderTextController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Reminder Edit*',
      ),
    );

    final makeStartDate = FormBuilderDateTimePicker(
      onChanged: (value){
        sCutOffDate = value;
      },
      controller: cutOffDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: sCutOffDate,
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Cut-off date*"),
    );


    ListView remindersList() {

      return ListView(
        children: chkValues.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: chkValues[key],

            onChanged: (bool value) {
              setState(() {
                chkValues[key] = value;
              });
            },
          );
        }).toList(),
      );
    }

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


    bool checkFields() {
      bool errors = false;
      setState(() {
        if (reminderTextController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Reminder name field is required.';
        }

        if (cutOffDateController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Cut-off date field is required.';
        }




      });
      return errors;
    }

    Future<void> _showAlertConfirmDialog(String title, String msg) async {
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
                child: Text('YES'),
                onPressed: () {
                  //  setState(() {

                  Navigator.pop(context);
                  ServicesAPI.deleteReminder(id).then((value) {

                    if(value==1){
                      var msg = 'Reminder has been deleted successfully!';
                      _showAlertDialog('Info', msg);
                    } else {
                      var msg = 'Could not delete reminder, please try again.';
                      _showAlertDialog('Error', msg);
                    }

                  });
                  // });
                },
              ),

              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }


    return Scaffold(
      appBar:AppBar(
        title: Column(
          children: <Widget>[
            Text(
              project.name,
              style: AppBarTheme.of(context).textTheme.title,
            ),
            Text('Reminder Edit',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              userHelpText = '';
              bool errors = false;
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;
                updateReminder();

              }

            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {

                var msg = 'Are you sure you want to delete this reminder?';
                _showAlertConfirmDialog('Confirm', msg);
                // showAlertConfirmDialog(context, _project.name);


              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child:  Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Visibility(
                        visible: _loaded == true ? true : false,
                        child: Column(

                          children: <Widget>[
                            reminderTextField,
                            makeStartDate,
                            SizedBox(height: 20,),
                            Align(
                                alignment: Alignment.centerLeft,

                                child: Text('Alert options:', style: TextStyle(fontWeight: FontWeight.w600),)),


                            Container(
                              height: 180,

                              child: remindersList(),

                            ),

                            // remindersList(),

                          ],
                        ),
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

        ],

      ),

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
                        ReminderPage(project: project,)),);
                }




              },
            ),
          ],
        );
      },
    );
  }

  void updateReminder() async {
    // var formatter = DateFormat('yyyy-MM-dd');
    // var formattedDate = formatter.format(sCutOffDate);
    DateTime oneDayBeforeDate = DateTime.parse('1900-01-01');
    DateTime oneWeekBeforeDate = DateTime.parse('1900-01-01');
    DateTime twoWeeksBeforeDate = DateTime.parse('1900-01-01');


    chkValues.forEach((key, value) {
      switch(key) {
        case '1 day before': {
          if(value){
            oneDayBeforeDate = sCutOffDate.subtract(new Duration(days: 1));
          }
        }
        break;

        case '1 week before': {
          if(value){
            oneWeekBeforeDate = sCutOffDate.subtract(new Duration(days: 7));
          }
        }
        break;

        case '2 weeks before': {
          if(value){
            twoWeeksBeforeDate = sCutOffDate.subtract(new Duration(days: 14));
          }
        }
        break;

        default: {
          //statements;
        }
        break;
      }



    });


    setState(() {

      ServicesAPI.updateReminder(id, reminderTextController.text,
          sCutOffDate, oneDayBeforeDate, oneWeekBeforeDate, twoWeeksBeforeDate).then((value) {

        if(value !=0) {
          _showAlertDialog('Info', 'Reminder has been updated successfully!');
        } else {
          _showAlertDialog('Error', 'Could not update reminder, '
              'please try again.');

        }


      });
    });




  }
}
