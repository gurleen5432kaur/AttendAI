import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/class_session_model.dart';
import '../../services/attendance_pin_service.dart';

class GenerateQRScreen extends StatefulWidget {
  final ClassSessionModel session;

  const GenerateQRScreen({
    super.key,
    required this.session,
  });

  @override
  State<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  Timer? timer;

  int seconds = 60;
  late String pin;

  @override
  void initState() {
    super.initState();
    generatePin();
  }

  void generatePin() {
    final random = Random();

    pin = (100000 + random.nextInt(900000)).toString();

    // Save the PIN so the student can verify it.
    AttendancePinService.instance.setAttendancePin(
      pin: pin,
      subjectName: widget.session.subject,
      semesterName: widget.session.semester,
      sectionName: widget.session.section,
      periodName: widget.session.periods,
      teacher: widget.session.teacherName,
    );

    seconds = 60;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (seconds <= 1) {
          timer.cancel();

          setState(() {
            seconds = 0;
          });

          // PIN is no longer valid.
          AttendancePinService.instance.clearPin();
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );

    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedDate {
    return DateFormat("EEEE, dd MMM yyyy").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: Text(
          "Attendance PIN",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // CLASS DETAILS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff9B8AFB),
                    Color(0xff7C6CE8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 55,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    widget.session.subject,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Semester ${widget.session.semester}",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),

                  Text(
                    "Section ${widget.session.section}",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),

                  Text(
                    "Period ${widget.session.periods}",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),

                  Text(
                    widget.session.teacherName,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PIN CARD
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Column(
                  children: [
                    Text(
                      "Attendance PIN",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Text(
                        pin,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Ask students to enter this PIN",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "PIN expires in",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "$seconds s",
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: seconds <= 10
                            ? Colors.red
                            : AppColors.primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 18),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: LinearProgressIndicator(
                        value: seconds / 60,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // NEW PIN
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: generatePin,

                icon: const Icon(Icons.refresh),

                label: Text(
                  "Generate New PIN",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryBlue,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Students should enter this PIN before it expires. Attendance will be recorded for the selected subject, semester, section and period.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}