import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasky',
      theme: ThemeData(
        primaryColor: Color(0xFF15B86C),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        scaffoldBackgroundColor: Color(0xFF181818),

        useMaterial3: true,
      ),
      home:WelcomeScreen(),
    );
  }
}
