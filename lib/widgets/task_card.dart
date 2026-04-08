import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title, style: AppStyles.title),
        subtitle: Text(task.description, style: AppStyles.subtitle),
        leading: Icon(
          task.isDone ? Icons.check_circle : Icons.circle_outlined,
          color: task.isDone ? AppColors.done : AppColors.notDone,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}