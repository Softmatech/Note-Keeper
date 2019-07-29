import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';

import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';


class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  NoteDetail(this.note,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail>{

  DatabaseHelper helper = new DatabaseHelper();

    String appBarTitle;
    Note note;

    static var _priorities = ['High', 'Low'];
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    NoteDetailState(this.note,this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle =Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

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
                value: getPriorityAsString(note.priority),
                onChanged: (valueSelectedByUser){
                  setState(() {
                    debugPrint('User selected $valueSelectedByUser');
                    updatePriorityAsInt(valueSelectedByUser);
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
                  updateTitle();
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
                  updateDescription();
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
                          _save();
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
                          _delete();
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
    Navigator.pop(context, true);
  }

  //Convert the string Priority in the form of integer before saving it into database
  void updatePriorityAsInt(String value) {
    switch(value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //Convert int priority to string priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch(value) {
      case 1:
        priority = _priorities[0];  //High
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  // Update the title of the Note object
  void updateTitle()  {
    note.title = titleController.text;
  }

  // Update the description of the note object
  void updateDescription(){
    note.description = descriptionController.text;
  }

  //Delete operation
  void _delete()async {

    moveToLastScreen();

    if(note.id == null) {
      _showAlertDialog('Status', 'No Note was Deleted');
      return;
    }

    int result = await helper.deleteNote(note.id);
    if(result != 0) {
      _showAlertDialog('Satus', 'Note Deleted Successfully');
    }else{
      _showAlertDialog('Status', 'Error Occured while Deleting note');
    }
  }

  // Save data to database
  void _save() async  {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if(result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else  {
      _showAlertDialog('Status','Problem Saving note');
    }
  }

  void _showAlertDialog (String title, String message)  {

      AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
      );

      showDialog(
        context: context,
        builder: (_) => alertDialog
      );
  }

}