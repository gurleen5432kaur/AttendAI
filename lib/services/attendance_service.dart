import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import 'database_service.dart';

class AttendanceService extends ChangeNotifier {
  AttendanceService._();

  static final AttendanceService instance = AttendanceService._();

  final List<AttendanceModel> _attendanceList = [];

  List<AttendanceModel> get attendanceList =>
      List.unmodifiable(_attendanceList);

  Future<void> loadAttendance() async {
    _attendanceList.clear();
    _attendanceList.addAll(
      await DatabaseService.instance.getAttendance(),
    );
    notifyListeners();
  }

  Future<void> addAttendance(AttendanceModel attendance) async {
    _attendanceList.insert(0, attendance);

    await DatabaseService.instance.insertAttendance(attendance);

    notifyListeners();
  }

  Future<void> clearAttendance() async {
    _attendanceList.clear();

    await DatabaseService.instance.clearAttendance();

    notifyListeners();
  }
}