class CheckBoxAttendanceModel {
  final String nationalId;
  bool morningattendacePeriod;
  bool nightattendacePeriod;
  String notes;
  String date;

  CheckBoxAttendanceModel({
    required this.nationalId,
    required this.morningattendacePeriod,
    required this.nightattendacePeriod,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': nationalId,
      'morningattendacePeriod': morningattendacePeriod,
      'nightattendacePeriod': nightattendacePeriod,
      'notes': notes,
      'attendanceDate': date,
    };
  }
}
