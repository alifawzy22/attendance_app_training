class CheckBoxAttendanceModel {
  final String nationalId;
  bool morningattendacePeriod;
  bool nightattendacePeriod;
  String notes;

  CheckBoxAttendanceModel({
    required this.nationalId,
    required this.morningattendacePeriod,
    required this.nightattendacePeriod,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': nationalId,
      'morningattendacePeriod': morningattendacePeriod,
      'nightattendacePeriod': nightattendacePeriod,
      'notes': notes,
      'attendanceDate': DateTime.now().toIso8601String(),
    };
  }
}
