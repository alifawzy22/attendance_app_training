import 'package:equatable/equatable.dart';
import '../../models/filter_data_model.dart';

abstract class UserDetailsInfoState extends Equatable {
  const UserDetailsInfoState();

  @override
  List<Object?> get props => [];
}

class UserDetailsInfoInitial extends UserDetailsInfoState {}

class UserDetailsInfoLoading extends UserDetailsInfoState {}

class UserDetailsInfoLoaded extends UserDetailsInfoState {
  final List<String> hallNumbersList;
  final List<String> appNamesList;
  final List<String> trainingNumbersList;

  final String hallNumber;
  final String appName;
  final String trainingNumber;
  final DateTime? fromDate;
  final DateTime? toDate;

  final List<FilterDataModel> tableList;
  final bool isTableLoading;
  final Map<String, bool> columnVisibility;

  const UserDetailsInfoLoaded({
    required this.hallNumbersList,
    required this.appNamesList,
    required this.trainingNumbersList,
    required this.hallNumber,
    required this.appName,
    required this.trainingNumber,
    this.fromDate,
    this.toDate,
    this.tableList = const [],
    this.isTableLoading = false,
    required this.columnVisibility,
  });

  UserDetailsInfoLoaded copyWith({
    List<String>? hallNumbersList,
    List<String>? appNamesList,
    List<String>? trainingNumbersList,
    String? hallNumber,
    String? appName,
    String? trainingNumber,
    DateTime? fromDate,
    DateTime? toDate,
    List<FilterDataModel>? tableList,
    bool? isTableLoading,
    Map<String, bool>? columnVisibility,
    bool clearDates = false,
  }) {
    return UserDetailsInfoLoaded(
      hallNumbersList: hallNumbersList ?? this.hallNumbersList,
      appNamesList: appNamesList ?? this.appNamesList,
      trainingNumbersList: trainingNumbersList ?? this.trainingNumbersList,
      hallNumber: hallNumber ?? this.hallNumber,
      appName: appName ?? this.appName,
      trainingNumber: trainingNumber ?? this.trainingNumber,
      fromDate: clearDates ? null : (fromDate ?? this.fromDate),
      toDate: clearDates ? null : (toDate ?? this.toDate),
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
        fromDate,
        toDate,
        tableList,
        isTableLoading,
        columnVisibility,
      ];
}

class UserDetailsInfoError extends UserDetailsInfoState {
  final String message;
  const UserDetailsInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
