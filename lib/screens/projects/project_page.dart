import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/projects/project_add.dart';
import 'package:ou_mp_app/screens/projects/project_details.dart';
import 'package:ou_mp_app/style.dart';


class ProjectPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects', style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectPageAdd()),);
            },
          ),


        ],
        centerTitle: true,
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
                  Container(
                    height: 200.0,
                    child: _myListView(context) ,
                  ),

                ],
              ),
            ),
          ),

        ],

      ),


    );
  }

}


Widget _myListView(BuildContext context) {

  final titles = ['TM470 Project'];

  final icons = [Icon(Icons.assignment,color: Color(0xff326fb4)),];

  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {

      return Card( //                           <-- Card widget
        child: Container(
          color: Colors.white,
          child: ListTileTheme(

            child: ListTile(
             // isThreeLine: true,
              subtitle: Text('Development\n08/02/2020 - 14/09/2020',
              style: TextStyle(fontSize: 14.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectPDetails()),);
              },
             // leading: icons[index],
              title: Text(titles[index]),
              trailing: Icon(Icons.keyboard_arrow_right)
              ,
            ),
          ),
        ),
      );
    },
  );
}
