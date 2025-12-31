import 'package:equatable/equatable.dart';
import '../../models/attendance_model.dart';

abstract class UserAttendanceRegisterState extends Equatable {
  const UserAttendanceRegisterState();

  @override
  List<Object?> get props => [];
}

class UserAttendanceRegisterInitial extends UserAttendanceRegisterState {}

class UserAttendanceRegisterLoading extends UserAttendanceRegisterState {}

class UserAttendanceRegisterLoaded extends UserAttendanceRegisterState {
  final List<String> hallNumbersList;
  final List<String> appNamesList;
  final List<String> trainingNumbersList;
  final String attendaceDate;
  
  // Selection state
  final String? hallNumber;
  final String? appName;
  final String? trainingNumber;

  // Table state
  final List<AttendanceModel> tableList;
  final bool isSearchLoading;
  final bool isUpdateAttendanceLoading;

  // Column visibility
  final Map<String, bool> columnVisibility;

  const UserAttendanceRegisterLoaded({
    required this.hallNumbersList,
    required this.appNamesList,
    required this.trainingNumbersList,
    required this.attendaceDate,
    this.hallNumber,
    this.appName,
    this.trainingNumber,
    this.tableList = const [],
    this.isSearchLoading = false,
    this.isUpdateAttendanceLoading = false,
    required this.columnVisibility,
  });

  UserAttendanceRegisterLoaded copyWith({
    List<String>? hallNumbersList,
    List<String>? appNamesList,
    List<String>? trainingNumbersList,
    String? attendaceDate,
    String? hallNumber,
    String? appName,
    String? trainingNumber,
    List<AttendanceModel>? tableList,
    bool? isSearchLoading,
    bool? isUpdateAttendanceLoading,
    Map<String, bool>? columnVisibility,
  }) {
    return UserAttendanceRegisterLoaded(
      hallNumbersList: hallNumbersList ?? this.hallNumbersList,
      appNamesList: appNamesList ?? this.appNamesList,
      trainingNumbersList: trainingNumbersList ?? this.trainingNumbersList,
      attendaceDate: attendaceDate ?? this.attendaceDate,
      hallNumber: hallNumber ?? this.hallNumber,
      appName: appName ?? this.appName,
      trainingNumber: trainingNumber ?? this.trainingNumber,
      tableList: tableList ?? this.tableList,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isUpdateAttendanceLoading: isUpdateAttendanceLoading ?? this.isUpdateAttendanceLoading,
      columnVisibility: columnVisibility ?? this.columnVisibility,
    );
  }

  @override
  List<Object?> get props => [
        hallNumbersList,
        appNamesList,
        trainingNumbersList,
        attendaceDate,
        hallNumber,
        appName,
        trainingNumber,
        tableList,
        isSearchLoading,
        isUpdateAttendanceLoading,
        columnVisibility,
      ];
}

class UserAttendanceRegisterError extends UserAttendanceRegisterState {
  final String message;
  const UserAttendanceRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserAttendanceRegisterDropdownsEmpty extends UserAttendanceRegisterState {}
