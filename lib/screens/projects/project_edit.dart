import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:ou_mp_app/utils/services_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';




class ProjectPageEdit extends StatefulWidget{
  final int projectId;


  ProjectPageEdit({Key key, this.projectId}) : super(key :key);

  ProjectPageEditState  createState() =>
      ProjectPageEditState(projectId :projectId);
}

class ProjectPageEditState extends State<ProjectPageEdit> {

  final int projectId;


  ProjectPageEditState({Key key, this.projectId});

  String appBarTitle = 'Edit Project';
  String sCategory;
  DateTime sStartDate;
  DateTime sEndDate;
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;
  bool _loaded =false;


  final projectNameController = TextEditingController();
  final projectDescController = TextEditingController();
  final projectStartDateController = TextEditingController();
  final projectEndDateController = TextEditingController();

  bool isProjectNameEmpty = false;




  @override
  void initState() {



    ServicesAPI.getProjectById(projectId).then((value) {

      setState(() {
        projectNameController.text = value.name;
        sCategory = value.category;
        projectDescController.text = value.description;
        sStartDate = value.startDate;
        sEndDate = value.endDate;
        _loaded = true;
      });

    });



    super.initState();

    // Start listening to changes.
    txtFieldFocus.addListener(_setColorFocus);
    txtFieldFocusDesc.addListener(_setColorFocus);



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
        appBarTitle = 'Edit Project';
        isProjectNameEmpty = true;
      } else {
        appBarTitle = title;
        isProjectNameEmpty = false;
      }

    });
  }


  @override
  Widget build(BuildContext context) {


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
      initialValue: sCategory,
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
        setState(() {
          sStartDate = value;

        });

      },
      controller: projectStartDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: sStartDate,
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Start date*"),
    );

    final makeEndDate = FormBuilderDateTimePicker(
      onChanged: (value){
        setState(() {
          sEndDate = value;

        });

      },
      controller: projectEndDateController,
      attribute: "date",
      inputType: InputType.date,
      initialValue: sEndDate,
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Completion date*"),
    );

    bool checkFields() {
      bool errors = false;
      setState(() {
        if (projectNameController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Project name field is required.';
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


    void editProject () {

      setState(() {

        ServicesAPI.updateProject(projectId, projectNameController.text,
            projectDescController.text, sCategory, sStartDate,
            sEndDate).then((value) {

          if(value !=0) {
            _showAlertDialog('Info', 'Project hs been updated successfully!');
          } else {
            _showAlertDialog('Error', 'Could not update the project details, '
                'please try again.');

          }


        });
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
                editProject();
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

                            Visibility(
                              visible: _loaded == true ? true : false,
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
      desc: "Project has been updated successfully!",
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