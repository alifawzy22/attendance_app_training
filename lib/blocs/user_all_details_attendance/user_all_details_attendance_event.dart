import 'package:equatable/equatable.dart';

abstract class UserAllDetailsAttendanceEvent extends Equatable {
  const UserAllDetailsAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends UserAllDetailsAttendanceEvent {}

class FetchTableData extends UserAllDetailsAttendanceEvent {}

class HallNumberChanged extends UserAllDetailsAttendanceEvent {
  final String hallNumber;
  const HallNumberChanged(this.hallNumber);
  @override
  List<Object?> get props => [hallNumber];
}

class AppNameChanged extends UserAllDetailsAttendanceEvent {
  final String appName;
  const AppNameChanged(this.appName);
  @override
  List<Object?> get props => [appName];
}

class TrainingNumberChanged extends UserAllDetailsAttendanceEvent {
  final String trainingNumber;
  const TrainingNumberChanged(this.trainingNumber);
  @override
  List<Object?> get props => [trainingNumber];
}

class FromDateChanged extends UserAllDetailsAttendanceEvent {
  final DateTime? date;
  const FromDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class ToDateChanged extends UserAllDetailsAttendanceEvent {
  final DateTime? date;
  const ToDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class AttendanceDateChanged extends UserAllDetailsAttendanceEvent {
  final DateTime? date;
  const AttendanceDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class NationalIdChanged extends UserAllDetailsAttendanceEvent {
  final String nationalId;
  const NationalIdChanged(this.nationalId);
  @override
  List<Object?> get props => [nationalId];
}

class ResetDates extends UserAllDetailsAttendanceEvent {}

class ColumnVisibilityChanged extends UserAllDetailsAttendanceEvent {
  final String column;
  final bool visible;
  const ColumnVisibilityChanged(this.column, this.visible);
  @override
  List<Object?> get props => [column, visible];
}
