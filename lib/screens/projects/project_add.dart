import 'package:flutter/material.dart';
import 'package:ou_mp_app/main_screen.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/screens/projects/project_page.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:ou_mp_app/utils/services_api.dart';




class ProjectPageAdd extends StatefulWidget{
  final studentId;

  ProjectPageAdd({Key key, this.studentId}) : super(key :key);

  ProjectPageAddState  createState() => ProjectPageAddState(studentId: studentId);
}

class ProjectPageAddState extends State<ProjectPageAdd> {

  ProjectPageAddState({Key key, this.studentId});

  final studentId;
  String appBarTitle = 'New Project';
  String sCategory;
  DateTime sStartDate;
  DateTime sEndDate;
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;


  final projectNameController = TextEditingController();
  final projectDescController = TextEditingController();
  final projectStartDateController = TextEditingController();
  final projectEndDateController = TextEditingController();

  bool isProjectNameEmpty = false;




  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    txtFieldFocus.addListener(_setColorFocus);
    txtFieldFocusDesc.addListener(_setColorFocus);
    sCategory = 'Research';
    sStartDate = DateTime.now();
    sEndDate = DateTime.now();
    //print(studentId);

  }

  @override
  void dispose() {

    txtFieldFocus.dispose();
    super.dispose();
  }

  Color _setColorFocus() {
    Color c ;
    setState(() {
      if(txtFieldFocus.hasFocus){
        c =  DefaultThemeColor ;
      } else {
        c = Colors.grey;
      }
    });
    return c;
  }

  Color _setColorFocusDesc() {
    Color c ;
    setState(() {
      if(txtFieldFocusDesc.hasFocus){
        c =  DefaultThemeColor ;
      } else {
        c = Colors.grey;
      }
    });
    return c;
  }

  void changeTitle(String title){
    setState(() {
      if (title == ''){
        appBarTitle = 'New Project';
        isProjectNameEmpty = true;
      } else {
        appBarTitle = title;
        isProjectNameEmpty = false;
      }

    });
  }


  @override
  Widget build(BuildContext context) {

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
                        MainScreen(tabIndex: 1, studentId: studentId,)),);

                },
              ),
            ],
          );
        },
      );
    }

    final makeProjectField = TextField(
      controller: projectNameController,
      focusNode: txtFieldFocus,
      onChanged: (String str){
        changeTitle(str);
      },
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        errorText: isProjectNameEmpty == true ? 'required field' :
        null,
        //icon: Icon(Icons.edit),
        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'Project name*',
      ),
    );


    final makeDDType = FormBuilderDropdown(
      onChanged: (value) {
        sCategory = value;
      },
      attribute: "category",
      decoration: InputDecoration(labelText: "Category"

      ),
      initialValue: 'Research',
      hint: Text('Select category'),
      validators: [FormBuilderValidators.required()],
      items: ['Research', 'Development', 'Evaluation','Other']
          .map((category) => DropdownMenuItem(
          value: category,
          child: Text("$category")
      )).toList(),
    );

    final makeProjectDescription = TextField(
      focusNode: txtFieldFocusDesc,
      controller: projectDescController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelStyle: TextStyle(
          color: _setColorFocusDesc(),
        ),
        labelText: 'Description',
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
      onChanged: (value){
        sStartDate = value;
      },
      controller: projectStartDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Start date*"),
    );

    final makeEndDate = FormBuilderDateTimePicker(
      onChanged: (value){
        sEndDate = value;
      },
      controller: projectEndDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Completion date*"),
    );

    bool checkFields() {
      bool errors = false;
      setState(() {
        if (projectNameController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Projrect name field is required.';
        }

        if (projectStartDateController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'Start date field is required.';
        }

        if (projectEndDateController.text == '') {
          errors = true;
          if (userHelpText != '') {
            userHelpText = userHelpText + '\n\n';
          }
          userHelpText = userHelpText + 'End date field is required.';
        }



        if (projectStartDateController.text != '' && projectEndDateController.text != '') {
          DateTime str =
          new DateFormat("dd-MM-yyyy").parse(projectStartDateController.text);
          DateTime end =
          new DateFormat("dd-MM-yyyy").parse(projectEndDateController.text);

          int diffDays = end.difference(str).inDays;

          if (diffDays < 0) {
            errors = true;
            if (userHelpText != '') {
              userHelpText = userHelpText + '\n\n';
            }
            userHelpText =
                userHelpText + 'End date cannot be before start date.';
          }
        }
      });
      return errors;
    }


    void createProject () {


      ServicesAPI.addProject(studentId, projectNameController.text,
          projectDescController.text, sCategory, sStartDate,
          sEndDate).then((value) {

        if(value !=0) {
          _showAlertDialog('Info', 'A new project has been created successfully!');
        }


      });





    }



    return Scaffold(

      appBar: AppBar(

        title: Text(appBarTitle, style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              userHelpText = '';
              //print(sCategory);
              bool errors = false;
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;
                createProject();
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
                            makeProjectField,
                            makeProjectDescription,
                            makeDDType,
                            makeStartDate,
                            makeEndDate,
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
      desc: "New project has been created sucessfully!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();

  }

}