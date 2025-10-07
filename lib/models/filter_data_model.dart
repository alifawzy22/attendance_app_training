class FilterDataModel {
  final int trainingNumber;
  final int hallNumber;
  final String name;
  final String ministryName;
  final String partyName;
  final String nationalId;
  bool firstPeriod;
  bool secondPeriod;
  String notes;

  FilterDataModel({
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

  factory FilterDataModel.fromJson(Map<String, dynamic> json) {
    return FilterDataModel(
      trainingNumber: (json['courseNumber'] is int)
          ? json['courseNumber'] as int
          : int.tryParse('${json['courseNumber']}') ?? 0,
      hallNumber: (json['trainingHall'] is int)
          ? json['trainingHall'] as int
          : int.tryParse('${json['trainingHall']}') ?? 0,
      name: json['name'] as String? ?? '',
      ministryName: json['ministry'] as String? ?? '',
      partyName: json['organization'] as String? ?? '',
      nationalId: json['nationalId'] as String? ?? '',
      firstPeriod: json['morningattendacePeriod'] as bool? ?? false,
      secondPeriod: json['nightattendacePeriod'] as bool? ?? false,
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
