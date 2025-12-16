class AttendanceModel {
  final String trainingNumber;
  final String hallNumber;
  final String name;
  final String ministryName;
  final String partyName;
  final String alternativeSpecialization;
  final String nationalId;
  final String attendanceDate;
  final String trainingRegistrationId;
  final String applicationSystem;
  final String startDate;
  final String completeDate;
  bool firstPeriod;
  bool secondPeriod;
  String notes;

  AttendanceModel({
    required this.alternativeSpecialization,
    required this.trainingNumber,
    required this.hallNumber,
    required this.name,
    required this.ministryName,
    required this.partyName,
    required this.nationalId,
    required this.attendanceDate,
    required this.trainingRegistrationId,
    required this.applicationSystem,
    required this.startDate,
    required this.completeDate,
    required this.firstPeriod,
    required this.secondPeriod,
    required this.notes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      alternativeSpecialization:
          json['registrationDetails']['alternativeSpecialization'] as String? ??
          '',
      trainingNumber:
          json['registrationDetails']['courseNumber'] as String? ?? '',
      hallNumber: json['registrationDetails']['trainingHall'] as String? ?? '',
      name: json['registrationDetails']['arabicName'] as String? ?? '',
      ministryName: json['registrationDetails']['ministry'] as String? ?? '',
      partyName:
          json['registrationDetails']['alternativeSpecialization'] as String? ??
          '',
      nationalId: json['nationalId'] as String? ?? '',
      firstPeriod: json['morningAttendancePeriod'] as bool? ?? false,
      secondPeriod: json['nightAttendancePeriod'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      attendanceDate: json['attendanceDate'] as String? ?? '',
      trainingRegistrationId: json['trainingRegistrationId'] as String? ?? '',
      applicationSystem:
          json['registrationDetails']['applicationSystem'] as String? ?? '',
      startDate: json['registrationDetails']['startTime'] as String? ?? '',
      completeDate:
          json['registrationDetails']['completionTime'] as String? ?? '',
    );
  }
}
