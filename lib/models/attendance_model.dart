class AttendanceModel {
  final int trainingNumber;
  final int hallNumber;
  final String name;
  final String ministryName;
  final String partyName;
  final String nationalId;
  bool firstPeriod;
  bool secondPeriod;
  String notes;

  AttendanceModel({
    required this.trainingNumber,
    required this.hallNumber,
    required this.name,
    required this.ministryName,
    required this.partyName,
    required this.nationalId,
    required this.firstPeriod,
    required this.secondPeriod,
    required this.notes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      trainingNumber: (json['registrationDetails']['courseNumber'] is int)
          ? json['registrationDetails']['courseNumber'] as int
          : int.tryParse('${json['registrationDetails']['courseNumber']}') ?? 0,
      hallNumber: (json['registrationDetails']['trainingHall'] is int)
          ? json['registrationDetails']['trainingHall'] as int
          : int.tryParse('${json['registrationDetails']['trainingHall']}') ?? 0,
      name: json['registrationDetails']['name'] as String? ?? '',
      ministryName: json['registrationDetails']['ministry'] as String? ?? '',
      partyName: json['registrationDetails']['organization'] as String? ?? '',
      nationalId: json['nationalId'] as String? ?? '',
      firstPeriod: json['morningAttendancePeriod'] as bool? ?? false,
      secondPeriod: json['nightAttendancePeriod'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );
  }

  toJson() {
    return {
      "trainingNumber": trainingNumber,
      "hallNumber": hallNumber,
      "name": name,
      "ministryName": ministryName,
      "partyName": partyName,
      "nationalId": nationalId,
      "firstPeriod": firstPeriod,
      "secondPeriod": secondPeriod,
      "notes": notes,
    };
  }
}
