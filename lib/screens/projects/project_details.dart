import 'package:flutter/material.dart';
import 'package:ou_mp_app/style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class ProjectPDetails extends StatelessWidget {

  @override
  Widget build(BuildContext context) {



    final makeProjectDetail = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:  CrossAxisAlignment.stretch,

          children: <Widget>[

            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 5.0,
              percent: 0.25,
              center: new Text("25%"),
              progressColor: DefaultThemeColor,
            ),
            SizedBox(height: 20.0,),
            Column(
              children: <Widget>[
                TextField(
                 enabled: false,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: DefaultThemeColor),
                    ),
                    //icon: Icon(Icons.edit),
                    labelStyle: TextStyle(
                    ),
                    labelText: 'Project name',
                  ),
                )
              ],
             ),
        /*    Row(
              children: <Widget>[
                Text('Project name:'),
                SizedBox(width: 10.0,),
                Text('TM470 Project')

              ],
            ),
            Row(

              children: <Widget>[


                Text('Description:'),
                SizedBox(width: 24.0,),
                Wrap(

                  crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text('OU Project Management App xxxxxxxxxxxxxxxxxxxxxxx')
                    ],

                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('Category:'),
                SizedBox(width: 44.0,),
                Text('Development')
              ],
            ),
*/


            Text('08/02/2020 - 14/09/2020'),
          ],


        ),
      ),

    );





    return Scaffold(
      appBar: AppBar(
        title: Text('TM470 Project', style: AppBarTheme.of(context).textTheme.title,),
        backgroundColor: AppBarBackgroundColor,
        centerTitle: true,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
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
              child: Column(
                children: <Widget>[

                  makeProjectDetail,

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
              onTap: () => print('sdsd'),
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
