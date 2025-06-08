import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/main_screen.dart';
import 'package:tasky/screens/welcome_screen.dart';

import 'helper/helper_methods.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final String? name = pref.getString("username");
  // ErrorWidget.builder =
  //     kDebugMode
  //         ? (FlutterErrorDetails details) {
  //           return ErrorWidget(details.exception.toString());
  //         }
  //         : buildErrorScreen();
  buildErrorScreen();

  runApp(MyApp(userName: name));
}

class MyApp extends StatefulWidget {
  final String? userName;
  const MyApp({super.key, required this.userName});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setThemeMode(BuildContext context, ThemeMode mode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeTheme(mode);
  }
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDarkMode") ?? true;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", mode == ThemeMode.dark);
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasky',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF15B86C),
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF15B86C),
        scaffoldBackgroundColor: Color(0xFF181818),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF181818),
          iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
          titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        useMaterial3: true,
      ),
      home: widget.userName == null ? WelcomeScreen() : MainScreen(),
    );
  }
}
