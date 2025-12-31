import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '../../models/attendance_model.dart';
import '../../models/check_box_attendance_model.dart';
import '../../models/drop_down_changed_model.dart';
import '../../services/home_service.dart';
import 'user_attendance_register_event.dart';
import 'user_attendance_register_state.dart';

class UserAttendanceRegisterBloc
    extends Bloc<UserAttendanceRegisterEvent, UserAttendanceRegisterState> {
  final HomeService homeService;

  UserAttendanceRegisterBloc({required this.homeService})
    : super(UserAttendanceRegisterInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<HallNumberChanged>(_onHallNumberChanged);
    on<AppNameChanged>(_onAppNameChanged);
    on<TrainingNumberChanged>(_onTrainingNumberChanged);
    on<SearchAttendance>(_onSearchAttendance);
    on<ColumnVisibilityChanged>(_onColumnVisibilityChanged);
    on<PeriodToggled>(_onPeriodToggled);
    on<NotesChanged>(_onNotesChanged);
    on<UpdateAttendance>(_onUpdateAttendance);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<UserAttendanceRegisterState> emit,
  ) async {
    emit(UserAttendanceRegisterLoading());
    try {
      final dropDownsData = await homeService.getDropDownsData();
      if (dropDownsData != null) {
        final hallNumbersList = dropDownsData.hallNumbers
            .map((e) => e.toString())
            .toList();
        final appNamesList = dropDownsData.trainingPrograms;
        final trainingNumbersList = dropDownsData.trainingsNumber
            .map((e) => e.toString())
            .toList();
        final attendaceDate = intl.DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.parse(dropDownsData.date));

        emit(
          UserAttendanceRegisterLoaded(
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
          ),
        );
      } else {
        emit(UserAttendanceRegisterDropdownsEmpty());
      }
    } catch (e) {
      emit(UserAttendanceRegisterError(e.toString()));
    }
  }

  void _onHallNumberChanged(
    HallNumberChanged event,
    Emitter<UserAttendanceRegisterState> emit,
  ) {
    if (state is UserAttendanceRegisterLoaded) {
      emit(
        (state as UserAttendanceRegisterLoaded).copyWith(
          hallNumber: event.hallNumber,
        ),
      );
    }
  }

  void _onAppNameChanged(
    AppNameChanged event,
    Emitter<UserAttendanceRegisterState> emit,
  ) {
    if (state is UserAttendanceRegisterLoaded) {
      emit(
        (state as UserAttendanceRegisterLoaded).copyWith(
          appName: event.appName,
        ),
      );
    }
  }

  void _onTrainingNumberChanged(
    TrainingNumberChanged event,
    Emitter<UserAttendanceRegisterState> emit,
  ) {
    if (state is UserAttendanceRegisterLoaded) {
      emit(
        (state as UserAttendanceRegisterLoaded).copyWith(
          trainingNumber: event.trainingNumber,
        ),
      );
    }
  }

  Future<void> _onSearchAttendance(
    SearchAttendance event,
    Emitter<UserAttendanceRegisterState> emit,
  ) async {
    if (state is UserAttendanceRegisterLoaded) {
      final currentState = state as UserAttendanceRegisterLoaded;

      if (currentState.hallNumber == null ||
          currentState.trainingNumber == null ||
          currentState.appName == null) {
        // We could emit a specific error state or handle this in UI,
        // but for now let's just do nothing or maybe a temporary message.
        return;
      }

      emit(currentState.copyWith(isSearchLoading: true));

      try {
        // Refresh dropdowns data first as per original logic
        final dropDownsModel = await homeService.getDropDownsData();

        List<String> hallList = currentState.hallNumbersList;
        List<String> appList = currentState.appNamesList;
        List<String> trainingList = currentState.trainingNumbersList;
        String date = currentState.attendaceDate;

        if (dropDownsModel != null) {
          hallList = dropDownsModel.hallNumbers
              .map((e) => e.toString())
              .toList();
          appList = dropDownsModel.trainingPrograms;
          trainingList = dropDownsModel.trainingsNumber
              .map((e) => e.toString())
              .toList();
          date = intl.DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(dropDownsModel.date));
        }

        final attendanceModelList = await homeService.getAttandance(
          dropDownChangedModel: DropDownChangedModel(
            traninigHall: currentState.hallNumber,
            courseNumber: currentState.trainingNumber,
            applicationSystem: currentState.appName,
            fromDate: null,
            toDate: null,
            attendanceDate: DateTime.parse(date),
            nationalID: null,
          ),
        );

        emit(
          currentState.copyWith(
            tableList: attendanceModelList,
            isSearchLoading: false,
            hallNumbersList: hallList,
            appNamesList: appList,
            trainingNumbersList: trainingList,
            attendaceDate: date,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(isSearchLoading: false));
        // Handle error
      }
    }
  }

  void _onColumnVisibilityChanged(
    ColumnVisibilityChanged event,
    Emitter<UserAttendanceRegisterState> emit,
  ) {
    if (state is UserAttendanceRegisterLoaded) {
      final currentState = state as UserAttendanceRegisterLoaded;
      final newVisibility = Map<String, bool>.from(
        currentState.columnVisibility,
      );
      newVisibility[event.column] = event.visible;
      emit(currentState.copyWith(columnVisibility: newVisibility));
    }
  }

  void _onPeriodToggled(
    PeriodToggled event,
    Emitter<UserAttendanceRegisterState> emit,
  ) {
    if (state is UserAttendanceRegisterLoaded) {
      final currentState = state as UserAttendanceRegisterLoaded;
      final newList = List<AttendanceModel>.from(currentState.tableList);
      final item = newList[event.index];

      newList[event.index] = item.copyWith(
        firstPeriod: event.period == 1 ? event.value : item.firstPeriod,
        secondPeriod: event.period == 2 ? event.value : item.secondPeriod,
      );

      emit(currentState.copyWith(tableList: newList));
    }
  }

  void _onNotesChanged(
    NotesChanged event,
    Emitter<UserAttendanceRegisterState> emit,
  ) {
    if (state is UserAttendanceRegisterLoaded) {
      final currentState = state as UserAttendanceRegisterLoaded;
      final newList = List<AttendanceModel>.from(currentState.tableList);
      newList[event.index] = newList[event.index].copyWith(notes: event.value);
      emit(currentState.copyWith(tableList: newList));
    }
  }

  Future<void> _onUpdateAttendance(
    UpdateAttendance event,
    Emitter<UserAttendanceRegisterState> emit,
  ) async {
    if (state is UserAttendanceRegisterLoaded) {
      final currentState = state as UserAttendanceRegisterLoaded;
      emit(currentState.copyWith(isUpdateAttendanceLoading: true));

      try {
        final List<Map<String, dynamic>> checkBoxList = [];
        for (var item in currentState.tableList) {
          checkBoxList.add(
            CheckBoxAttendanceModel(
              nationalId: item.nationalId,
              morningattendacePeriod: item.firstPeriod,
              nightattendacePeriod: item.secondPeriod,
              notes: item.notes,
              date: DateTime.parse(
                currentState.attendaceDate,
              ).toIso8601String(),
            ).toJson(),
          );
        }

        final result = await homeService.updateAttendance(
          checkBoxAttendanceList: checkBoxList,
        );

        if (result) {
          emit(
            currentState.copyWith(
              isUpdateAttendanceLoading: false,
              tableList: [],
            ),
          );
          // Success triggered by tableList being empty in UI listener or similar
        } else {
          emit(currentState.copyWith(isUpdateAttendanceLoading: false));
          // Handle failure
        }
      } catch (e) {
        emit(currentState.copyWith(isUpdateAttendanceLoading: false));
        // Handle error
      }
    }
  }
}
