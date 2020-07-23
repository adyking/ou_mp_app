import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/terms/terms_details.dart';
import 'package:ou_mp_app/style.dart';

class TermsPage extends StatelessWidget {

  final String termsAndC = 'Please read these Terms and Conditions ("Terms", "Terms and Conditions") carefully before using the OU Project Management App operated by Adilson Jacinto ("us", "we", or "our").'
      '\n\nYour access to and use of this project management tool is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the app.'
      '\n\n\nBy accessing or using the app you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the OU Project Management App.'
      '\n\n\nTermination: We may terminate or suspend access to our OU Project Management immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.'
      '\n\n\nAll provisions of the Terms which bby their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.';


  final String privacyPolicy = 'My Company (JTeki) ("us","we", or "our") operates OU Project Management too (the "app"). This page informs you of our policies regarding the collection, use and disclosure of Personal Information we receive from users of the App.'
      '\n\nWe use your Personal Information only for storing your data on a database and can only be accessed by yourself using your credentials. By using this app, you agree to the collection and use of information in accordance with this policy.'
      '\n\n\nInformation Collection And Use: While using ou App, we may ask you to provide us with certain personally identifiable information that can be used to contact you or identify you. Personally identifiable information may include, but is not limited to your name ("Personal Information").'
      '\n\n\nStoring Data: Like many app operators, we only store information that you want us to store when you use our App ("Storing Data").'
      '\n\nThis data may include your projects and their tasks and subtasks, as well as logsheets and  reminders. This data can be easily removed by yourself by deleting the information stored for your account.';

  final String dataProtection = 'JTeki is registered under the data protection act with the Information Commissioner\'s Office (ICO) under registration: XXXXX'
      '\n\nScope: JTeki retains only the information provided by the users. To be compliant with GDPR, information collected lawfully and used fairly, stored safely and not disclosed to any other person unlawfully. To do this, the organisation complies with the Data Protection Principles, which are set out in the Data Protection Act 2018.'
      '\n\n\nJTeki, as far as reasonably practicable, complies with the Data Protection Principles contained in the Data Protection Act to ensure all data is:'
      '\n\n- Fairly and lawfully processed\n- Processed for lawful purpose\n- Adequate, relevant and not excessive\n- Accurate and up to date\n- Held for no longer than is absolutely necessary\n- Processed in accordance with the rights of the data subject\n- Protected in the appropriate way\n- Not transferred to any other countries without adequate protection and consent'
      '\n\n\nSensitive personal Data: JTeki ensures there is stronger legal protection for more sensitive information such as:'
      '\n\n- Ethnic background\n- Political opinions\n- Religious beliefs\n- Health\n- Sexual Health\n- Gender\n- Criminal records'
      '\n\n\nResponsibilities: JTeki have responsibility for ensuring data is collected, stored and handled in a safe secure and appropriate manner.'
      '\n\n\nData Storage: Data stored electronically must be protected from unauthorised access, accidental deletion and malicious hacking attempts. We are committed to protecting all Personal Data we collect and use. To that end, we take all reasonable precautions to prevent the loss, misuse or alteration of your Personal Data held within pur data repositories.'
      '\nYou are responsible for keeping your password confidential. We will not ask you for your password and please ensure any password you use is unique to our app. Questions about the storage data can be found directed to the Data Governance Team.';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Terms of Service'),
        centerTitle: true,
        backgroundColor: AppBarBackgroundColor,


      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Container(
                    child: ListTileTheme(
                      child: ListTile(
                        // isThreeLine: true,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Container(
                            height: 200,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('$termsAndC',),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                              TermsDetails(title: 'Terms & Conditions',txt: termsAndC,)),);

                        },

                        title:  Text('Terms & Conditions',

                          style: TextStyle(fontSize: 18.0),
                        ),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Container(
                    child: ListTileTheme(
                      child: ListTile(
                        // isThreeLine: true,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Container(
                              height: 200,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('$privacyPolicy',),
                              )),
                        ),
                        onTap: () {

                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                              TermsDetails(title: 'Privacy Policy',txt: privacyPolicy,)),);

                        },

                        title:  Text('Privacy Policy',

                          style: TextStyle(fontSize: 18.0),
                        ),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Container(
                    child: ListTileTheme(
                      child: ListTile(
                        // isThreeLine: true,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Container(
                              height: 200,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('$dataProtection',),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                              TermsDetails(title: 'Data Protection',txt: dataProtection,)),);

                        },

                        title:  Text('Data Protection',

                          style: TextStyle(fontSize: 18.0),
                        ),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),


                ],
              ),
            ),
          ),

        ],

      ),

    );
  }
}
