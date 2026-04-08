import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/custom_button.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onAdd;

  const AddTaskScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveTask() {
    if (_titleController.text.isEmpty) return;

    final Task newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: DateTime.now(),
    );

    widget.onAdd(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.addTask),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: AppStrings.taskTitle,
              ),
              style: AppStyles.title,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: AppStrings.taskDescription,
              ),
              style: AppStyles.subtitle,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: AppStrings.save,
              onPressed: _saveTask,
            ),
          ],
        ),
      ),
    );
  }
}