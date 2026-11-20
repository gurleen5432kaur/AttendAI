import 'attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import 'attendance_setup_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../../services/attendance_service.dart';
import '../../models/attendance_model.dart';

class TeacherDashboard extends StatefulWidget {
const TeacherDashboard({super.key});

@override
State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  List<AttendanceModel> attendanceList = [];

  int present = 0;
  int absent = 0;
  int totalStudents = 0;

  Future<void> loadAttendance() async {
    await AttendanceService.instance.loadAttendance();

    attendanceList = AttendanceService.instance.attendanceList;

    totalStudents = attendanceList.length;

    present = attendanceList.where((e) => e.isPresent).length;

    absent = totalStudents - present;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF8F7CF8),
        title: const Text(
          "Start Attendance",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //================ HEADER ====================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),

                  gradient: const LinearGradient(
                    colors: [Color(0xff3B82F6), Color(0xff2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 34,
                          backgroundColor: const Color(0xFFF8F6FF),

                            child: Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.indigo,
                              size: 36,
                            ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                _greeting(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Welcome Teacher",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                          size: 18,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          DateFormat("EEEE, d MMMM yyyy").format(now),

                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "Today's Overview",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: statCard(
                      title: "Students",
                      value: "$totalStudents",
                      icon: Icons.groups_rounded,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: statCard(
                      title: "Present",
                      value: "$present",
                      icon: Icons.verified_rounded,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: statCard(
                      title: "Absent",
                      value: "$absent",
                      icon: Icons.person_off_rounded,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: statCard(
                      title: "Attendance",
                      value: "$present/$totalStudents",
                      icon: Icons.fact_check_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Quick Actions",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 18),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.95,

                children: [
                  dashboardCard(
                    context: context,
                    title: "Start Attendance",
                    icon: Icons.play_circle_fill_rounded,
                    color: Colors.blue,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AttendanceSetupScreen(),
                        ),
                      );

                      loadAttendance();
                    },
                  ),
                  dashboardCard(
                    context: context,
                    title: "Profile",
                    icon: Icons.account_circle_rounded,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TeacherProfileScreen(),
                        ),
                      );
                    },
                  ),


                  dashboardCard(
                    context: context,
                    title: "Attendance",
                    icon: Icons.assignment_turned_in_rounded,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AttendanceScreen(),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    context: context,
                    title: "Settings",
                    icon: Icons.settings_suggest_rounded,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TeacherSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon 👋";
    } else {
      return "Good Evening 👋";
    }
  }

  Widget dashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),

      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(.15),

                child: Icon(
                  icon,
                  color: color,
                  size: 34,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(.12),

            child: Icon(icon, color: color, size: 28),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
