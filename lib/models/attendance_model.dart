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
  final bool firstPeriod;
  final bool secondPeriod;
  final String notes;

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

  AttendanceModel copyWith({
    String? trainingNumber,
    String? hallNumber,
    String? name,
    String? ministryName,
    String? partyName,
    String? alternativeSpecialization,
    String? nationalId,
    String? attendanceDate,
    String? trainingRegistrationId,
    String? applicationSystem,
    String? startDate,
    String? completeDate,
    bool? firstPeriod,
    bool? secondPeriod,
    String? notes,
  }) {
    return AttendanceModel(
      trainingNumber: trainingNumber ?? this.trainingNumber,
      hallNumber: hallNumber ?? this.hallNumber,
      name: name ?? this.name,
      ministryName: ministryName ?? this.ministryName,
      partyName: partyName ?? this.partyName,
      alternativeSpecialization:
          alternativeSpecialization ?? this.alternativeSpecialization,
      nationalId: nationalId ?? this.nationalId,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      trainingRegistrationId:
          trainingRegistrationId ?? this.trainingRegistrationId,
      applicationSystem: applicationSystem ?? this.applicationSystem,
      startDate: startDate ?? this.startDate,
      completeDate: completeDate ?? this.completeDate,
      firstPeriod: firstPeriod ?? this.firstPeriod,
      secondPeriod: secondPeriod ?? this.secondPeriod,
      notes: notes ?? this.notes,
    );
  }

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
