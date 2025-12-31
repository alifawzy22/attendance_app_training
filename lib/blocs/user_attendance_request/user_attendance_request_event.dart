import 'package:equatable/equatable.dart';

abstract class UserAttendanceRequestEvent extends Equatable {
  const UserAttendanceRequestEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends UserAttendanceRequestEvent {}

class SearchAttendance extends UserAttendanceRequestEvent {}

class HallNumberChanged extends UserAttendanceRequestEvent {
  final String? hallNumber;
  const HallNumberChanged(this.hallNumber);

  @override
  List<Object?> get props => [hallNumber];
}

class AppNameChanged extends UserAttendanceRequestEvent {
  final String? appName;
  const AppNameChanged(this.appName);

  @override
  List<Object?> get props => [appName];
}

class TrainingNumberChanged extends UserAttendanceRequestEvent {
  final String? trainingNumber;
  const TrainingNumberChanged(this.trainingNumber);

  @override
  List<Object?> get props => [trainingNumber];
}

class DateChanged extends UserAttendanceRequestEvent {
  final String date;
  const DateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class ColumnVisibilityChanged extends UserAttendanceRequestEvent {
  final String column;
  final bool visible;
  const ColumnVisibilityChanged(this.column, this.visible);

  @override
  List<Object?> get props => [column, visible];
}
