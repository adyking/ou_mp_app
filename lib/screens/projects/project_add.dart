import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';




class ProjectPageAdd extends StatefulWidget{

  ProjectPageAddState  createState() => ProjectPageAddState();
}

class ProjectPageAddState extends State<ProjectPageAdd> {

  String appBarTitle = 'New Project';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();

  final projectNameController = TextEditingController();


  bool isProjectNameEmpty = false;




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




    final makeStartDate = FormBuilderDateTimePicker(

      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Start date"),
    );

    final makeEndDate = FormBuilderDateTimePicker(

      attribute: "date",
      inputType: InputType.date,
      initialValue: DateTime.now(),
      format: DateFormat("dd-MM-yyyy"),

      decoration: InputDecoration(labelText: "Completion date"),
    );


    void createProject () {


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

    return Scaffold(

      appBar: AppBar(

        title: Text(appBarTitle, style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (projectNameController.text == ''){
                txtFieldFocus.requestFocus();
              } else {
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
                padding: const EdgeInsets.all(10.0),
                child: Container(
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


                        SizedBox(height: 30.0,),
                        Row(
                            children: <Widget>[
                              Text('* required field')
                            ],
                        )


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],

      ),
    );
  }

}