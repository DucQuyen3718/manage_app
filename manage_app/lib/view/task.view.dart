import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/model/task.model.dart';
import 'package:project/view/task_detail.view.dart';
import 'package:project/view/widgets/task_item.dart';
import 'package:project/view_model/task.view_model.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final TaskViewModel _taskViewModel = TaskViewModel();
  late final TextEditingController _tfController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _tfController = TextEditingController();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _tfController,
                onChanged: (value) {
                  _onSearch(value);
                },
                decoration: const InputDecoration(hintText: 'Search...'),
              )),
          const SizedBox(height: 16),
          Expanded(
            child: ListenableBuilder(
              listenable: _taskViewModel,
              builder: (context, _) {
                if (_taskViewModel.isSearchMode) {
                  if (_taskViewModel.isSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_taskViewModel.taskSearchResults.isEmpty) {
                    return const Center(
                      child: Text('Danh sách tìm kiếm rỗng'),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (BuildContext insContext, int index) {
                      final task =
                          _taskViewModel.taskSearchResults.elementAt(index);
                      return TaskItem(
                        task: task,
                        onPressed: () {
                          _onTaskPressed.call(task);
                        },
                        onDeletePressed: () {
                          _onDeleteTaskPressed.call(task.id);
                        },
                      );
                    },
                    itemCount: _taskViewModel.taskSearchResults.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                } else {
                  if (_taskViewModel.tasks.isEmpty) {
                    return const Center(
                      child: Text('Danh sách rỗng'),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (BuildContext insContext, int index) {
                      final task = _taskViewModel.tasks.elementAt(index);
                      return TaskItem(
                        task: task,
                        onPressed: () {
                          _onTaskPressed.call(task);
                        },
                        onDeletePressed: () {
                          _onDeleteTaskPressed.call(task.id);
                        },
                      );
                    },
                    itemCount: _taskViewModel.tasks.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateTaskPressed,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onCreateTaskPressed() async {
    _tfController.clear();
    _taskViewModel.resetSearchValue();
    await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const TaskDetailView()))
        .whenComplete(() => null);
  }

  Future<void> _onTaskPressed(TaskModel task) async {
    await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskDetailView(task: task)))
        .whenComplete(() => null);
  }

  void _onDeleteTaskPressed(String id) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Xoá task'),
            content: const Text('Bạn có chắc bạn muốn xoá task này?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Xoá'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _taskViewModel.deleteTask(id);
                },
              ),
            ],
          );
        });
  }

  void _onSearch(String value) {
    _taskViewModel.isSearching();
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), () {
      _taskViewModel.searchTasks(value);
      _taskViewModel.isNotSearching();
      timer?.cancel();
    });
  }
}
