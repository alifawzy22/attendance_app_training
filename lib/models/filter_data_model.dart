class FilterDataModel {
  final String trainingNumber;
  final String hallNumber;
  final String name;
  final String ministryName;
  final String partyName;
  final String nationalId;
  final String phoneNumber;
  final String applicationSystem;
  final String email;
  final String startDate;
  final String completeDate;
  FilterDataModel({
    required this.trainingNumber,
    required this.hallNumber,
    required this.name,
    required this.ministryName,
    required this.partyName,
    required this.nationalId,
    required this.phoneNumber,
    required this.applicationSystem,
    required this.email,
    required this.startDate,
    required this.completeDate,
  });

  factory FilterDataModel.fromJson(Map<String, dynamic> json) {
    return FilterDataModel(
      trainingNumber: json['courseNumber'] ?? '',
      hallNumber: json['trainingHall'] ?? '',
      name: json['arabicName'] ?? '',
      ministryName: json['ministry'] ?? '',
      partyName: json['alternativeSpecialization'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      applicationSystem: json['applicationSystem'] ?? '',
      email: json['email'] ?? '',
      startDate: json['startTime'] ?? '',
      completeDate: json['completionTime'] ?? '',
    );
  }
}
