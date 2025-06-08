import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/helper/helper_methods.dart';
import 'package:tasky/screens/user_details_screen.dart';
import 'package:tasky/widgets/custom_divider.dart';
import 'package:tasky/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  String name = '';
  bool isLoading = false;
  bool isDarkMode = true;
  String motivation = '';

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadThemeMode();
    _loadMotivation();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadName() async {
    setState(() => isLoading = true);
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      name = pref.getString("username") ?? "User";
      isLoading = false;
    });
  }

  Future<void> _loadThemeMode() async {
    final pref = await SharedPreferences.getInstance();
    final isDark = pref.getBool("isDarkMode") ?? true;
    setState(() {
      isDarkMode = isDark;
      if (isDark) _controller.forward();
      else _controller.reverse();
    });
  }

  Future<void> _loadMotivation() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      motivation = pref.getString("motivation_quote") ?? 'One task at a time. One step closer.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.blueGrey.shade900;
    final subTextColor = isDark ? Colors.white70 : Colors.blueGrey.shade600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: textColor,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.blueGrey.shade900),
      ),
      body: Stack(
        children: [
          // Beautiful Animated Background with bubbles & gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF0D1117), const Color(0xFF161B22)]
                    : [const Color(0xFFB3E5FC), const Color(0xFFE1F5FE)],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: -60,
            child: _buildBubble(isDark ? Colors.blueAccent.shade700 : Colors.blue.shade300, 120),
          ),
          Positioned(
            bottom: 100,
            right: -40,
            child: _buildBubble(isDark ? Colors.indigo.shade900 : Colors.lightBlue.shade100, 90),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: const AssetImage('assets/images/Thumbnail.png'),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.blueAccent.withOpacity(0.8) : Colors.blue.withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.blueAccent.shade400)
                        : Text(
                      '${name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : "User"}',
                      key: ValueKey(name),
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.blueAccent.withOpacity(0.45),
                            blurRadius: 14,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    motivation,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: subTextColor,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  _glassCard(
                    child: _buildUserSection(
                      icon: SvgPicture.asset(
                        'assets/images/profile_icon.svg',
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                            isDark ? Colors.white70 : Colors.blueGrey.shade900, BlendMode.srcIn),
                      ),
                      title: 'User Details',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserDetailsScreen(),
                          ),
                        );
                        if (result == true) {
                          _loadName();
                          _loadMotivation();
                        }
                      },
                      trailing: null,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _glassCard(
                    child: _buildUserSection(
                      icon: SvgPicture.asset(
                        'assets/images/dark_icon.svg',
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                            isDark ? Colors.white70 : Colors.blueGrey.shade900, BlendMode.srcIn),
                      ),
                      title: 'Dark Mode',
                      trailing: Switch.adaptive(
                        value: isDarkMode,
                        onChanged: (value) async {
                          setState(() {
                            isDarkMode = value;
                            if (value) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                          });
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool("isDarkMode", value);
                          MyApp.setThemeMode(context, value ? ThemeMode.dark : ThemeMode.light);
                        },
                        activeColor: Colors.blueAccent.shade400,
                        inactiveThumbColor: Colors.grey.shade400,
                      ),
                      onTap: null,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _glassCard(
                    child: _buildUserSection(
                      icon: Icon(Icons.logout_rounded,
                          color: isDark ? Colors.red.shade400 : Colors.red.shade700, size: 30),
                      title: 'Log Out',
                      onTap: () {
                        showLogoutDialog(context);
                      },
                      trailing: null,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildUserSection({
    required Widget icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      splashColor: Colors.blueAccent.withOpacity(0.35),
      highlightColor: Colors.blueAccent.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              icon,
              const SizedBox(width: 24),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.blueGrey.shade900,
                  letterSpacing: 0.3,
                ),
              ),
            ]),
            trailing ??
                Icon(Icons.arrow_forward_ios,
                    size: 20, color: isDark ? Colors.white70 : Colors.blueGrey.shade700),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 24,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}
