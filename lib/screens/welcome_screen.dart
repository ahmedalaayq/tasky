import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late TextEditingController _nameController;
  late GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.onUserInteraction;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          autovalidateMode: _autovalidateMode,
          key: _formKey,
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
                      validator: (String? value) {
                        if (value == null || value
                            .trim()
                            .isEmpty) {
                          return 'Field Full Name is Required';
                        } else {
                          return null;
                        }
                      },

                      maxLength: 20,

                      controller: _nameController,
                      cursorColor: Color(0xFFFFFCFC),
                      style: TextStyle(
                        color: Color(0xFFFFFCFC),
                        fontWeight: FontWeight.w600,
                      ),

                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Color(0xFFF44336),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),

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
              SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey.shade900,
                  disabledForegroundColor: Colors.white,
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  foregroundColor: Color(0xFFFFFCFC),
                  minimumSize: Size(340, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false)
                  {
                    _autovalidateMode = AutovalidateMode.onUnfocus;
                    final pref = await SharedPreferences.getInstance();
                    final String? name = pref.getString("username");
                    if(name?.trim().isEmpty ?? true)
                    {
                      await pref.setString("username", _nameController.text);
                    }
                    _nameController.clear();
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                      return MainScreen();
                    }));
                  }
                  _autovalidateMode = AutovalidateMode.always;
                  setState(() {

                  });
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
    ),
  );
}}
