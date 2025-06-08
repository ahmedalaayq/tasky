import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../models/task_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  List<TaskModel> todoTasks = [];
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
        todoTasks =
            taskDecode.map((e) {
              return TaskModel.fromJson(e);
            }).toList();
        todoTasks =
            todoTasks.where((element) => element.isDone == false).toList();
        isLoading = false;
      });
    }
    else {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final greetingColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.white, title: Text('To Do Tasks')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : TaskListWidget(

                  emptyMessage: 'No Tasks Found',
                  tasks: todoTasks,
              onTapCard: (int? index) async {
                setState(() {
                  todoTasks[index!].isDone =
                  !todoTasks[index].isDone;
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
                        (i) => i.id == todoTasks[index!].id,
                  );
                  if (newIndex > -1) {
                    allTasks[newIndex] =
                    todoTasks[index!];
                  }

                  debugPrint(allTasks.toString());


                  await pref.setString("tasks", jsonEncode(allTasks));
                  _loadTask();
                }
              },
              onTap: (bool? value, int? index) async {
                setState(() {
                  todoTasks[index!].isDone = value ?? false;
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
                        (i) => i.id == todoTasks[index!].id,
                  );
                  if (newIndex > -1) {
                    allTasks[newIndex] =
                    todoTasks[index!];
                  }

                  await pref.setString("tasks", jsonEncode(allTasks));
                  _loadTask();
                }
              },
                ),
      ),
    );
  }
}
