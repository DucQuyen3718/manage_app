import 'package:flutter/material.dart';
import 'package:project/model/task.model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onPressed, onDeletePressed;
  const TaskItem({
    super.key,
    required this.task,
    required this.onPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: task.title,
      builder: (BuildContext context, String? title, Widget? child) {
        return GestureDetector(
          onTap: () {
            onPressed.call();
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            title: Text(
              title ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            leading: const FlutterLogo(),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDeletePressed(),
            ),
          ),
        );
      },
    );
  }
}
