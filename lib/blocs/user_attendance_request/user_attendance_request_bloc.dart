import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '../../models/drop_down_changed_model.dart';
import '../../services/home_service.dart';
import 'user_attendance_request_event.dart';
import 'user_attendance_request_state.dart';

class UserAttendanceRequestBloc
    extends Bloc<UserAttendanceRequestEvent, UserAttendanceRequestState> {
  final HomeService homeService;

  UserAttendanceRequestBloc({required this.homeService})
      : super(UserAttendanceRequestInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<HallNumberChanged>(_onHallNumberChanged);
    on<AppNameChanged>(_onAppNameChanged);
    on<TrainingNumberChanged>(_onTrainingNumberChanged);
    on<DateChanged>(_onDateChanged);
    on<SearchAttendance>(_onSearchAttendance);
    on<ColumnVisibilityChanged>(_onColumnVisibilityChanged);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<UserAttendanceRequestState> emit,
  ) async {
    emit(UserAttendanceRequestLoading());
    try {
      final dropDownsData = await homeService.getDropDownsData();
      if (dropDownsData != null) {
        final hallNumbersList =
            dropDownsData.hallNumbers.map((e) => e.toString()).toList();
        final appNamesList = dropDownsData.trainingPrograms;
        final trainingNumbersList =
            dropDownsData.trainingsNumber.map((e) => e.toString()).toList();
        final attendaceDate = intl.DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(dropDownsData.date));

        emit(UserAttendanceRequestLoaded(
          hallNumbersList: hallNumbersList,
          appNamesList: appNamesList,
          trainingNumbersList: trainingNumbersList,
          attendaceDate: attendaceDate,
          columnVisibility: const {
            'م': true,
            'رقم الدورة': false,
            'رقم القاعة': false,
            'الأسم': true,
            'الوزارة': false,
            'الجهة': false,
            'الرقم القومي': true,
            'فترة أولي': true,
            'فترة ثانية': true,
            'ملاحظات': true,
          },
        ));
      } else {
        emit(UserAttendanceRequestDropdownsEmpty());
      }
    } catch (e) {
      emit(UserAttendanceRequestError(e.toString()));
    }
  }

  void _onHallNumberChanged(
    HallNumberChanged event,
    Emitter<UserAttendanceRequestState> emit,
  ) {
    if (state is UserAttendanceRequestLoaded) {
      emit((state as UserAttendanceRequestLoaded)
          .copyWith(hallNumber: event.hallNumber));
    }
  }

  void _onAppNameChanged(
    AppNameChanged event,
    Emitter<UserAttendanceRequestState> emit,
  ) {
    if (state is UserAttendanceRequestLoaded) {
      emit((state as UserAttendanceRequestLoaded)
          .copyWith(appName: event.appName));
    }
  }

  void _onTrainingNumberChanged(
    TrainingNumberChanged event,
    Emitter<UserAttendanceRequestState> emit,
  ) {
    if (state is UserAttendanceRequestLoaded) {
      emit((state as UserAttendanceRequestLoaded)
          .copyWith(trainingNumber: event.trainingNumber));
    }
  }

  void _onDateChanged(
    DateChanged event,
    Emitter<UserAttendanceRequestState> emit,
  ) {
    if (state is UserAttendanceRequestLoaded) {
      emit((state as UserAttendanceRequestLoaded)
          .copyWith(attendaceDate: event.date));
    }
  }

  Future<void> _onSearchAttendance(
    SearchAttendance event,
    Emitter<UserAttendanceRequestState> emit,
  ) async {
    if (state is UserAttendanceRequestLoaded) {
      final currentState = state as UserAttendanceRequestLoaded;
      
      if (currentState.hallNumber == null ||
          currentState.trainingNumber == null ||
          currentState.appName == null) {
        return;
      }

      emit(currentState.copyWith(isSearchLoading: true));

      try {
        final attendanceModelList = await homeService.getAttandance(
          dropDownChangedModel: DropDownChangedModel(
            traninigHall: currentState.hallNumber,
            courseNumber: currentState.trainingNumber,
            applicationSystem: currentState.appName,
            fromDate: null,
            toDate: null,
            attendanceDate: DateTime.parse(currentState.attendaceDate),
            nationalID: null,
          ),
        );

        // Specific filter for Request screen
        attendanceModelList.removeWhere(
          (e) => e.firstPeriod == true && e.secondPeriod == true,
        );

        emit(currentState.copyWith(
          tableList: attendanceModelList,
          isSearchLoading: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(isSearchLoading: false));
      }
    }
  }

  void _onColumnVisibilityChanged(
    ColumnVisibilityChanged event,
    Emitter<UserAttendanceRequestState> emit,
  ) {
    if (state is UserAttendanceRequestLoaded) {
      final currentState = state as UserAttendanceRequestLoaded;
      final newVisibility = Map<String, bool>.from(currentState.columnVisibility);
      newVisibility[event.column] = event.visible;
      emit(currentState.copyWith(columnVisibility: newVisibility));
    }
  }
}
