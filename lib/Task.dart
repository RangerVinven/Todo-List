import 'package:flutter/material.dart';

class Task {
  static const tableName = "tasks";
  static const colTask = "task";
  static const colIsCompleted = "isCompleted";

  String taskName = "";
  bool isCompleted = false;

  Task(String task) {
    taskName = task;
  }

  Task.fromMap(Map<String, dynamic> map) {
    taskName = map[colTask];
    int isCompletedInt = map[colIsCompleted];

    isCompleted = (isCompletedInt == 1) ? true : false;
  }

  // Turns the variables into a hashmap for storing in database
  Map<String, dynamic> toMap() {
    int letCompletedInt = isCompleted ? 1 : 0;
    var map = <String, dynamic>{colTask: taskName, colIsCompleted: letCompletedInt};

    return map;
  }

}