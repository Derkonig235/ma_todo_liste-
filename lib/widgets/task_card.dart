import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';

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
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        leading: Icon(
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
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text("Supprimer la tâche"),
                content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Annuler"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      onDelete();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Tâche supprimée"),
                          backgroundColor: Colors.grey[800],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      "Supprimer",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}