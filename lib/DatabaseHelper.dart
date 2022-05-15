import 'dart:io';

import 'Task.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = "Tasks.db";
  static const int _databaseVersion = 1;

  // Singelton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if(_database != null) return _database;
    await _initDatabase();
    print("Type: ${_database.runtimeType}");
    return _database;
  }

  // Initialises the database
  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _databaseName);

    _database = await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreateDB);
  }

  // Runs when the database is first being created
  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Task.tableName}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Task.colTask} TEXT NOT NULL,
      ${Task.colIsCompleted} INTEGER NOT NULL
    )
    ''');
  }

  // Adds the task to the database
  Future<int> insertTask(Task task) async {
    Database db = await database;
    return db.insert(Task.tableName, task.toMap());
  }

  // Gets the tasks
  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> tasks = await db.query(Task.tableName);

    return tasks.length == 0 ? [] : tasks.map((task) => Task.fromMap(task)).toList();
  }
  
  // Deletes the task
  Future<void> deleteTask(Task task) async {
    Database db = await database;
    db.execute("DELETE FROM ${Task.tableName} WHERE ${Task.colTask} = '${task.taskName}'");
  }

  Future<void> updateTask(Task task) async {
    Database db = await database;
    db.execute("UPDATE ${Task.tableName} SET ${Task.colIsCompleted} = ${task.isCompleted ? 1 : 0} WHERE ${Task.colTask} = '${task.taskName}'");
  }

}