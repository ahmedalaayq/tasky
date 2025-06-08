import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    this.emptyMessage,
    required this.onTapCard,
  });

  final List<TaskModel> tasks;
  final Function(bool? value, int? index) onTap;
  final String? emptyMessage;
  final Function(int) onTapCard;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final doneTextColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;
    final cardBgColor = isDark ? Colors.grey[900] : Colors.grey[100];

    return tasks.isEmpty
        ? Center(
      child: Text(
        emptyMessage ?? "No Tasks",
        style: TextStyle(
          color: subTextColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    )
        : ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 60),
      cacheExtent: 120,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final bool done = task.isDone;
        final taskName = task.taskName.isNotEmpty
            ? '${task.taskName[0].toUpperCase()}${task.taskName.substring(1)}'
            : '';
        final taskDesc = task.taskDescription.isNotEmpty
            ? '${task.taskDescription[0].toUpperCase()}${task.taskDescription.substring(1)}'
            : '';

        return GestureDetector(
          onTap: () => onTapCard(index),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: done ? (isDark ? Colors.grey[800] : Colors.grey[300]) : cardBgColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: done
                  ? []
                  : [
                BoxShadow(
                  color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.3),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: done,
                  activeColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (value) => onTap(value, index),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: done ? doneTextColor : textColor,
                          decoration:
                          done ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: doneTextColor,
                          decorationThickness: 2,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (taskDesc.isNotEmpty)
                        const SizedBox(height: 4),
                      if (taskDesc.isNotEmpty)
                        Text(
                          taskDesc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: done ? doneTextColor : subTextColor,
                            decoration:
                            done ? TextDecoration.lineThrough : TextDecoration.none,
                            decorationColor: doneTextColor,
                            decorationThickness: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: done ? null : () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: done ? doneTextColor : primaryColor,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
