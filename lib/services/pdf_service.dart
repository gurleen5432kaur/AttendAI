import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/attendance_model.dart';

class PdfService {
  static Future<void> generateAttendancePdf(
      List<AttendanceModel> attendanceList) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'AttendAI',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text(
            'Attendance Report',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Text(
            'Generated on: ${DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now())}',
          ),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: const [
              'Student Name',
              'Enrollment',
              'Date',
              'Time',
              'Status',
            ],
            data: attendanceList.map((student) {
              return [
                student.studentName,
                student.enrollment,
                student.date,
                student.time,
                student.isPresent ? 'Present' : 'Absent',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}