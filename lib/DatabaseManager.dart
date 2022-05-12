import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:todo_list/Task.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  Future<Database> get database async {
    // Returns the database if it exists
    if(_database != null) return _database!;

    // If it doesn't exist, creates it
    _database = await _initDB("tasks.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  
  Future _createDB(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final taskType = "TEXT NOT NULL";
    final isCompletedType = "BOOLEAN NOT NULL";

    await db.execute('''CREATE TABLE $tableNotes (${TaskFields.id} $idType, ${TaskFields.task} $taskType, ${TaskFields.isCompleted} $isCompletedTYpe)''');
  } 

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    
    final id = await db.insert(tableNotes, task.toJson());
  }

  DatabaseManager._init();
}