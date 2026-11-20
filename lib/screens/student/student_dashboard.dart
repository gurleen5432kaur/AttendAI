import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../services/student_session.dart';
import 'attendance_pin_screen.dart';
import 'profile_screen.dart';

class StudentDashboard extends StatelessWidget {
const StudentDashboard({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.background,

appBar: AppBar(
elevation: 0,
centerTitle: true,
backgroundColor: Colors.green,
foregroundColor: Colors.white,
title: Text(
"Student Dashboard",
style: GoogleFonts.poppins(
fontWeight: FontWeight.w600,
),
),
),

body: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(20),

child: Column(
children: [

// ================= WELCOME CARD =================

Container(
width: double.infinity,
padding: const EdgeInsets.all(22),

decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xff22C55E),
Color(0xff16A34A),
],
),

borderRadius: BorderRadius.circular(22),

boxShadow: [
BoxShadow(
color: Colors.green.withOpacity(.20),
blurRadius: 12,
offset: const Offset(0, 6),
),
],
),

child: Column(
children: [
const CircleAvatar(
radius: 35,
backgroundColor: Colors.white,

child: Icon(
Icons.person,
color: Colors.green,
size: 38,
),
),

const SizedBox(height: 15),

Text(
"Welcome ${StudentSession.instance.studentName}",
textAlign: TextAlign.center,
style: GoogleFonts.poppins(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize: 24,
),
),

const SizedBox(height: 6),

Text(
"Mark your attendance easily",
style: GoogleFonts.poppins(
color: Colors.white70,
),
),
],
),
),

const SizedBox(height: 22),

// ================= STAT CARDS =================

Row(
children: [
Expanded(
child: statCard(
title: "Attendance",
value: "92%",
icon: Icons.percent,
color: Colors.green,
),
),

const SizedBox(width: 15),

Expanded(
child: statCard(
title: "Present",
value: "46",
icon: Icons.check_circle,
color: Colors.blue,
),
),
],
),

const SizedBox(height: 15),

Row(
children: [
Expanded(
child: statCard(
title: "Absent",
value: "4",
icon: Icons.cancel,
color: Colors.red,
),
),

const SizedBox(width: 15),

Expanded(
child: statCard(
title: "Today",
value: "Present",
icon: Icons.today,
color: Colors.orange,
),
),
],
),

const SizedBox(height: 30),

// ================= QUICK ACTIONS =================
  GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 18,
    mainAxisSpacing: 18,
    childAspectRatio: 0.82,

    children: [
      // ENTER PIN
      dashboardCard(
        context: context,
        icon: Icons.pin,
        title: "Enter PIN",
        color: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AttendancePinScreen(),
            ),
          );
        },
      ),

      // ATTENDANCE
      dashboardCard(
        context: context,
        icon: Icons.history,
        title: "Attendance",
        color: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AttendancePinScreen(),
            ),
          );
        },
      ),

      // PROFILE
      dashboardCard(
        context: context,
        icon: Icons.person,
        title: "Profile",
        color: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
        },
      ),

      // SETTINGS
      dashboardCard(
        context: context,
        icon: Icons.settings,
        title: "Settings",
        color: Colors.purple,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Settings screen coming soon",
              ),
            ),
          );
        },
      ),
    ],
  ),

  const SizedBox(height: 20),

  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.logout),
      label: Text(
        "Logout",
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),
],
),
),
),
);
}
}
// ==========================================================
// DASHBOARD CARD
// ==========================================================

Widget dashboardCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return Card(
    elevation: 6,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(
                icon,
                color: color,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ==========================================================
// STAT CARD
// ==========================================================

Widget statCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}