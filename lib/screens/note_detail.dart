import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {

  String appBarTitle;

  NoteDetail(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail>{

    String appBarTitle;
    static var _priorities = ['High', 'Low'];
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    NoteDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle =Theme.of(context).textTheme.title;

    // TODO: implement build
    return WillPopScope(

      onWillPop: (){
        //write some code to control things, when user press Back navigation button in device
        moveToLastScreen();
      },

      child: Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(icon: Icon(
          Icons.arrow_back),
        onPressed: () {
//          write some code to control things, when user press button in AppBar
          moveToLastScreen();
        }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem){
                  return DropdownMenuItem<String> (
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,
                value: 'Low',
                onChanged: (valueSelectedByUser){
                  setState(() {
                    debugPrint('User selected $valueSelectedByUser');
                  });
                },
              ),
            ),
            //Second element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value){
                  debugPrint('Something changed in Title Text Field');
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),

            //third element

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value){
                  debugPrint('Something changed in Description Text Field');
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            //fourth element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                          'Save',
                      textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint('Save Button Clicked;');
                        });
                      },
                    ),
                  ),
                  //second element of the row
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint('Delete Button Clicked');
                        });
                      },
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      )
    ));
  }

  void moveToLastScreen(){
    Navigator.pop(context);
  }

}