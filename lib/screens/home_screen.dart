import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import 'add_task_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  void _deleteTask(String id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
  }

  void _addTask(Task task) {
  setState(() {
    tasks.add(task);
  });
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text(
      "Tâche ajoutée avec succès",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.blue,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    width: 220,
    duration: const Duration(seconds: 2),
  ),
);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Zone bleue
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Zone blanche avec border radius
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: tasks.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.checklist,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 14),
                            Text(
                              AppStrings.noTasks,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          task: tasks[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(task: tasks[index]),
                              ),
                            );
                          },
                          onDelete: () => _deleteTask(tasks[index].id),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onAdd: _addTask),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}