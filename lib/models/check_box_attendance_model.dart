class CheckBoxAttendanceModel {
  final String id;
  int attendacePeriod;
  bool morningattendacePeriod;
  bool nightattendacePeriod;

  CheckBoxAttendanceModel({
    required this.id,
    required this.attendacePeriod,
    required this.morningattendacePeriod,
    required this.nightattendacePeriod,
  });

  factory CheckBoxAttendanceModel.fromJson(Map<String, dynamic> json) {
    return CheckBoxAttendanceModel(
      id: json['id'] as String? ?? '',
      attendacePeriod: (json['attendacePeriod'] is int)
          ? json['attendacePeriod'] as int
          : int.tryParse('${json['attendacePeriod']}') ?? 0,
      morningattendacePeriod: json['morningattendacePeriod'] as bool? ?? false,
      nightattendacePeriod: json['nightattendacePeriod'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendacePeriod': attendacePeriod,
      'morningattendacePeriod': morningattendacePeriod,
      'nightattendacePeriod': nightattendacePeriod,
    };
  }
}
