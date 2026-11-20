class AttendancePinService {
  AttendancePinService._();

  static final AttendancePinService instance =
  AttendancePinService._();

  String currentPin = '';
  String subject = '';
  String semester = '';
  String section = '';
  String period = '';
  String teacherName = '';

  void setAttendancePin({
    required String pin,
    required String subjectName,
    required String semesterName,
    required String sectionName,
    required String periodName,
    required String teacher,
  }) {
    currentPin = pin;
    subject = subjectName;
    semester = semesterName;
    section = sectionName;
    period = periodName;
    teacherName = teacher;
  }

  bool verifyPin(String enteredPin) {
    return enteredPin == currentPin && currentPin.isNotEmpty;
  }

  void clearPin() {
    currentPin = '';
    subject = '';
    semester = '';
    section = '';
    period = '';
    teacherName = '';
  }
}