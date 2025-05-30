import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:tasky/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    width: 42,
                    height: 42,
                    'assets/images/logo.svg',
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Tasky',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 118),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome To Tasky ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFCFC),
                    ),
                  ),
                  SvgPicture.asset('assets/images/waving_hand.svg'),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Your productivity journey starts here.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFFFCFC),
                ),
              ),
              SizedBox(height: 24),
              SvgPicture.asset(
                width: 210,
                height: 200,
                'assets/images/welcome_work.svg',
              ),
              Gap(28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.left,
                      'Full Name',
                      style: TextStyle(
                        color: Color(0xFFFFFCFC),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      cursorColor: Color(0xFFFFFCFC),
                      style: TextStyle(
                        color: Color(0xFFFFFCFC),
                        fontWeight: FontWeight.w600,
                      ),
                      // onChanged: (value) {
                      //   name = value;
                      // },
                      decoration: InputDecoration(
                        hintText: 'e.g. Sarah Khalid',
                        hintStyle: TextStyle(
                          color: Color(0xFF6D6D6D),
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Color(0xFF282828),
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Color(0xFFFFFCFC),
                  minimumSize: Size(340, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    _nameController.clear();

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        duration: Duration(seconds: 5),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Field Full Name is Required',
                              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.error_outline_rounded,color: Colors.white,)
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Let’s Get Started',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
