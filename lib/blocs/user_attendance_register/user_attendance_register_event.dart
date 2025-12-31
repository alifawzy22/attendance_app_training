import 'package:equatable/equatable.dart';

abstract class UserAttendanceRegisterEvent extends Equatable {
  const UserAttendanceRegisterEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends UserAttendanceRegisterEvent {}

class SearchAttendance extends UserAttendanceRegisterEvent {}

class UpdateAttendance extends UserAttendanceRegisterEvent {}

class HallNumberChanged extends UserAttendanceRegisterEvent {
  final String? hallNumber;
  const HallNumberChanged(this.hallNumber);

  @override
  List<Object?> get props => [hallNumber];
}

class AppNameChanged extends UserAttendanceRegisterEvent {
  final String? appName;
  const AppNameChanged(this.appName);

  @override
  List<Object?> get props => [appName];
}

class TrainingNumberChanged extends UserAttendanceRegisterEvent {
  final String? trainingNumber;
  const TrainingNumberChanged(this.trainingNumber);

  @override
  List<Object?> get props => [trainingNumber];
}

class ColumnVisibilityChanged extends UserAttendanceRegisterEvent {
  final String column;
  final bool visible;
  const ColumnVisibilityChanged(this.column, this.visible);

  @override
  List<Object?> get props => [column, visible];
}

class PeriodToggled extends UserAttendanceRegisterEvent {
  final int index;
  final int period; // 1 or 2
  final bool value;
  const PeriodToggled(this.index, this.period, this.value);

  @override
  List<Object?> get props => [index, period, value];
}

class NotesChanged extends UserAttendanceRegisterEvent {
  final int index;
  final String value;
  const NotesChanged(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}
