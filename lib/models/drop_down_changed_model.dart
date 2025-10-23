class DropDownChangedModel {
  final String? traninigHall;
  final String? courseNumber;
  final String? applicationSystem;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime? attendanceDate;
  final String? nationalID;

  DropDownChangedModel({
    required this.traninigHall,
    required this.courseNumber,
    required this.applicationSystem,
    required this.fromDate,
    required this.toDate,
    required this.attendanceDate,
    required this.nationalID,
  });

  Map<String, dynamic> tojson() => {
    'TrainingHall': traninigHall,
    'CourseNumber': courseNumber,
    'ApplicationSystem': applicationSystem,
    'FromDate': fromDate?.toIso8601String(),
    'ToDate': toDate?.toIso8601String(),
    'AttendanceDate': attendanceDate?.toIso8601String(),
    'NationalId': nationalID,
  };
}
