import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? hallNumber;
  String? appName;
  String? trainingNumber;
  DateTime? fromDate;
  DateTime? toDate;

  // Column names and visibility
  final Map<String, bool> _columnVisibility = {
    'م': true,
    'رقم الدورة': true,
    'رقم القاعة': true,
    'الأسم': true,
    'الوزارة': true,
    'الجهة': true,
    'الرقم القومي': true,
    'فترة أولي': true,
    'فترة ثانية': true,
  };

  // Example table data
  final List<Map<String, dynamic>> _tableItems = [
    {
      'trainingNumber': 101,
      'hallNumber': 5,
      'name': 'محمد علي',
      'ministryName': 'وزارة التعليم',
      'partyName': 'جهة التدريب',
      'nationalId': '123456789',
      'morningPeriod': true,
      'eveningPeriod': false,
    },
    {
      'trainingNumber': 202,
      'hallNumber': 10,
      'name': 'أحمد حسن',
      'ministryName': 'وزارة الصحة',
      'partyName': 'مركز التدريب',
      'nationalId': '987654321',
      'morningPeriod': false,
      'eveningPeriod': true,
    },
  ];

  void _openColumnSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'إختيار الأعمدة',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: _columnVisibility.keys.map((column) {
                    return column == 'م'
                        ? Container()
                        : CheckboxListTile(
                            value: _columnVisibility[column],
                            title: Text(column),
                            onChanged: (value) {
                              // Update both dialog state and main widget state
                              setStateDialog(() {
                                _columnVisibility[column] = value ?? true;
                              });
                              setState(() {}); // rebuild the table as well
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "حضور التدريب",
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
            onPressed: () {},
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            _openColumnSelector();
          },
          icon: Icon(Icons.remove_red_eye_rounded, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'التطبيق',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'رقم القاعة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'رقم الدورة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 35,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: hallNumber,
                    items: [
                      DropdownMenuItem(
                        value: '1',

                        alignment: Alignment.center,
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        alignment: Alignment.center,
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        alignment: Alignment.center,
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      hallNumber = value;
                      setState(() {});
                    },
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 35,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: appName,
                    items: [
                      DropdownMenuItem(
                        value: 'PM',

                        alignment: Alignment.center,
                        child: Text(
                          'PM',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'CM',
                        alignment: Alignment.center,
                        child: Text(
                          'CM',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'HR',
                        alignment: Alignment.center,
                        child: Text(
                          'HR',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      appName = value;
                      setState(() {});
                    },
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 35,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: trainingNumber,
                    items: [
                      DropdownMenuItem(
                        value: '1',

                        alignment: Alignment.center,
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        alignment: Alignment.center,
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        alignment: Alignment.center,
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      trainingNumber = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'إلي',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'من',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // to Date
                GestureDetector(
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      helpText: 'أختر التاريخ',
                      cancelText: 'إلغاء',
                      confirmText: 'موافق',
                      fieldHintText: 'شهر/يوم/سنة',
                      fieldLabelText: 'تاريخ',
                      initialDatePickerMode: DatePickerMode.day,
                      initialEntryMode: DatePickerEntryMode.calendar,
                      selectableDayPredicate: (day) {
                        // Disable weekends (Saturday and Sunday)
                        if (day.weekday == DateTime.friday ||
                            day.weekday == DateTime.saturday) {
                          return false;
                        }
                        return true;
                      },
                    ).then((value) {
                      toDate = value;
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          intl.DateFormat(
                            'yyyy-MM-dd',
                          ).format(toDate ?? DateTime.now()),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        CalenderIconButton(
                          valueChange: (value) {
                            toDate = value;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                //From date
                GestureDetector(
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      helpText: 'أختر التاريخ',
                      cancelText: 'إلغاء',
                      confirmText: 'موافق',
                      fieldHintText: 'شهر/يوم/سنة',
                      fieldLabelText: 'تاريخ',
                      initialDatePickerMode: DatePickerMode.day,
                      initialEntryMode: DatePickerEntryMode.calendar,
                      selectableDayPredicate: (day) {
                        // Disable weekends (Saturday and Sunday)
                        if (day.weekday == DateTime.friday ||
                            day.weekday == DateTime.saturday) {
                          return false;
                        }
                        return true;
                      },
                    ).then((value) {
                      fromDate = value;
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          intl.DateFormat(
                            'yyyy-MM-dd',
                          ).format(fromDate ?? DateTime.now()),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        CalenderIconButton(
                          valueChange: (value) {
                            fromDate = value;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Table
            Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    columnSpacing: 30,
                    horizontalMargin: 10,
                    dividerThickness: 1,
                    dataRowMaxHeight: 60,
                    headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) => Colors.blue[50],
                    ),
                    columns: [
                      if (_columnVisibility['م']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('م'),
                          numeric: true,
                        ),
                      if (_columnVisibility['رقم الدورة']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('رقم الدورة'),
                        ),
                      if (_columnVisibility['رقم القاعة']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('رقم القاعة'),
                        ),
                      if (_columnVisibility['الأسم']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('الأسم'),
                        ),
                      if (_columnVisibility['الوزارة']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('الوزارة'),
                        ),
                      if (_columnVisibility['الجهة']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('الجهة'),
                        ),
                      if (_columnVisibility['الرقم القومي']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('الرقم القومي'),
                        ),
                      if (_columnVisibility['فترة أولي']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('فترة أولي'),
                        ),
                      if (_columnVisibility['فترة ثانية']!)
                        const DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text('فترة ثانية'),
                        ),
                    ],
                    rows: _tableItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>((
                          Set<WidgetState> states,
                        ) {
                          return index.isEven ? Colors.blueGrey[100] : null;
                        }),
                        cells: [
                          if (_columnVisibility['م']!)
                            DataCell(Center(child: Text('${index + 1}'))),
                          if (_columnVisibility['رقم الدورة']!)
                            DataCell(
                              Center(child: Text('${item['trainingNumber']}')),
                            ),
                          if (_columnVisibility['رقم القاعة']!)
                            DataCell(
                              Center(child: Text('${item['hallNumber']}')),
                            ),
                          if (_columnVisibility['الأسم']!)
                            DataCell(Center(child: Text(item['name']))),
                          if (_columnVisibility['الوزارة']!)
                            DataCell(Center(child: Text(item['ministryName']))),
                          if (_columnVisibility['الجهة']!)
                            DataCell(Center(child: Text(item['partyName']))),
                          if (_columnVisibility['الرقم القومي']!)
                            DataCell(Center(child: Text(item['nationalId']))),
                          if (_columnVisibility['فترة أولي']!)
                            DataCell(
                              Checkbox(
                                value: item['morningPeriod'],
                                onChanged: (val) {
                                  setState(() {
                                    item['morningPeriod'] = val!;
                                  });
                                },
                              ),
                            ),
                          if (_columnVisibility['فترة ثانية']!)
                            DataCell(
                              Checkbox(
                                value: item['eveningPeriod'],
                                onChanged: (val) {
                                  setState(() {
                                    item['eveningPeriod'] = val!;
                                  });
                                },
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {},
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
                child: Text(
                  'حفظ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalenderIconButton extends StatelessWidget {
  final ValueChanged<DateTime?>? valueChange;
  const CalenderIconButton({super.key, this.valueChange});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          helpText: 'أختر التاريخ',
          cancelText: 'إلغاء',
          confirmText: 'موافق',
          fieldHintText: 'شهر/يوم/سنة',
          fieldLabelText: 'تاريخ',
          initialDatePickerMode: DatePickerMode.day,
          initialEntryMode: DatePickerEntryMode.calendar,
          selectableDayPredicate: (day) {
            // Disable weekends (Saturday and Sunday)
            if (day.weekday == DateTime.friday ||
                day.weekday == DateTime.saturday) {
              return false;
            }
            return true;
          },
        ).then((value) {
          valueChange?.call(value);
        });
      },
      icon: Icon(Icons.calendar_month),
    );
  }
}
