import 'package:attendance_app_training/blocs/user_details_info/user_details_info_bloc.dart';
import 'package:attendance_app_training/blocs/user_details_info/user_details_info_event.dart';
import 'package:attendance_app_training/blocs/user_details_info/user_details_info_state.dart';
import 'package:attendance_app_training/services/home_service.dart';
import 'package:attendance_app_training/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'login_view.dart';

class UserDetailsInfo extends StatelessWidget {
  const UserDetailsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserDetailsInfoBloc(homeService: HomeService())
            ..add(LoadInitialData()),
      child: const UserDetailsInfoView(),
    );
  }
}

class UserDetailsInfoView extends StatelessWidget {
  const UserDetailsInfoView({super.key});

  void _openColumnSelector(BuildContext context) {
    final bloc = context.read<UserDetailsInfoBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: BlocBuilder<UserDetailsInfoBloc, UserDetailsInfoState>(
            buildWhen: (previous, current) =>
                current is UserDetailsInfoLoaded &&
                (previous is! UserDetailsInfoLoaded ||
                    previous.columnVisibility != current.columnVisibility),
            builder: (context, state) {
              if (state is! UserDetailsInfoLoaded) return const SizedBox();
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
                                context.read<UserDetailsInfoBloc>().add(
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
          "إستعلام المتدربين",
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
      body: BlocBuilder<UserDetailsInfoBloc, UserDetailsInfoState>(
        builder: (context, state) {
          if (state is UserDetailsInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDetailsInfoLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 8),
                  const AttendanceFilterHeader(),
                  const SizedBox(height: 8),
                  const AttendanceFilterInputs(),
                  const SizedBox(height: 8),
                  const AttendanceDateFilterHeader(),
                  const SizedBox(height: 8),
                  const AttendanceDateFilterInputs(),
                  const SizedBox(height: 16),
                  const AttendanceTable(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          if (state is UserDetailsInfoError) {
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
        _buildHeaderText(context, 'التطبيق', 0.5),
        _buildHeaderText(context, 'رقم القاعة', 0.2),
        _buildHeaderText(context, 'رقم الدورة', 0.2),
      ],
    );
  }

  Widget _buildHeaderText(
    BuildContext context,
    String text,
    double widthFactor,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * widthFactor,
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
    return BlocBuilder<UserDetailsInfoBloc, UserDetailsInfoState>(
      buildWhen: (previous, current) =>
          current is UserDetailsInfoLoaded &&
          (previous is! UserDetailsInfoLoaded ||
              previous.appName != current.appName ||
              previous.hallNumber != current.hallNumber ||
              previous.trainingNumber != current.trainingNumber),
      builder: (context, state) {
        if (state is! UserDetailsInfoLoaded) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDropdown(
              context,
              state.appName,
              state.appNamesList,
              0.5,
              (val) =>
                  context.read<UserDetailsInfoBloc>().add(AppNameChanged(val!)),
            ),
            _buildDropdown(
              context,
              state.hallNumber,
              state.hallNumbersList,
              0.2,
              (val) => context.read<UserDetailsInfoBloc>().add(
                HallNumberChanged(val!),
              ),
            ),
            _buildDropdown(
              context,
              state.trainingNumber,
              state.trainingNumbersList,
              0.2,
              (val) => context.read<UserDetailsInfoBloc>().add(
                TrainingNumberChanged(val!),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    String value,
    List<String> items,
    double widthFactor,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * widthFactor,
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
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class AttendanceDateFilterHeader extends StatelessWidget {
  const AttendanceDateFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        AttendanceDateLabel(text: 'إلي'),
        AttendanceDateLabel(text: 'من'),
      ],
    );
  }
}

class AttendanceDateLabel extends StatelessWidget {
  final String text;
  const AttendanceDateLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class AttendanceDateFilterInputs extends StatelessWidget {
  const AttendanceDateFilterInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsInfoBloc, UserDetailsInfoState>(
      buildWhen: (previous, current) =>
          current is UserDetailsInfoLoaded &&
          (previous is! UserDetailsInfoLoaded ||
              previous.fromDate != current.fromDate ||
              previous.toDate != current.toDate),
      builder: (context, state) {
        if (state is! UserDetailsInfoLoaded) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDatePicker(
              context,
              state.toDate,
              'إلي',
              (date) =>
                  context.read<UserDetailsInfoBloc>().add(ToDateChanged(date)),
            ),
            IconButton(
              onPressed: () =>
                  context.read<UserDetailsInfoBloc>().add(ResetDates()),
              icon: const Icon(
                Icons.event_repeat_outlined,
                size: 26,
                color: Color.fromARGB(255, 124, 60, 55),
              ),
            ),
            _buildDatePicker(
              context,
              state.fromDate,
              'من',
              (date) => context.read<UserDetailsInfoBloc>().add(
                FromDateChanged(date),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    DateTime? date,
    String label,
    ValueChanged<DateTime?> onDateSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000, 1, 1),
          lastDate: DateTime(2300, 12, 31),
        );
        if (picked != null && context.mounted) onDateSelected(picked);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  date == null
                      ? 'اختر التاريخ'
                      : intl.DateFormat('yyyy-MM-dd').format(date),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            const Icon(Icons.calendar_month, color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}

class AttendanceTable extends StatelessWidget {
  const AttendanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsInfoBloc, UserDetailsInfoState>(
      buildWhen: (previous, current) =>
          current is UserDetailsInfoLoaded &&
          (previous is! UserDetailsInfoLoaded ||
              previous.tableList != current.tableList ||
              previous.isTableLoading != current.isTableLoading ||
              previous.columnVisibility != current.columnVisibility),
      builder: (context, state) {
        if (state is! UserDetailsInfoLoaded) return const SizedBox();

        if (state.isTableLoading) {
          return const Center(child: CircularProgressIndicator());
        }

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
              columnSpacing: 20,
              horizontalMargin: 10,
              dividerThickness: 1,
              dataRowMinHeight: 60,
              dataRowMaxHeight: double.infinity,
              headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
              columns: _buildColumns(state.columnVisibility),
              rows: _buildRows(state),
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
      'رقم الهاتف',
      'المنظومة',
      'الإيميل',
      'تاريخ بداية الدورة',
      'تاريخ نهاية الدورة',
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

  List<DataRow> _buildRows(UserDetailsInfoLoaded state) {
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
            DataCell(Center(child: Text(item.partyName))),
          if (visibility['الرقم القومي']!)
            DataCell(Center(child: Text(item.nationalId))),
          if (visibility['رقم الهاتف']!)
            DataCell(Center(child: Text(item.phoneNumber))),
          if (visibility['المنظومة']!)
            DataCell(Center(child: Text(item.applicationSystem))),
          if (visibility['الإيميل']!) DataCell(Center(child: Text(item.email))),
          if (visibility['تاريخ بداية الدورة']!)
            DataCell(Center(child: Text(item.startDate))),
          if (visibility['تاريخ نهاية الدورة']!)
            DataCell(Center(child: Text(item.completeDate))),
        ],
      );
    }).toList();
  }
}
