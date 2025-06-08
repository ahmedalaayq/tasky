import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleTextStyle,
    this.backgroundColor,
  });

  final String? title;
  final TextStyle? titleTextStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ?? (isDark ? theme.primaryColor : Colors.white);
    final textColor = isDark ? Colors.white : Colors.black87;

    return AppBar(
      backgroundColor: bgColor,
      iconTheme: IconThemeData(color: textColor),
      actionsIconTheme: IconThemeData(color: textColor),
      titleTextStyle: titleTextStyle ??
          GoogleFonts.poppins(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
      title: Text(title ?? 'AppBar Title'),
      elevation: 1,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
