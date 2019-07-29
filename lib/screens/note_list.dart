import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_detail.dart';

class NoteList extends StatefulWidget {
   @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}


class NoteListState extends State<NoteList> {

  int count = 0 ;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        debugPrint('FAB Clicked');
        navigateToDetail('Add Note');
      },
        tooltip: 'Addnote',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow,
              ),
              title: Text('Dummy Title', style: titleStyle,),
              subtitle: Text('Dummy Date'),
              trailing: Icon(Icons.delete, color: Colors.grey,),

              onTap: () {
                debugPrint('ListTile Tapped');
                navigateToDetail('Edit Note');
              },
            ),
          );
        },
    );
  }

  void navigateToDetail(String title){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(title);
    }));
  }

}