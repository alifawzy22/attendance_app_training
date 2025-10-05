class CheckBoxAttendanceModel {
  final String nationalId;
  bool morningattendacePeriod;
  bool nightattendacePeriod;

  CheckBoxAttendanceModel({
    required this.nationalId,
    required this.morningattendacePeriod,
    required this.nightattendacePeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': nationalId,
      'morningattendacePeriod': morningattendacePeriod,
      'nightattendacePeriod': nightattendacePeriod,
    };
  }
}
