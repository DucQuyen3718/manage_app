import 'package:flutter/material.dart';
import 'package:project/model/task.model.dart';

class TaskViewModel extends ChangeNotifier {
  TaskViewModel._();

  static final TaskViewModel _instance = TaskViewModel._();

  factory TaskViewModel() {
    return _instance;
  }

  final List<TaskModel> tasks = [];

  List<TaskModel> taskSearchResults = [];

  bool isSearchMode = false;

  String titleSearch = '';

  bool isSearchLoading = false;

  void addTask(TaskModel task) {
    tasks.add(task);
    resetSearchValue();
    notifyListeners();
  }

  void resetSearchValue() {
    isSearchMode = false;
    taskSearchResults = [];
    titleSearch = '';
    notifyListeners();
  }

  void deleteTask(String id) {
    tasks.removeWhere((element) => element.id == id);
    searchTasks(titleSearch);
    notifyListeners();
  }

  void updateTask(String id, String title, String description) {
    try {
      final TaskModel task = tasks.firstWhere((item) => item.id == id);
      task.title.value = title;
      task.description = description;
      searchTasks(titleSearch);
    } catch (_) {}
  }

  void searchTasks(String q) {
    isSearchMode = q.isNotEmpty;
    titleSearch = q;
    taskSearchResults = [];
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].title.value.toLowerCase().contains(q.toLowerCase())) {
        taskSearchResults.add(tasks[i]);
      }
    }
    notifyListeners();
  }

  void isSearching() {
    isSearchLoading = true;
    notifyListeners();
  }

  void isNotSearching() {
    isSearchLoading = false;
    notifyListeners();
  }
}
