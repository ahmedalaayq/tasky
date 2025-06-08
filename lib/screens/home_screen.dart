import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/screens/add_task.dart';
import 'package:tasky/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? name = '';
  String motivation = '';
  bool isMotivationLoading = true;
  List<TaskModel> tasks = [];
  bool isDarkMode = true;

  late AnimationController _counterAnimationController;
  late Animation<double> _counterScaleAnimation;
  late AnimationController _highPriorityAnimController;

  @override
  void initState() {
    super.initState();
    getName();
    _loadTask();
    _loadMotivation();
    _loadThemeMode();

    // Active Task Counter Animation Controller
    _counterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _counterScaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_counterAnimationController);

    // High Priority Cards animation
    _highPriorityAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void getName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("username") ?? 'User';
    });
  }

  Future<void> _loadThemeMode() async {
    final pref = await SharedPreferences.getInstance();
    final isDark = pref.getBool("isDarkMode") ?? true;
    setState(() {
      isDarkMode = isDark;
    });
  }

  Future<void> _loadTask() async {
    final pref = await SharedPreferences.getInstance();
    final allTasks = pref.getString("tasks");
    if (allTasks != null) {
      final taskDecode = jsonDecode(allTasks) as List<dynamic>;
      setState(() {
        tasks = taskDecode.map((e) => TaskModel.fromJson(e)).toList();
      });
    }
    // Animate active task counter on load / update
    _counterAnimationController.forward(from: 0);
    _highPriorityAnimController.forward(from: 0);
  }

  Future<void> _loadMotivation() async {
    setState(() {
      isMotivationLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      motivation = pref.getString("motivation_quote") ??
          'One task at a time. One step closer.';
      isMotivationLoading = false;
    });
  }

  @override
  void dispose() {
    _counterAnimationController.dispose();
    _highPriorityAnimController.dispose();
    super.dispose();
  }

  int get activeTaskCount => tasks.where((task) => !task.isDone).length;

  List<TaskModel> get highPriorityTasks =>
      tasks.where((task) => task.isHighPriority).toList();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final greetingColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Avatar + Name
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          width: 42,
                          height: 42,
                          'assets/images/Thumbnail.png',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 240,
                            child: Text(
                              'Good Evening, $name',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            motivation,
                            style: TextStyle(
                              color: subTextColor,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Theme icon toggle button
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor:
                      isDark ? Colors.grey[800] : Colors.grey[200],
                      fixedSize: const Size(34, 34),
                    ),
                    onPressed: () async {
                      final newMode = !isDarkMode;
                      setState(() {
                        isDarkMode = newMode;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("isDarkMode", newMode);
                      MyApp.setThemeMode(
                          context, newMode ? ThemeMode.dark : ThemeMode.light);
                    },
                    icon: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      size: 20,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Greeting Title
              Text(
                'Yuhuu, Your work is',
                style: TextStyle(
                  color: greetingColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              const SizedBox(height: 4),

              /// Sub greeting with emoji
              Row(
                children: [
                  Text(
                    'almost done!',
                    style: TextStyle(
                      color: greetingColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/images/waving_hand.svg',
                    width: 30,
                    height: 30,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// High Priority Task Box with fade+slide animation
              if (highPriorityTasks.isNotEmpty) ...[
                Text(
                  'High Priority Tasks',
                  style: TextStyle(
                    color: primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: AnimatedBuilder(
                    animation: _highPriorityAnimController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _highPriorityAnimController.value,
                        child: Transform.translate(
                          offset: Offset(
                              50 * (1 - _highPriorityAnimController.value), 0),
                          child: child,
                        ),
                      );
                    },
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: highPriorityTasks.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final task = highPriorityTasks[index];
                        return HighPriorityTaskCard(
                          task: task,
                          primaryColor: primary,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              /// Active Task Counter with scale animation and pulse
              ScaleTransition(
                scale: _counterScaleAnimation,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.8),
                        primary.withOpacity(1.0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.checklist_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '$activeTaskCount Active Task${activeTaskCount == 1 ? '' : 's'}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// Add New Task Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor
                  ),
                  icon: const Icon(Icons.add,color: Color(0xFFFFFCFC),),
                  label: Text(
                    "Add New Task",
                    style: GoogleFonts.poppins(
                      color: Color(0xFFFFFCFC),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTask(),
                      ),
                    );
                    if (result == true) {
                      _loadTask();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HighPriorityTaskCard extends StatelessWidget {
  final TaskModel task;
  final Color primaryColor;

  const HighPriorityTaskCard({
    Key? key,
    required this.task,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white70,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.taskName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                task.isDone ? Icons.check_circle : Icons.priority_high,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                task.isDone ? 'Completed' : 'Pending',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
