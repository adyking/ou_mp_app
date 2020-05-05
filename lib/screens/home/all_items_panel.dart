import 'package:flutter/material.dart';
import 'package:ou_mp_app/screens/logsheets/logsheet_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ou_mp_app/style.dart';


class AllItemsPanel extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final _pad = 10.0;

    final makeAllItems = Container(
      height: 200,
      decoration:  BoxDecoration(
       // color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        //boxShadow: [
         // setBoxShadow
        //],
      ),
      margin: EdgeInsets.only(
          top: _pad, bottom: _pad, left: _pad, right: _pad),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: _myListView(context),
      ),

    );

    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text('All Items', style: PanelTitleTextStyle,),
        ),

         makeAllItems,


      ],
    );
  }




}

Widget _myListView(BuildContext context) {

  final titles = ['All Tasks', 'Log Sheets', 'Overdue Tasks'];

  final icons = [Icon(Icons.assignment,color: Color(0xff326fb4)),
    Icon(Icons.event_note,color: Color(0xff326fb4)),
    Icon(Icons.assignment_late,color: Color(0xff326fb4))];



  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {

      return Card( //                           <-- Card widget
        child: Container(
          color: Colors.white,
          child: ListTileTheme(
            selectedColor: Colors.red,
            child: ListTile(
            onTap: () {
              switch (index) {
                case 0:
                  {

                  }
                  break;
                case 1:
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogSheetPage()),);
                  }
                  break;
                case 2:
                  {

                  }
                  break;

                default:
                  {

                  }
              }

            },
              leading: icons[index],
              title: Text(titles[index]),
              trailing: index == 2 ?   Text('6+') :
              Icon(Icons.keyboard_arrow_right)
            ,
            ),
          ),
        ),
      );
    },
  );
}

