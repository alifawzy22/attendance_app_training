import 'package:attendance_app_training/blocs/user_attendance_request/user_attendance_request_bloc.dart';
import 'package:attendance_app_training/blocs/user_attendance_request/user_attendance_request_event.dart';
import 'package:attendance_app_training/blocs/user_attendance_request/user_attendance_request_state.dart';
import 'package:attendance_app_training/services/home_service.dart';
import 'package:attendance_app_training/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'login_view.dart';

class UserAttendaceRequest extends StatelessWidget {
  const UserAttendaceRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserAttendanceRequestBloc(homeService: HomeService())
            ..add(LoadInitialData()),
      child: const UserAttendaceRequestView(),
    );
  }
}

class UserAttendaceRequestView extends StatelessWidget {
  const UserAttendaceRequestView({super.key});

  void _openColumnSelector(BuildContext context) {
    final bloc = context.read<UserAttendanceRequestBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child:
              BlocBuilder<
                UserAttendanceRequestBloc,
                UserAttendanceRequestState
              >(
                buildWhen: (previous, current) =>
                    current is UserAttendanceRequestLoaded &&
                    (previous is! UserAttendanceRequestLoaded ||
                        previous.columnVisibility != current.columnVisibility),
                builder: (context, state) {
                  if (state is! UserAttendanceRequestLoaded) {
                    return const SizedBox();
                  }
                  return AlertDialog(
                    title: const Center(
                      child: Text(
                        'إختيار الأعمدة',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: state.columnVisibility.keys.map((column) {
                          return column == 'م'
                              ? const SizedBox()
                              : CheckboxListTile(
                                  value: state.columnVisibility[column],
                                  title: Text(column),
                                  onChanged: (value) {
                                    context
                                        .read<UserAttendanceRequestBloc>()
                                        .add(
                                          ColumnVisibilityChanged(
                                            column,
                                            value ?? true,
                                          ),
                                        );
                                  },
                                );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  );
                },
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تسجيل حضور التدريب",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[50],
        actions: [
          IconButton(
            onPressed: () async {
              await logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
        leading: IconButton(
          onPressed: () => _openColumnSelector(context),
          icon: const Icon(Icons.remove_red_eye_rounded, color: Colors.black),
        ),
      ),
      body: BlocBuilder<UserAttendanceRequestBloc, UserAttendanceRequestState>(
        builder: (context, state) {
          if (state is UserAttendanceRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserAttendanceRequestDropdownsEmpty) {
            return const Center(
              child: Text(
                'لا توجد بيانات متاحة',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            );
          }

          if (state is UserAttendanceRequestLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 8),
                  const AttendanceFilterHeader(),
                  const SizedBox(height: 8),
                  const AttendanceFilterInputs(),
                  const SizedBox(height: 8),
                  const AttendanceAppFilterHeader(),
                  const SizedBox(height: 8),
                  const AttendanceAppFilterInputs(),
                  const SizedBox(height: 16),
                  const AttendanceTable(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          if (state is UserAttendanceRequestError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class AttendanceFilterHeader extends StatelessWidget {
  const AttendanceFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildHeaderText(context, 'التاريخ'),
        _buildHeaderText(context, 'رقم القاعة'),
        _buildHeaderText(context, 'رقم الدورة'),
      ],
    );
  }

  Widget _buildHeaderText(BuildContext context, String text) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AttendanceFilterInputs extends StatelessWidget {
  const AttendanceFilterInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAttendanceRequestBloc, UserAttendanceRequestState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRequestLoaded &&
          (previous is! UserAttendanceRequestLoaded ||
              previous.attendaceDate != current.attendaceDate ||
              previous.hallNumber != current.hallNumber ||
              previous.trainingNumber != current.trainingNumber ||
              previous.hallNumbersList != current.hallNumbersList ||
              previous.trainingNumbersList != current.trainingNumbersList),
      builder: (context, state) {
        if (state is! UserAttendanceRequestLoaded) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000, 1, 1),
                  lastDate: DateTime(2300, 12, 31),
                  helpText: 'أختر التاريخ',
                  cancelText: 'إلغاء',
                  confirmText: 'موافق',
                  fieldHintText: 'شهر/يوم/سنة',
                  fieldLabelText: 'تاريخ',
                  initialDatePickerMode: DatePickerMode.day,
                  initialEntryMode: DatePickerEntryMode.calendar,
                );
                if (date != null && context.mounted) {
                  final formatted = intl.DateFormat('yyyy-MM-dd').format(date);
                  context.read<UserAttendanceRequestBloc>().add(
                    DateChanged(formatted),
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 45,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                child: Text(state.attendaceDate),
              ),
            ),
            _buildDropdown(
              context,
              state.hallNumber,
              state.hallNumbersList,
              (val) => context.read<UserAttendanceRequestBloc>().add(
                HallNumberChanged(val),
              ),
            ),
            _buildDropdown(
              context,
              state.trainingNumber,
              state.trainingNumbersList,
              (val) => context.read<UserAttendanceRequestBloc>().add(
                TrainingNumberChanged(val),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 45,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: value,
        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Center(
              child: Text(
                e,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class AttendanceAppFilterHeader extends StatelessWidget {
  const AttendanceAppFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.2),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          alignment: Alignment.center,
          child: const Text(
            'أسم التطبيق',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class AttendanceAppFilterInputs extends StatelessWidget {
  const AttendanceAppFilterInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAttendanceRequestBloc, UserAttendanceRequestState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRequestLoaded &&
          (previous is! UserAttendanceRequestLoaded ||
              previous.appName != current.appName ||
              previous.appNamesList != current.appNamesList ||
              previous.isSearchLoading != current.isSearchLoading),
      builder: (context, state) {
        if (state is! UserAttendanceRequestLoaded) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.15,
              child: state.isSearchLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        elevation: 0,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (state.hallNumber == null ||
                            state.trainingNumber == null ||
                            state.appName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                child: Text("يرجى تحديد جميع الحقول"),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          context.read<UserAttendanceRequestBloc>().add(
                            SearchAttendance(),
                          );
                        }
                      },
                      child: const Text(
                        'بحث',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                value: state.appName,
                items: state.appNamesList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Center(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => context
                    .read<UserAttendanceRequestBloc>()
                    .add(AppNameChanged(val)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AttendanceTable extends StatelessWidget {
  const AttendanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAttendanceRequestBloc, UserAttendanceRequestState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRequestLoaded &&
          (previous is! UserAttendanceRequestLoaded ||
              previous.tableList != current.tableList ||
              previous.columnVisibility != current.columnVisibility),
      builder: (context, state) {
        if (state is! UserAttendanceRequestLoaded) return const SizedBox();

        if (state.tableList.isEmpty) {
          return const Center(
            child: Text(
              'لا يوجد بيانات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnSpacing: 30,
              horizontalMargin: 10,
              dividerThickness: 1,
              dataRowMaxHeight: 60,
              headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
              columns: _buildColumns(state.columnVisibility),
              rows: _buildRows(context, state),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns(Map<String, bool> visibility) {
    const columnNames = [
      'م',
      'رقم الدورة',
      'رقم القاعة',
      'الأسم',
      'الوزارة',
      'الجهة',
      'الرقم القومي',
      'فترة أولي',
      'فترة ثانية',
      'ملاحظات',
    ];
    return columnNames
        .where((name) => visibility[name] == true)
        .map(
          (name) => DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(name),
            numeric: name == 'م',
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows(
    BuildContext context,
    UserAttendanceRequestLoaded state,
  ) {
    return state.tableList.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final visibility = state.columnVisibility;

      return DataRow(
        key: ValueKey(item.nationalId),
        color: WidgetStateProperty.resolveWith<Color?>(
          (states) => index.isEven ? Colors.blueGrey[100] : null,
        ),
        cells: [
          if (visibility['م']!) DataCell(Center(child: Text('${index + 1}'))),
          if (visibility['رقم الدورة']!)
            DataCell(Center(child: Text(item.trainingNumber))),
          if (visibility['رقم القاعة']!)
            DataCell(Center(child: Text(item.hallNumber))),
          if (visibility['الأسم']!) DataCell(Center(child: Text(item.name))),
          if (visibility['الوزارة']!)
            DataCell(Center(child: Text(item.ministryName))),
          if (visibility['الجهة']!)
            DataCell(Center(child: Text(item.alternativeSpecialization))),
          if (visibility['الرقم القومي']!)
            DataCell(Center(child: Text(item.nationalId))),
          if (visibility['فترة أولي']!)
            DataCell(
              Checkbox(
                value: item.firstPeriod,
                onChanged:
                    null, // Read-only in Request screen? Original code had val => {}
              ),
            ),
          if (visibility['فترة ثانية']!)
            DataCell(Checkbox(value: item.secondPeriod, onChanged: null)),
          if (visibility['ملاحظات']!)
            DataCell(
              TextFormField(
                initialValue: item.notes.contains('Auto-generated')
                    ? ''
                    : item.notes,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: null,
                textDirection: TextDirection.rtl,
                readOnly: true,
                onChanged: null,
              ),
            ),
        ],
      );
    }).toList();
  }
}
