import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper {
    static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
    DatabaseHelper._createInstance();   //Singleton Database
    static Database _database;

    String noteTable = 'note_table';
    String colId = 'id';
    String colTitle = 'title';
    String colDescription = 'description';
    String colPriority = 'priority';
    String colDate = 'date';

    factory DatabaseHelper(){

      _databaseHelper = DatabaseHelper._createInstance();

      return _databaseHelper;
    }

    Future<Database> get database async {

      if(_database == null) {
        _database = await initializeDatabase();
      }
      return _database;
    }

    Future<Database> initializeDatabase() async {
      //Get the directory path for both Android and IOS to store database.
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'notes.db';

      //Open/create the database at a given path
      var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
      return notesDatabase;
    }

    void _createDb(Database db, int newVersion) async{
      await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
    }

    // fetch operation
  getNoteMapList()async {
      Database db = await this.database;

      // var result = await db.rawQuery ('SELECT *FROM $NOTETABL ORDER BY $COLPRIORITY ASC');
    var result = await db.query(noteTable,orderBy: '$colPriority ASC');
    return result;
  }

  //Insert operation
Future<int> insertNote(Note note) async {
      Database db = await this.database;
      var result = await db.insert(noteTable, note.toMap());
      return result;
}

//update operation

Future <int> updateNote(Note note) async {
      var db = await this.database;
      var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
      return result;
}

//Delete operation
Future<int> deleteNote(int id) async {
      var db = await this.database;
      int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
      return result;
}

//get number of note on database
Future<int> getCount() async {
      Database db = await this.database;
      List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
      int result = Sqflite.firstIntValue(x);
      return result;
}

Future<List<Note>> getNoteList() async {
      var noteMapList = await getNoteMapList();// Get 'Map List' from databse
  int count = noteMapList.lenght;

  List<Note> noteList = List<Note>();
  // For llop to create a 'Note List' from a 'Map List'

  for(int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
  }
  return noteList;
}


}