import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/screens/home_screen.dart';
import 'package:tasky/screens/profile_screen.dart';
import 'package:tasky/screens/todo_screen.dart';

import 'completed_task_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    TodoScreen(),
    CompletedTasksScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,height: 3),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        enableFeedback: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).secondaryHeaderColor,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF181818),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                _currentIndex == 0
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).secondaryHeaderColor,
                BlendMode.srcIn,
              ),
              'assets/images/home_icon.svg',
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                _currentIndex == 1
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).secondaryHeaderColor,
                BlendMode.srcIn,
              ),

              'assets/images/todo_icon.svg',
            ),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                _currentIndex == 2
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).secondaryHeaderColor,
                BlendMode.srcIn,
              ),

              'assets/images/completed_task_icon.svg',
            ),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                _currentIndex == 3
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).secondaryHeaderColor,
                BlendMode.srcIn,
              ),

              'assets/images/profile_icon.svg',
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: _screens[_currentIndex],
    );
  }
}
