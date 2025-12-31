import 'package:equatable/equatable.dart';
import '../../models/attendance_model.dart';

abstract class UserAttendanceRequestState extends Equatable {
  const UserAttendanceRequestState();

  @override
  List<Object?> get props => [];
}

class UserAttendanceRequestInitial extends UserAttendanceRequestState {}

class UserAttendanceRequestLoading extends UserAttendanceRequestState {}

class UserAttendanceRequestLoaded extends UserAttendanceRequestState {
  final List<String> hallNumbersList;
  final List<String> appNamesList;
  final List<String> trainingNumbersList;
  final String attendaceDate;
  
  final String? hallNumber;
  final String? appName;
  final String? trainingNumber;

  final List<AttendanceModel> tableList;
  final bool isSearchLoading;
  final Map<String, bool> columnVisibility;

  const UserAttendanceRequestLoaded({
    required this.hallNumbersList,
    required this.appNamesList,
    required this.trainingNumbersList,
    required this.attendaceDate,
    this.hallNumber,
    this.appName,
    this.trainingNumber,
    this.tableList = const [],
    this.isSearchLoading = false,
    required this.columnVisibility,
  });

  UserAttendanceRequestLoaded copyWith({
    List<String>? hallNumbersList,
    List<String>? appNamesList,
    List<String>? trainingNumbersList,
    String? attendaceDate,
    String? hallNumber,
    String? appName,
    String? trainingNumber,
    List<AttendanceModel>? tableList,
    bool? isSearchLoading,
    Map<String, bool>? columnVisibility,
  }) {
    return UserAttendanceRequestLoaded(
      hallNumbersList: hallNumbersList ?? this.hallNumbersList,
      appNamesList: appNamesList ?? this.appNamesList,
      trainingNumbersList: trainingNumbersList ?? this.trainingNumbersList,
      attendaceDate: attendaceDate ?? this.attendaceDate,
      hallNumber: hallNumber ?? this.hallNumber,
      appName: appName ?? this.appName,
      trainingNumber: trainingNumber ?? this.trainingNumber,
      tableList: tableList ?? this.tableList,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
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
        columnVisibility,
      ];
}

class UserAttendanceRequestError extends UserAttendanceRequestState {
  final String message;
  const UserAttendanceRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserAttendanceRequestDropdownsEmpty extends UserAttendanceRequestState {}
