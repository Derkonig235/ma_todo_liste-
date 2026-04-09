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
                task.status == TaskStatus.inProgress
                    ? Icons.circle_outlined
                    : task.status == TaskStatus.done
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                color: task.status == TaskStatus.inProgress
                    ? Colors.blue
                    : task.status == TaskStatus.done
                        ? AppColors.done
                        : task.status == TaskStatus.late
                            ? Colors.orange
                            : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                task.status == TaskStatus.inProgress
                    ? "En cours"
                    : task.status == TaskStatus.done
                        ? "Terminée"
                        : task.status == TaskStatus.late
                            ? "En retard"
                            : "Abandonné",
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