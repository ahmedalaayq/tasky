import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../models/task_model.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTasksScreen> {
  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  List<TaskModel> completedTasks = [];
  bool isLoading = false;

  Future<void> _loadTask() async {
    setState(() {
      isLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 5));
    final allTasks = pref.getString("tasks");
    if (allTasks != null) {
      final taskDecode = jsonDecode(allTasks) as List<dynamic>;
      setState(() {
        completedTasks =
            taskDecode
                .map((e) => TaskModel.fromJson(e))
                .where((element) => element.isDone)
                .toList();
        isLoading = false;
      });
    } else {
      // Get.snackbar(
      //   "Error",
      //   "no task found",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.black87,
      //   colorText: Colors.white,
      // );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Completed Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : TaskListWidget(
                  onTapCard: (int? index) async {
                    setState(() {
                      completedTasks[index!].isDone =
                          !completedTasks[index].isDone;
                    });
                    final pref = await SharedPreferences.getInstance();
                    final allDataString = pref.getString("tasks");

                    if (allDataString != null) {
                      final allDataList =
                          jsonDecode(allDataString) as List<dynamic>;
                      final List<TaskModel> allTasks =
                          allDataList
                              .map((e) => TaskModel.fromJson(e))
                              .toList();

                      final newIndex = allTasks.indexWhere(
                        (i) => i.id == completedTasks[index!].id,
                      ); // أو todoTasks[index].id
                      if (newIndex > -1) {
                        allTasks[newIndex] =
                            completedTasks[index!]; // أو todoTasks[index]
                      }

                      debugPrint(allTasks.toString());


                      await pref.setString("tasks", jsonEncode(allTasks));
                      _loadTask();
                    }
                  },
                  onTap: (bool? value, int? index) async {
                    setState(() {
                      completedTasks[index!].isDone = value ?? false;
                    });
                    final pref = await SharedPreferences.getInstance();
                    final allDataString = pref.getString("tasks");

                    if (allDataString != null) {
                      final allDataList =
                          jsonDecode(allDataString) as List<dynamic>;
                      final List<TaskModel> allTasks =
                          allDataList
                              .map((e) => TaskModel.fromJson(e))
                              .toList();

                      final newIndex = allTasks.indexWhere(
                        (i) => i.id == completedTasks[index!].id,
                      ); // أو todoTasks[index].id
                      if (newIndex > -1) {
                        allTasks[newIndex] =
                            completedTasks[index!]; // أو todoTasks[index]
                      }

                      await pref.setString("tasks", jsonEncode(allTasks));
                      _loadTask();
                    }
                  },

                  emptyMessage: 'No Completed Task Found',
                  tasks: completedTasks,
                ),
      ),
    );
  }
}
