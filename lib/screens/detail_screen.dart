import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';

class DetailScreen extends StatelessWidget {
  final Task task;

  const DetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: AppStyles.title),
            const SizedBox(height: 16),
            Text(task.description, style: AppStyles.subtitle),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  task.isDone ? Icons.check_circle : Icons.circle_outlined,
                  color: task.isDone ? AppColors.done : AppColors.notDone,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isDone
                      ? AppStrings.taskDone
                      : AppStrings.taskNotDone,
                  style: AppStyles.subtitle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Créée le : ${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}",
              style: AppStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}