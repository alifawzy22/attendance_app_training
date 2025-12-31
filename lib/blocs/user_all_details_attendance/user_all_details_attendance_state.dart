import 'package:equatable/equatable.dart';
import '../../models/attendance_model.dart';

abstract class UserAllDetailsAttendanceState extends Equatable {
  const UserAllDetailsAttendanceState();

  @override
  List<Object?> get props => [];
}

class UserAllDetailsAttendanceInitial extends UserAllDetailsAttendanceState {}

class UserAllDetailsAttendanceLoading extends UserAllDetailsAttendanceState {}

class UserAllDetailsAttendanceLoaded extends UserAllDetailsAttendanceState {
  final List<String> hallNumbersList;
  final List<String> appNamesList;
  final List<String> trainingNumbersList;

  final String hallNumber;
  final String appName;
  final String trainingNumber;
  final String? nationalId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime? attendanceDate;

  final List<AttendanceModel> tableList;
  final bool isTableLoading;
  final Map<String, bool> columnVisibility;

  const UserAllDetailsAttendanceLoaded({
    required this.hallNumbersList,
    required this.appNamesList,
    required this.trainingNumbersList,
    required this.hallNumber,
    required this.appName,
    required this.trainingNumber,
    this.nationalId,
    this.fromDate,
    this.toDate,
    this.attendanceDate,
    this.tableList = const [],
    this.isTableLoading = false,
    required this.columnVisibility,
  });

  UserAllDetailsAttendanceLoaded copyWith({
    List<String>? hallNumbersList,
    List<String>? appNamesList,
    List<String>? trainingNumbersList,
    String? hallNumber,
    String? appName,
    String? trainingNumber,
    String? nationalId,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? attendanceDate,
    List<AttendanceModel>? tableList,
    bool? isTableLoading,
    Map<String, bool>? columnVisibility,
    bool clearDates = false,
  }) {
    return UserAllDetailsAttendanceLoaded(
      hallNumbersList: hallNumbersList ?? this.hallNumbersList,
      appNamesList: appNamesList ?? this.appNamesList,
      trainingNumbersList: trainingNumbersList ?? this.trainingNumbersList,
      hallNumber: hallNumber ?? this.hallNumber,
      appName: appName ?? this.appName,
      trainingNumber: trainingNumber ?? this.trainingNumber,
      nationalId: nationalId ?? this.nationalId,
      fromDate: clearDates ? null : (fromDate ?? this.fromDate),
      toDate: clearDates ? null : (toDate ?? this.toDate),
      attendanceDate: clearDates ? null : (attendanceDate ?? this.attendanceDate),
      tableList: tableList ?? this.tableList,
      isTableLoading: isTableLoading ?? this.isTableLoading,
      columnVisibility: columnVisibility ?? this.columnVisibility,
    );
  }

  @override
  List<Object?> get props => [
        hallNumbersList,
        appNamesList,
        trainingNumbersList,
        hallNumber,
        appName,
        trainingNumber,
        nationalId,
        fromDate,
        toDate,
        attendanceDate,
        tableList,
        isTableLoading,
        columnVisibility,
      ];
}

class UserAllDetailsAttendanceError extends UserAllDetailsAttendanceState {
  final String message;
  const UserAllDetailsAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
