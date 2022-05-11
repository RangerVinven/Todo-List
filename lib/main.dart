import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> tasks = ["Make lunch", "Revise", "Program"];

  // Text controller for task name
  TextEditingController taskController = TextEditingController();

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
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  List<String> tasks = ["Make lunch", "Revise", "Program"];

  // Text controller for task name
  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
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
                decoration: InputDecoration(
                  hintText: "Task",
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  // Tells the user if the task exists, otherwise, updates the state
                  if(!tasks.contains(taskController.text)) {
                    setState(() {
                      tasks.add(taskController.text);
                      tasks = tasks;
                    });
                  } else {
                    // Alerts the user if the task has already been entered
                    Alert(
                      context: context,
                      title: "Task already entered",
                      desc: "You have already entered that task"
                    ).show();
                  }
                },
                child: Text(
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
          children: _showTasks(),
        )
      ],
    );
  }

  List<Widget> _showTasks() {

    List<Widget> taskRows = [];

    tasks.forEach((task) => {
      taskRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(task),
          TextButton(
            onPressed: () {
              List<String> newTasksList = [];

              // Adds to newTasksList if current task isn't the one the user wants to delete
              tasks.forEach((taskName) {
                if(taskName != task) {
                  newTasksList.add(taskName);
                }
              });

              setState(() {
                tasks = newTasksList;
              });
            },
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
          ),
        ],
      ))
    });

    return taskRows;
  }
}
