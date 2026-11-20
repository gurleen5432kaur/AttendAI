import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../student/student_login_screen.dart';
import '../teacher/teacher_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FBFF),
              Color(0xFFEAF7FF),
              Color(0xFFE6FFF5),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [

                const Spacer(),

                const Text(
                  "👋",
                  style: TextStyle(fontSize: 45),
                ),

                const SizedBox(height: 12),

                Text(
                  "Welcome to",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: AppColors.greyText,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  AppStrings.appName,
                  style: GoogleFonts.poppins(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  AppStrings.tagline,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Making attendance smarter,\nfaster & secure.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.greyText,
                  ),
                ),

                const Spacer(),

                _roleButton(
                  context,
                  title: "Continue as Teacher",
                  icon: Icons.school,
                  color1: const Color(0xFF6366F1),
                  color2: const Color(0xFF8B5CF6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeacherLoginScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                _roleButton(
                  context,
                  title: "Continue as Student",
                  icon: Icons.person,
                  color1: const Color(0xFF10B981),
                  color2: const Color(0xFF34D399),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentLoginScreen(),
                      ),
                    );
                  },
                ),

                const Spacer(),

                Text(
                  "Designed & Developed by",
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Gurleen Kaur ❤️",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color1,
        required Color color2,
        required VoidCallback onTap,
      }) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color1, color2],
        ),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.30),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}