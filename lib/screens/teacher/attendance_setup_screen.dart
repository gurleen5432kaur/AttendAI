import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../models/class_session_model.dart';
import '../../services/class_session_service.dart';
import 'generate_qr_screen.dart';

class AttendanceSetupScreen extends StatefulWidget {
  const AttendanceSetupScreen({super.key});

  @override
  State<AttendanceSetupScreen> createState() => _AttendanceSetupScreenState();
}

class _AttendanceSetupScreenState extends State<AttendanceSetupScreen> {
  final teacherController = TextEditingController();
  final subjectController = TextEditingController();
  final semesterController = TextEditingController();
  final sectionController = TextEditingController();
  final periodController = TextEditingController();

  @override
  void dispose() {
    teacherController.dispose();
    subjectController.dispose();
    semesterController.dispose();
    sectionController.dispose();
    periodController.dispose();
    super.dispose();
  }

  Widget buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,

          labelText: label,

          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),

          prefixIcon: Icon(icon, color: AppColors.primaryBlue),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 2,
            ),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  void startAttendance() {
    if (teacherController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty ||
        semesterController.text.trim().isEmpty ||
        sectionController.text.trim().isEmpty ||
        periodController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text("Please fill all fields"),
        ),
      );

      return;
    }

    final session = ClassSessionModel(
      teacherName: teacherController.text.trim(),
      subject: subjectController.text.trim(),
      semester: semesterController.text.trim(),
      section: sectionController.text.trim(),
      periods: periodController.text.trim(),
    );

    ClassSessionService.instance.currentSession = session;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GenerateQRScreen(session: session)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: Text(
          "Start Attendance",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F6FF), Color(0xFFF1EDFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),

                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B8AFB), Color(0xFF7C6CE8)],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 90,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Attendance Setup",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Fill in the class details before generating the attendance PIN.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                buildField(
                  label: "Teacher Name",
                  icon: Icons.person_outline_rounded,
                  controller: teacherController,
                ),

                buildField(
                  label: "Subject",
                  icon: Icons.menu_book_rounded,
                  controller: subjectController,
                ),

                buildField(
                  label: "Semester",
                  icon: Icons.school_rounded,
                  controller: semesterController,
                ),

                buildField(
                  label: "Section",
                  icon: Icons.groups_rounded,
                  controller: sectionController,
                ),

                buildField(
                  label: "Period(s)",
                  icon: Icons.schedule_rounded,
                  controller: periodController,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton.icon(
                    onPressed: startAttendance,

                    icon: const Icon(Icons.lock_open_rounded, size: 26),

                    label: Text(
                      "Generate PIN",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 8,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primaryBlue,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Instructions",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "• Fill all class details correctly.\n"
                              "• Press 'Generate PIN' to create a secure attendance PIN.\n"
                              "• Students must enter the PIN before it expires.\n"
                              "• A new PIN can be generated whenever required.",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                height: 1.6,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
