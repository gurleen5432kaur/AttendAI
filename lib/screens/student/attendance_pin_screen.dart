import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_pin_service.dart';
import '../../services/attendance_service.dart';
import '../../services/student_session.dart';

class AttendancePinScreen extends StatefulWidget {
  const AttendancePinScreen({super.key});

  @override
  State<AttendancePinScreen> createState() => _AttendancePinScreenState();
}

class _AttendancePinScreenState extends State<AttendancePinScreen> {
  final TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  Future<void> submitPin() async {
    final enteredPin = pinController.text.trim();

    if (enteredPin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a 6-digit PIN"),
        ),
      );
      return;
    }

    final pinService = AttendancePinService.instance;

    // Check the PIN.
    if (!pinService.verifyPin(enteredPin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid or expired PIN. Please check with your teacher.",
          ),
        ),
      );
      return;
    }

    // Get current student.
    final student = StudentSession.instance;

    // Get current date and time.
    final now = DateTime.now();

    final attendance = AttendanceModel(
      studentName: student.studentName,
      enrollment: student.enrollment,
      date: DateFormat("dd-MM-yyyy").format(now),
      time: DateFormat("hh:mm a").format(now),
      isPresent: true,
    );

    // Save attendance.
    await AttendanceService.instance.addAttendance(attendance);

    // Clear PIN so it cannot be reused.
    pinService.clearPin();

    if (!mounted) return;

    showSuccessDialog();
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Attendance Marked",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          ),

          content: Text(
            "Your attendance has been marked successfully.",
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          "Enter Attendance PIN",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Column(
            children: [
              const SizedBox(height: 30),

              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.pin,
                  size: 60,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Enter Attendance PIN",
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                "Ask your teacher for the 6-digit PIN",
                style: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),

                decoration: InputDecoration(
                  counterText: "",
                  labelText: "6-Digit PIN",
                  hintText: "000000",
                  prefixIcon: const Icon(Icons.lock),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: submitPin,

                  icon: const Icon(Icons.check),

                  label: Text(
                    "MARK ATTENDANCE",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.green,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Enter the PIN displayed by your teacher during the current class.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Student: ${StudentSession.instance.studentName}",
                style: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}