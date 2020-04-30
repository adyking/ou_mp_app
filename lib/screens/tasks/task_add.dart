import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';





class TaskPageAdd extends StatefulWidget{

  TaskPageAddState  createState() => TaskPageAddState();
}

class TaskPageAddState extends State<TaskPageAdd> {

  String appBarTitle = 'New Task';
  FocusNode txtFieldFocus = new FocusNode();
  FocusNode txtFieldFocusDesc = new FocusNode();
  String userHelpText;


  final taskNameController = TextEditingController();


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
      onChanged: (String str){
        changeTitle(str);
      },
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),
        errorText: isTaskNameEmpty == true ? 'required field' :
        null,
        //icon: Icon(Icons.edit),
        labelStyle: TextStyle(
          color: _setColorFocus(),
        ),
        labelText: 'Task name*',
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

    final makeUserhelp = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Please correct the following error(s):', style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('$userHelpText'),
        ),


      ],
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

      decoration: InputDecoration(labelText: "End date"),
    );


    void createTask () {


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
              if (taskNameController.text == ''){
                txtFieldFocus.requestFocus();
                userHelpText = 'assdsd';
              } else {
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
                            SizedBox(height: 30.0,),
                            Row(
                              children: <Widget>[
                                Text('* required field')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                   makeUserhelp,
                  ],
                ),

              ),
            ),
          ),

        ],

      ),
    );
  }

}