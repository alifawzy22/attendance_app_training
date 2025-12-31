import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/drop_down_changed_model.dart';
import '../../services/home_service.dart';
import 'user_all_details_attendance_event.dart';
import 'user_all_details_attendance_state.dart';

class UserAllDetailsAttendanceBloc
    extends Bloc<UserAllDetailsAttendanceEvent, UserAllDetailsAttendanceState> {
  final HomeService homeService;

  UserAllDetailsAttendanceBloc({required this.homeService})
      : super(UserAllDetailsAttendanceInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<FetchTableData>(_onFetchTableData);
    on<HallNumberChanged>(_onHallNumberChanged);
    on<AppNameChanged>(_onAppNameChanged);
    on<TrainingNumberChanged>(_onTrainingNumberChanged);
    on<FromDateChanged>(_onFromDateChanged);
    on<ToDateChanged>(_onToDateChanged);
    on<AttendanceDateChanged>(_onAttendanceDateChanged);
    on<NationalIdChanged>(_onNationalIdChanged);
    on<ResetDates>(_onResetDates);
    on<ColumnVisibilityChanged>(_onColumnVisibilityChanged);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<UserAllDetailsAttendanceState> emit,
  ) async {
    emit(UserAllDetailsAttendanceLoading());
    try {
      final dropDownsData = await homeService.getDropDownsData();
      if (dropDownsData != null) {
        final hallNumbersList = ['الكل', ...dropDownsData.hallNumbers.map((e) => e.toString())];
        final appNamesList = ['الكل', ...dropDownsData.trainingPrograms];
        final trainingNumbersList = ['الكل', ...dropDownsData.trainingsNumber.map((e) => e.toString())];

        final tableList = await homeService.getAttandance(dropDownChangedModel: null);

        emit(UserAllDetailsAttendanceLoaded(
          hallNumbersList: hallNumbersList,
          appNamesList: appNamesList,
          trainingNumbersList: trainingNumbersList,
          hallNumber: 'الكل',
          appName: 'الكل',
          trainingNumber: 'الكل',
          tableList: tableList,
          columnVisibility: const {
            'م': true,
            'رقم الدورة': true,
            'رقم القاعة': true,
            'الأسم': true,
            'الوزارة': true,
            'الجهة': true,
            'الرقم القومي': true,
            'المنظومة': true,
            'تاريخ بداية الدورة': true,
            'تاريخ نهاية الدورة': true,
            'تاريخ الحضور': true,
            'فترة أولي': true,
            'فترة ثانية': true,
            'ملاحظات': true,
          },
        ));
      } else {
        emit(const UserAllDetailsAttendanceError("Failed to load drop downs"));
      }
    } catch (e) {
      emit(UserAllDetailsAttendanceError(e.toString()));
    }
  }

  Future<void> _onFetchTableData(
    FetchTableData event,
    Emitter<UserAllDetailsAttendanceState> emit,
  ) async {
    if (state is UserAllDetailsAttendanceLoaded) {
      final currentState = state as UserAllDetailsAttendanceLoaded;
      emit(currentState.copyWith(isTableLoading: true));
      try {
        final tableList = await homeService.getAttandance(
          dropDownChangedModel: DropDownChangedModel(
            applicationSystem: currentState.appName == 'الكل' ? null : currentState.appName,
            traninigHall: currentState.hallNumber == 'الكل' ? null : currentState.hallNumber,
            courseNumber: currentState.trainingNumber == 'الكل' ? null : currentState.trainingNumber,
            fromDate: currentState.fromDate,
            toDate: currentState.toDate,
            attendanceDate: currentState.attendanceDate,
            nationalID: currentState.nationalId,
          ),
        );
        emit(currentState.copyWith(tableList: tableList, isTableLoading: false));
      } catch (e) {
        emit(currentState.copyWith(isTableLoading: false));
      }
    }
  }

  void _onHallNumberChanged(HallNumberChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(hallNumber: event.hallNumber));
      add(FetchTableData());
    }
  }

  void _onAppNameChanged(AppNameChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(appName: event.appName));
      add(FetchTableData());
    }
  }

  void _onTrainingNumberChanged(TrainingNumberChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(trainingNumber: event.trainingNumber));
      add(FetchTableData());
    }
  }

  void _onFromDateChanged(FromDateChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(fromDate: event.date));
      add(FetchTableData());
    }
  }

  void _onToDateChanged(ToDateChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(toDate: event.date));
      add(FetchTableData());
    }
  }

  void _onAttendanceDateChanged(AttendanceDateChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(attendanceDate: event.date));
      add(FetchTableData());
    }
  }

  void _onNationalIdChanged(NationalIdChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(nationalId: event.nationalId));
      add(FetchTableData());
    }
  }

  void _onResetDates(ResetDates event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      emit((state as UserAllDetailsAttendanceLoaded).copyWith(clearDates: true));
      add(FetchTableData());
    }
  }

  void _onColumnVisibilityChanged(ColumnVisibilityChanged event, Emitter<UserAllDetailsAttendanceState> emit) {
    if (state is UserAllDetailsAttendanceLoaded) {
      final currentState = state as UserAllDetailsAttendanceLoaded;
      final newVisibility = Map<String, bool>.from(currentState.columnVisibility);
      newVisibility[event.column] = event.visible;
      emit(currentState.copyWith(columnVisibility: newVisibility));
    }
  }
}
