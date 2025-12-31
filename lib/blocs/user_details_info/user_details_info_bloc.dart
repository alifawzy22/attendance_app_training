import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/drop_down_changed_model.dart';
import '../../services/home_service.dart';
import 'user_details_info_event.dart';
import 'user_details_info_state.dart';

class UserDetailsInfoBloc extends Bloc<UserDetailsInfoEvent, UserDetailsInfoState> {
  final HomeService homeService;

  UserDetailsInfoBloc({required this.homeService}) : super(UserDetailsInfoInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<FetchTableData>(_onFetchTableData);
    on<HallNumberChanged>(_onHallNumberChanged);
    on<AppNameChanged>(_onAppNameChanged);
    on<TrainingNumberChanged>(_onTrainingNumberChanged);
    on<FromDateChanged>(_onFromDateChanged);
    on<ToDateChanged>(_onToDateChanged);
    on<ResetDates>(_onResetDates);
    on<ColumnVisibilityChanged>(_onColumnVisibilityChanged);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<UserDetailsInfoState> emit,
  ) async {
    emit(UserDetailsInfoLoading());
    try {
      final dropDownsData = await homeService.getDropDownsData();
      if (dropDownsData != null) {
        final hallNumbersList = ['الكل', ...dropDownsData.hallNumbers.map((e) => e.toString())];
        final appNamesList = ['الكل', ...dropDownsData.trainingPrograms];
        final trainingNumbersList = ['الكل', ...dropDownsData.trainingsNumber.map((e) => e.toString())];

        final tableList = await homeService.updateDataTable(dropDownChangedModel: null);

        emit(UserDetailsInfoLoaded(
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
            'رقم الهاتف': true,
            'المنظومة': true,
            'الإيميل': true,
            'تاريخ بداية الدورة': true,
            'تاريخ نهاية الدورة': true,
          },
        ));
      } else {
        emit(const UserDetailsInfoError("Failed to load drop downs"));
      }
    } catch (e) {
      emit(UserDetailsInfoError(e.toString()));
    }
  }

  Future<void> _onFetchTableData(
    FetchTableData event,
    Emitter<UserDetailsInfoState> emit,
  ) async {
    if (state is UserDetailsInfoLoaded) {
      final currentState = state as UserDetailsInfoLoaded;
      emit(currentState.copyWith(isTableLoading: true));
      try {
        final tableList = await homeService.updateDataTable(
          dropDownChangedModel: DropDownChangedModel(
            applicationSystem: currentState.appName == 'الكل' ? null : currentState.appName,
            traninigHall: currentState.hallNumber == 'الكل' ? null : currentState.hallNumber,
            courseNumber: currentState.trainingNumber == 'الكل' ? null : currentState.trainingNumber,
            fromDate: currentState.fromDate,
            toDate: currentState.toDate,
            attendanceDate: null,
            nationalID: null,
          ),
        );
        emit(currentState.copyWith(tableList: tableList, isTableLoading: false));
      } catch (e) {
        emit(currentState.copyWith(isTableLoading: false));
      }
    }
  }

  void _onHallNumberChanged(HallNumberChanged event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      emit((state as UserDetailsInfoLoaded).copyWith(hallNumber: event.hallNumber));
      add(FetchTableData());
    }
  }

  void _onAppNameChanged(AppNameChanged event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      emit((state as UserDetailsInfoLoaded).copyWith(appName: event.appName));
      add(FetchTableData());
    }
  }

  void _onTrainingNumberChanged(TrainingNumberChanged event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      emit((state as UserDetailsInfoLoaded).copyWith(trainingNumber: event.trainingNumber));
      add(FetchTableData());
    }
  }

  void _onFromDateChanged(FromDateChanged event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      emit((state as UserDetailsInfoLoaded).copyWith(fromDate: event.date));
      add(FetchTableData());
    }
  }

  void _onToDateChanged(ToDateChanged event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      emit((state as UserDetailsInfoLoaded).copyWith(toDate: event.date));
      add(FetchTableData());
    }
  }

  void _onResetDates(ResetDates event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      emit((state as UserDetailsInfoLoaded).copyWith(clearDates: true));
      add(FetchTableData());
    }
  }

  void _onColumnVisibilityChanged(ColumnVisibilityChanged event, Emitter<UserDetailsInfoState> emit) {
    if (state is UserDetailsInfoLoaded) {
      final currentState = state as UserDetailsInfoLoaded;
      final newVisibility = Map<String, bool>.from(currentState.columnVisibility);
      newVisibility[event.column] = event.visible;
      emit(currentState.copyWith(columnVisibility: newVisibility));
    }
  }
}
