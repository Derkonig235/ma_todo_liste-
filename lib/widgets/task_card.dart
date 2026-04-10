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

  Color _statusColor() {
    switch (task.status) {
      case TaskStatus.done:
        return AppColors.done;
      case TaskStatus.late:
        return Colors.orange;
      case TaskStatus.abandoned:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône statut
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  task.status == TaskStatus.done
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: _statusColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Titre + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Boutons éditer + supprimer
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
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
                                    width: 180,
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
                    child: const Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}