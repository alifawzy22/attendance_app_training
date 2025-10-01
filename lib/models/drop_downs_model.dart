class DropDownsModel {
  final List<int> trainingsNumber;
  final List<int> hallNumbers;
  final List<String> trainingPrograms;

  DropDownsModel({
    required this.trainingsNumber,
    required this.hallNumbers,
    required this.trainingPrograms,
  });

  factory DropDownsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DropDownsModel(
      trainingsNumber: List<int>.from(data['trainingsNumber']),
      hallNumbers: List<int>.from(data['hallNumbers']),
      trainingPrograms: List<String>.from(data['trainingPrograms']),
    );
  }
}
