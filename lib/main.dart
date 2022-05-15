import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:todo_list/Task.dart';

import 'package:todo_list/DatabaseHelper.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: ListView(children: [TodoList()],)
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  DatabaseHelper dbHelper;
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController(); // Text controller for task name

  @override
  void initState() {
    super.initState();
    setState(() {
      dbHelper = DatabaseHelper.instance;
    });
  }

  refreshTaskList() async {
    List<Task> tasksFromDatabase = await dbHelper.getTasks();
    setState(() {
      tasks = tasksFromDatabase;
    });
  }

  taskSubmit(String task) async {
    await dbHelper.insertTask(Task(task));
    refreshTaskList();
  }

  deleteTaskFromDatabase(Task task) async {
    dbHelper.deleteTask(task);
    refreshTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              width: 200,
              child: TextField(
                controller: taskController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Task",
                ),
              ),
            ),
            TextButton(
                onPressed: () {

                  bool isFound = false;

                  // Checks if the task is already in the list
                  tasks.forEach((task) {
                    if(task.taskName == taskController.text) {

                      isFound = true;
                      // Alerts the user if the task has already been entered
                      Alert(
                          context: context,
                          title: "Task already entered",
                          desc: "You have already entered that task"
                      ).show();
                    }
                  });

                  // Adds the task to the state if it's not found
                  if(!isFound) {
                    // Adds the task to the database
                    taskSubmit(taskController.text);

                    setState(() {
                      tasks.add(Task(taskController.text));
                      tasks = tasks;
                    });

                    // Resets the input to an empty string
                    taskController.text = "";
                  }
                },
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple)
                )
            )
          ],
        ),
        SizedBox(height: 20),
        Column(
          children: _showTasks()
        ),
      ],
    );
  }

  List<Widget> _showTasks() {
    List<Widget> newTasks = [];

    tasks.forEach((task) {
      newTasks.add(CheckboxListTile(
        title: Text(
          task.taskName,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none
          ),
        ),
        value: task.isCompleted,
        secondary: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            deleteTask(task);
          },
        ),
        onChanged: (newValue) {
          setState(() {
            task.isCompleted = !task.isCompleted;
          });
        },
      ),
      );
    });

    return newTasks;
  }

  void deleteTask(Task task) {
    List<Task> newTasksList = [];

    // Adds to newTasksList if current task isn't the one the user wants to delete
    tasks.forEach((taskInList) {
        if(taskInList.taskName != task.taskName) {
          newTasksList.add(taskInList);
        }
    });

    setState(() {
      tasks = newTasksList;
    });

    // Deletes the task from the database
    deleteTaskFromDatabase(task);
  }

}
