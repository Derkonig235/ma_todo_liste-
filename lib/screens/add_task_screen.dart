import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onAdd;
  final Task? task;

  const AddTaskScreen({
    Key? key,
    required this.onAdd,
    this.task,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.personal;
  DateTime? _startDate;
  DateTime? _dueDate;
  bool _startDateError = false;
  bool _dueDateError = false;

  @override
  void initState() {
    super.initState();
      if (widget.task != null) {
        _titleController.text = widget.task!.title;
        _descriptionController.text = widget.task!.description;
        _priority = widget.task!.priority;
        _category = widget.task!.category;
        _startDate = widget.task!.startDate;
        _dueDate = widget.task!.dueDate;
      }
  }

  bool _hasInput() {
    return _titleController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _startDate != null ||
        _dueDate != null;
  }

  Future<void> _pickDate(bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startDate = fullDateTime;
            _startDateError = false;
          } else {
            _dueDate = fullDateTime;
            _dueDateError = false;
          }
        });
      }
    }
  }

  Future<void> _saveTask() async {
    setState(() {
      _startDateError = _startDate == null;
      _dueDateError = _dueDate == null;
    });

    if (!_formKey.currentState!.validate() || _startDateError || _dueDateError) {
      return;
    }

    final Task newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _priority,
      category: _category,
      createdAt: DateTime.now(),
      startDate: _startDate!,
      dueDate: _dueDate!,
    );

    if (widget.task != null) {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Confirmer les modifications"),
      content: const Text("Voulez-vous vraiment enregistrer les modifications ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text("Non"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text(
            "Oui",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    ),
  );
  if (confirm != true) return;
}

    widget.onAdd(newTask);
    Navigator.pop(context);
  }

  void _cancel() {
    if (_hasInput()) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Annuler"),
          content: const Text("Des données ont été saisies. Voulez-vous vraiment annuler ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Non"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text(
                "Oui, annuler",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  InputDecoration _fieldDecoration(String placeholder) {
    return InputDecoration(
      hintText: placeholder,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _dateField(bool isStart) {
    final DateTime? date = isStart ? _startDate : _dueDate;
    final bool hasError = isStart ? _startDateError : _dueDateError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickDate(isStart),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError ? Colors.red : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date == null
                  ? isStart ? "Date début" : "Date fin"
                  : "${date.day}/${date.month}/${date.year} ${date.hour}h${date.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: date == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
                  ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 4),
            child: Text(
              "Date requise",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false,
    onPopInvoked: (didPop) {
    if (!didPop) _cancel();
  },
  child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.task != null
        ? AppStrings.editTask
        : AppStrings.addTask),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _cancel,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              _label("Titre"),
              TextFormField(
                controller: _titleController,
                decoration: _fieldDecoration("Titre de la tâche"),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _formKey.currentState?.validate();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le titre est requis";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              _label("Description"),
              TextFormField(
                controller: _descriptionController,
                decoration: _fieldDecoration("Décrivez la tâche..."),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Priorité
              _label("Priorité"),
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: _fieldDecoration("").copyWith(hintText: null),
                items: const [
                  DropdownMenuItem(value: TaskPriority.high, child: Text("Haute")),
                  DropdownMenuItem(value: TaskPriority.medium, child: Text("Moyenne")),
                  DropdownMenuItem(value: TaskPriority.low, child: Text("Basse")),
                ],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 16),

              // Catégorie
              _label("Catégorie"),
              DropdownButtonFormField<TaskCategory>(
                value: _category,
                decoration: _fieldDecoration("").copyWith(hintText: null),
                items: const [
                  DropdownMenuItem(value: TaskCategory.personal, child: Text("Personnel")),
                  DropdownMenuItem(value: TaskCategory.work, child: Text("Travail")),
                  DropdownMenuItem(value: TaskCategory.other, child: Text("Autre")),
                ],
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 16),

              // Dates
              _label("Dates"),
              Row(
                children: [
                  Expanded(child: _dateField(true)),
                  const SizedBox(width: 16),
                  Expanded(child: _dateField(false)),
                ],
              ),
              const SizedBox(height: 32),

              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Annuler",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Enregistrer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}