import 'package:attendance_app_training/blocs/user_attendance_register/user_attendance_register_bloc.dart';
import 'package:attendance_app_training/blocs/user_attendance_register/user_attendance_register_event.dart';
import 'package:attendance_app_training/blocs/user_attendance_register/user_attendance_register_state.dart';
import 'package:attendance_app_training/services/home_service.dart';
import 'package:attendance_app_training/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_view.dart';

class UserAttendanceRegister extends StatelessWidget {
  const UserAttendanceRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserAttendanceRegisterBloc(homeService: HomeService())
            ..add(LoadInitialData()),
      child: const UserAttendanceRegisterView(),
    );
  }
}

class UserAttendanceRegisterView extends StatelessWidget {
  const UserAttendanceRegisterView({super.key});

  void _openColumnSelector(BuildContext context) {
    final bloc = context.read<UserAttendanceRegisterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child:
              BlocBuilder<
                UserAttendanceRegisterBloc,
                UserAttendanceRegisterState
              >(
                buildWhen: (previous, current) =>
                    current is UserAttendanceRegisterLoaded &&
                    (previous is! UserAttendanceRegisterLoaded ||
                        previous.columnVisibility != current.columnVisibility),
                builder: (context, state) {
                  if (state is! UserAttendanceRegisterLoaded) {
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
                                        .read<UserAttendanceRegisterBloc>()
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
      body:
          BlocConsumer<UserAttendanceRegisterBloc, UserAttendanceRegisterState>(
            listener: (context, state) {
              if (state is UserAttendanceRegisterLoaded &&
                  state.tableList.isEmpty &&
                  !state.isUpdateAttendanceLoading &&
                  !state.isSearchLoading) {
                // Optional logic after save
              }
            },
            builder: (context, state) {
              if (state is UserAttendanceRegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserAttendanceRegisterDropdownsEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد بيانات متاحة',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }

              if (state is UserAttendanceRegisterLoaded) {
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
                      const SizedBox(height: 20),
                      const AttendanceFooter(),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }

              if (state is UserAttendanceRegisterError) {
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
    return BlocBuilder<UserAttendanceRegisterBloc, UserAttendanceRegisterState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRegisterLoaded &&
          (previous is! UserAttendanceRegisterLoaded ||
              previous.attendaceDate != current.attendaceDate ||
              previous.hallNumber != current.hallNumber ||
              previous.trainingNumber != current.trainingNumber ||
              previous.hallNumbersList != current.hallNumbersList ||
              previous.trainingNumbersList != current.trainingNumbersList),
      builder: (context, state) {
        if (state is! UserAttendanceRegisterLoaded) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDateDisplay(context, state.attendaceDate),
            _buildDropdown(
              context,
              state.hallNumber,
              state.hallNumbersList,
              (val) => context.read<UserAttendanceRegisterBloc>().add(
                HallNumberChanged(val),
              ),
            ),
            _buildDropdown(
              context,
              state.trainingNumber,
              state.trainingNumbersList,
              (val) => context.read<UserAttendanceRegisterBloc>().add(
                TrainingNumberChanged(val),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateDisplay(BuildContext context, String date) {
    return Container(
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
      child: Text(date),
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
    return BlocBuilder<UserAttendanceRegisterBloc, UserAttendanceRegisterState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRegisterLoaded &&
          (previous is! UserAttendanceRegisterLoaded ||
              previous.appName != current.appName ||
              previous.appNamesList != current.appNamesList ||
              previous.isSearchLoading != current.isSearchLoading),
      builder: (context, state) {
        if (state is! UserAttendanceRegisterLoaded) return const SizedBox();

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
                          context.read<UserAttendanceRegisterBloc>().add(
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
                    .read<UserAttendanceRegisterBloc>()
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
    return BlocBuilder<UserAttendanceRegisterBloc, UserAttendanceRegisterState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRegisterLoaded &&
          (previous is! UserAttendanceRegisterLoaded ||
              previous.tableList != current.tableList ||
              previous.columnVisibility != current.columnVisibility),
      builder: (context, state) {
        if (state is! UserAttendanceRegisterLoaded) return const SizedBox();

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
    UserAttendanceRegisterLoaded state,
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
                onChanged: (val) => context
                    .read<UserAttendanceRegisterBloc>()
                    .add(PeriodToggled(index, 1, val ?? false)),
              ),
            ),
          if (visibility['فترة ثانية']!)
            DataCell(
              Checkbox(
                value: item.secondPeriod,
                onChanged: (val) => context
                    .read<UserAttendanceRegisterBloc>()
                    .add(PeriodToggled(index, 2, val ?? false)),
              ),
            ),
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
                onChanged: (val) => context
                    .read<UserAttendanceRegisterBloc>()
                    .add(NotesChanged(index, val)),
              ),
            ),
        ],
      );
    }).toList();
  }
}

class AttendanceFooter extends StatelessWidget {
  const AttendanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAttendanceRegisterBloc, UserAttendanceRegisterState>(
      buildWhen: (previous, current) =>
          current is UserAttendanceRegisterLoaded &&
          (previous is! UserAttendanceRegisterLoaded ||
              previous.tableList.isEmpty != current.tableList.isEmpty ||
              previous.isUpdateAttendanceLoading !=
                  current.isUpdateAttendanceLoading),
      builder: (context, state) {
        if (state is! UserAttendanceRegisterLoaded || state.tableList.isEmpty) {
          return const SizedBox();
        }

        return Center(
          child: state.isUpdateAttendanceLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => context
                      .read<UserAttendanceRegisterBloc>()
                      .add(UpdateAttendance()),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.3,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'حفظ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
        );
      },
    );
  }
}
