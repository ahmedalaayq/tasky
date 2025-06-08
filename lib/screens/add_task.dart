import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/custom_appbar.dart';
import 'package:tasky/widgets/custom_text_form_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool _isHighPriorityTask = true;
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final subTextColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (isDark ? Colors.white70 : Colors.black54);
    final hintTextColor = isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.4);


    return Scaffold(
      appBar: CustomAppBar(
        title: 'New Task',
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,

        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Task Name',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _taskNameController,
                        maxLength: 40,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Task Name is required';
                          }
                          return null;
                        },
                        hintText: 'Finish UI design for login screen',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: hintTextColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Task Description',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        
                        controller: _taskDescriptionController,
                        maxLines: 6,
                        hintText: 'Finish onboarding UI and hand off to devs by Thursday.',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: hintTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        contentPadding: EdgeInsets.zero,
                        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
                        }),
                        activeTrackColor: Colors.greenAccent.shade700,
                        inactiveTrackColor: Colors.grey.shade400,
                        title: Text(
                          'High Priority',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        value: _isHighPriorityTask,
                        onChanged: (value) {
                          setState(() {
                            _isHighPriorityTask = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: theme.primaryColor.withOpacity(0.5),
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Task'),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final pref = await SharedPreferences.getInstance();
                  final taskJson = pref.getString('tasks');
                  List<TaskModel> taskList = [];

                  if (taskJson != null) {
                    final decoded = jsonDecode(taskJson) as List;
                    taskList = decoded.map((task) => TaskModel.fromJson(task)).toList();
                  }

                  final newTask = TaskModel(
                    taskName: _taskNameController.text.trim(),
                    taskDescription: _taskDescriptionController.text.trim(),
                    isHighPriority: _isHighPriorityTask,
                    id: taskList.isEmpty ? 1 : taskList.last.id + 1,
                  );

                  taskList.add(newTask);
                  final encoded = jsonEncode(taskList.map((task) => task.toJson()).toList());
                  await pref.setString('tasks', encoded);

                  _taskNameController.clear();
                  _taskDescriptionController.clear();

                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
