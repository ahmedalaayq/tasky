import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/widgets/custom_elevated_button.dart';
import 'package:tasky/widgets/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}
class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _motivationController;
  late GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  String name = "";
  String motivationQuote = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _motivationController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.onUserInteraction;

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    final pref = await SharedPreferences.getInstance();

    name = pref.getString("username") ?? "";
    motivationQuote = pref.getString("motivation_quote") ?? "";

    _nameController.text = name;
    _motivationController.text = motivationQuote;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final greetingColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(title: Text('User Details')),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).secondaryHeaderColor,
        ),
      )
          : Form(
        autovalidateMode: _autovalidateMode,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'User Name',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                controller: _nameController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'field username is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Motivation Quote',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
              CustomTextFormField(
                hintText: 'One task at a time. One step closer.',
                controller: _motivationController,
                maxLines: 5,
              ),
              Spacer(),
              CustomElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final pref = await SharedPreferences.getInstance();
                    await pref.setString("username", _nameController.text);
                    await pref.setString("motivation_quote", _motivationController.text);

                    debugPrint(
                      'userName after update: ${pref.getString("username")}',
                    );
                    debugPrint(
                      'motivationQuote after update: ${pref.getString("motivation_quote")}',
                    );

                    setState(() {
                      _loadUserData();
                    });
                    Navigator.pop(context, true);
                  } else {
                    setState(() {
                      _autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                buttonText: 'Save Changes',
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
