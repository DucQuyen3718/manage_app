import 'package:flutter/material.dart';
import 'package:project/model/task.model.dart';
import 'package:project/view_model/task.view_model.dart';

class TaskDetailView extends StatefulWidget {
  final TaskModel? task;
  const TaskDetailView({super.key, this.task});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  late TextEditingController? tfTitleController;
  late TextEditingController? tfDescriptionController;
  final TaskViewModel _taskViewModel = TaskViewModel();

  @override
  void initState() {
    tfTitleController =
        TextEditingController(text: widget.task?.title.value ?? '');
    tfDescriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task?.id != null ? 'Update' : 'Create'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).width * 0.2),
          TextField(
            controller: tfTitleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            onChanged: (value) {
              widget.task?.title.value = value;
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: tfDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            onChanged: (value) {
              widget.task?.title.value = value;
            },
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _onCreateOrUpdatePressed,
            child: Container(
              height: 52,
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.task?.id != null ? 'Update' : 'Create',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onCreateOrUpdatePressed() {
    if (widget.task?.id != null) {
      _taskViewModel.updateTask(widget.task!.id, tfTitleController?.text ?? '',
          tfDescriptionController?.text ?? '');
    } else {
      _taskViewModel.addTask(TaskModel(
          title: tfTitleController?.text ?? '',
          description: tfDescriptionController?.text ?? ''));
    }
    Navigator.pop(context);
  }
}
