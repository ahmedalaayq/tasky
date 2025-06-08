import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.onPressed, required this.buttonText, this.fixedSize});
  final VoidCallback onPressed;
  final String buttonText;
  final Size? fixedSize;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.grey.shade900,
        disabledForegroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Color(0xFFFFFCFC),
        fixedSize: fixedSize ?? Size(375, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: GoogleFonts.poppins(
          color: Color(0xFFFFFCFC),
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
