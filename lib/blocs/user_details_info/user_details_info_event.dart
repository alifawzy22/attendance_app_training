import 'package:equatable/equatable.dart';

abstract class UserDetailsInfoEvent extends Equatable {
  const UserDetailsInfoEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends UserDetailsInfoEvent {}

class FetchTableData extends UserDetailsInfoEvent {}

class HallNumberChanged extends UserDetailsInfoEvent {
  final String hallNumber;
  const HallNumberChanged(this.hallNumber);
  @override
  List<Object?> get props => [hallNumber];
}

class AppNameChanged extends UserDetailsInfoEvent {
  final String appName;
  const AppNameChanged(this.appName);
  @override
  List<Object?> get props => [appName];
}

class TrainingNumberChanged extends UserDetailsInfoEvent {
  final String trainingNumber;
  const TrainingNumberChanged(this.trainingNumber);
  @override
  List<Object?> get props => [trainingNumber];
}

class FromDateChanged extends UserDetailsInfoEvent {
  final DateTime? date;
  const FromDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class ToDateChanged extends UserDetailsInfoEvent {
  final DateTime? date;
  const ToDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class ResetDates extends UserDetailsInfoEvent {}

class ColumnVisibilityChanged extends UserDetailsInfoEvent {
  final String column;
  final bool visible;
  const ColumnVisibilityChanged(this.column, this.visible);
  @override
  List<Object?> get props => [column, visible];
}
