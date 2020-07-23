import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:ou_mp_app/utils/services_api.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final feedbackTextController = TextEditingController();
  String userHelpText;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final makeFeedbackField = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: feedbackTextController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultThemeColor),
        ),

        labelText: 'Your feedback*',
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




    bool checkFields() {
      bool errors = false;
      setState(() {
        if (feedbackTextController.text == '') {
          //txtFieldFocus.requestFocus();
          errors = true;
          userHelpText = userHelpText + 'Feedback field is required.';
        }



      });
      return errors;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback',
          style: AppBarTheme.of(context).textTheme.title,
        ),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {

              userHelpText = '';
              bool errors = false;
              errors = checkFields();

              if (errors == false) {
                userHelpText = null;

                sendFeedback();

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
                            makeFeedbackField,
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
                Navigator.pop(context);
                feedbackTextController.text = '';


              },
            ),
          ],
        );
      },
    );
  }

  void sendFeedback() async {
    int resp = await ServicesAPI.sendEmailFeedback(feedbackTextController.text.replaceAll('\n', '<br/>'));

    if(resp==1) {
      _showAlertDialog('Info', 'Thank you for your feedback.\n\nYour feedback has been sent successfully!');
    } else {
      _showAlertDialog('Error', 'Your feedback could not '
          'be sent, please try again.');
    }

  }
}
