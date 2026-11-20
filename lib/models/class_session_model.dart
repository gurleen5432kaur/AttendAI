class ClassSessionModel {
  final String teacherName;
  final String subject;
  final String semester;
  final String section;
  final String periods;

  ClassSessionModel({
    required this.teacherName,
    required this.subject,
    required this.semester,
    required this.section,
    required this.periods,
  });

  Map<String, dynamic> toMap() {
    return {
      "teacherName": teacherName,
      "subject": subject,
      "semester": semester,
      "section": section,
      "periods": periods,
    };
  }

  factory ClassSessionModel.fromMap(Map<String, dynamic> map) {
    return ClassSessionModel(
      teacherName: map["teacherName"] ?? "",
      subject: map["subject"] ?? "",
      semester: map["semester"] ?? "",
      section: map["section"] ?? "",
      periods: map["periods"] ?? "",
    );
  }
}