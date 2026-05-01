import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class DetailScreen extends StatelessWidget {
  final Task task;

  const DetailScreen({Key? key, required this.task}) : super(key: key);

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

  String _statusLabel() {
    switch (task.status) {
      case TaskStatus.done:
        return "Terminée";
      case TaskStatus.late:
        return "En retard";
      case TaskStatus.abandoned:
        return "Abandonné";
      default:
        return "En cours";
    }
  }

  String _priorityLabel() {
    switch (task.priority) {
      case TaskPriority.high:
        return "Haute";
      case TaskPriority.medium:
        return "Moyenne";
      default:
        return "Basse";
    }
  }

  String _categoryLabel() {
    switch (task.category) {
      case TaskCategory.work:
        return "Travail";
      case TaskCategory.other:
        return "Autre";
      default:
        return "Personnel";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}\n${date.hour}h${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _cell(String label, String value, {Color valueColor = Colors.black}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.primary.withOpacity(0.3),
    );
  }

  Widget _row(List<Widget> cells) {
    final List<Widget> items = [];
    for (int i = 0; i < cells.length; i++) {
      items.add(cells[i]);
      if (i < cells.length - 1) items.add(_divider());
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              task.description.isEmpty ? "Aucune description" : task.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Ligne 1 : Statut | Priorité | Catégorie
            _row([
              _cell("Statut", _statusLabel(), valueColor: _statusColor()),
              _cell(
                "Priorité",
                _priorityLabel(),
                valueColor: task.priority == TaskPriority.high
                    ? Colors.red
                    : task.priority == TaskPriority.medium
                        ? Colors.orange
                        : Colors.green,
              ),
              _cell("Catégorie", _categoryLabel(), valueColor: Colors.blue),
            ]),
            const SizedBox(height: 12),

            // Ligne 2 : Créée le | Début | Fin
            _row([
              _cell("Créée le", _formatDate(task.createdAt)),
              _cell("Début", _formatDate(task.startDate), valueColor: Colors.green),
              _cell("Fin", _formatDate(task.dueDate), valueColor: Colors.red),
            ]),
          ],
        ),
      ),
    );
  }
}