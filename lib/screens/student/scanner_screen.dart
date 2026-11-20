import 'package:intl/intl.dart';
import '../../services/student_session.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/app_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isEmpty) return;

    final String? value = barcodes.first.rawValue;

    if (value == null) return;

    if (!value.startsWith("ATTEND_AI|")) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid AttendAI QR Code"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    _isScanned = true;

    controller.stop();

    final attendance = AttendanceModel(
      studentName: StudentSession.instance.studentName,
      enrollment: StudentSession.instance.enrollment,
      date: DateFormat("dd MMM yyyy").format(DateTime.now()),
      time: DateFormat("hh:mm a").format(DateTime.now()),
      isPresent: true,
    );

    await AttendanceService.instance.addAttendance(attendance);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        // ... rest of your existing code ...
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        title: const Icon(Icons.check_circle, color: Colors.green, size: 65),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              "Attendance Marked",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[700]),
            ),
          ],
        ),

        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pop(context);
              },

              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

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
          "QR Scanner",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            "Scan Teacher QR",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Place the QR code inside the frame.",
            style: GoogleFonts.poppins(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),

                child: MobileScanner(
                  controller: controller,

                  onDetect: _onDetect,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.green,
                  size: 32,
                ),

                const SizedBox(height: 8),

                Text(
                  "Scanning automatically...",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Point your camera at the teacher's QR code.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await controller.toggleTorch();
                    },
                    icon: const Icon(Icons.flash_on),
                    label: const Text("Toggle Flash"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
