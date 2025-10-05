class DropDownChangedModel {
  final String? traninigHall;
  final String? courseNumber;
  final String? applicationSystem;
  final DateTime? fromDate;
  final DateTime? toDate;

  DropDownChangedModel({
    required this.traninigHall,
    required this.courseNumber,
    required this.applicationSystem,
    required this.fromDate,
    required this.toDate,
  });

  tojson() {
    return {
      "TrainingHall": traninigHall,
      "CourseNumber": courseNumber,
      "ApplicationSystem": applicationSystem,
      "FromDate": fromDate?.toIso8601String(),
      "ToDate": toDate?.toIso8601String(),
    };
  }
}
