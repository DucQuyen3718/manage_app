import 'dart:math';

import 'package:flutter/material.dart';

class TaskModel {
  String id;
  ValueNotifier<String> title;
  String description;
  TaskModel({String? id, required String title, this.description = ''})
      : id = id ?? generateUuid(),
        title = ValueNotifier(title);

  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }
}
