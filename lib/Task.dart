final String tableNotes = "tasks";

class TaskFields {
  static final String id = "_id";
  static final String task = "task";
  static final String isCompleted = "isCompleted";
}

class Task {
  String taskName = "";
  bool isCompleted = false;

  Task(String task) {
    taskName = task;
  }
}