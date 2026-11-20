class AttendanceModel {
  final String studentName;
  final String enrollment;
  final String date;
  final String time;
  final bool isPresent;

  AttendanceModel({
    required this.studentName,
    required this.enrollment,
    required this.date,
    required this.time,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'enrollment': enrollment,
      'date': date,
      'time': time,
      'isPresent': isPresent,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      studentName: map['studentName'] ?? '',
      enrollment: map['enrollment'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      isPresent: map['isPresent'] ?? false,
    );
  }
}