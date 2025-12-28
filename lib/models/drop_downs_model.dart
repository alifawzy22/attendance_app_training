class DropDownsModel {
  final List<String> trainingsNumber;
  final List<String> hallNumbers;
  final List<String> trainingPrograms;
  final String date;

  DropDownsModel({
    required this.trainingsNumber,
    required this.hallNumbers,
    required this.trainingPrograms,
    required this.date,
  });

  factory DropDownsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DropDownsModel(
      trainingsNumber: List<String>.from(data['trainingsNumber']),
      hallNumbers: List<String>.from(data['hallNumbers']),
      trainingPrograms: List<String>.from(data['trainingPrograms']),
      date: data['currentDate'],
    );
  }
}
