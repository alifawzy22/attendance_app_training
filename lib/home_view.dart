import 'package:attendance_app_training/models/filter_data_model.dart';
import 'package:attendance_app_training/services/home_service.dart';
import 'package:attendance_app_training/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'login_view.dart';
import 'models/check_box_attendance_model.dart';
import 'models/drop_down_changed_model.dart';

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

  List<String> hallNumbersList = [];
  List<String> appNamesList = [];
  List<String> trainingNumbersList = [];

  bool isDropDwonsAdndTableLoading = true;
  bool isDropDwonsEmpty = false;
  List<FilterDataModel> tableList = [];
  bool isUpdateAttendanceLoading = false;

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
  void initState() {
    HomeService(dio: Dio()).getDropDownsData().then((dropDownsData) {
      if (dropDownsData != null) {
        hallNumbersList = [];
        appNamesList = [];
        trainingNumbersList = [];
        hallNumbersList = dropDownsData.hallNumbers
            .map((e) => e.toString())
            .toList();
        appNamesList = dropDownsData.trainingPrograms;
        trainingNumbersList = dropDownsData.trainingsNumber
            .map((e) => e.toString())
            .toList();

        hallNumbersList.insert(0, 'الكل');
        appNamesList.insert(0, 'الكل');
        trainingNumbersList.insert(0, 'الكل');

        hallNumber = hallNumbersList.first;
        appName = appNamesList.first;
        trainingNumber = trainingNumbersList.first;

        // Fetch Data Table

        HomeService(
          dio: Dio(),
        ).updateDataTable(dropDownChangedModel: null).then((model) {
          tableList = [];
          tableList = model;
          isDropDwonsAdndTableLoading = false;
          setState(() {});
        });
      } else {
        setState(() {
          isDropDwonsAdndTableLoading = false;
          isDropDwonsEmpty = true;
        });
      }
    });
    super.initState();
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
            onPressed: () async {
              await logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
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
      body: isDropDwonsAdndTableLoading
          ? Center(child: CircularProgressIndicator())
          : isDropDwonsEmpty
          ? Center(
              child: Text(
                'لا توجد بيانات متاحة',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        alignment: Alignment.center,
                        child: Text(
                          'التطبيق',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        child: Text(
                          'رقم القاعة',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        child: Text(
                          'رقم الدورة',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,

                        height: appName == 'الكل' ? 35 : 45,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        // app name Dropdown
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          value: appName,
                          items: appNamesList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            appName = value;
                            setState(() {});
                            HomeService(dio: Dio())
                                .updateDataTable(
                                  dropDownChangedModel: DropDownChangedModel(
                                    applicationSystem: appName == 'الكل'
                                        ? null
                                        : appName,
                                    traninigHall: hallNumber == 'الكل'
                                        ? null
                                        : hallNumber,
                                    courseNumber: trainingNumber == 'الكل'
                                        ? null
                                        : trainingNumber,
                                    fromDate: fromDate,
                                    toDate: toDate,
                                  ),
                                )
                                .then((model) {
                                  tableList = [];
                                  tableList = model;
                                  setState(() {});
                                });
                          },
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: appName == 'الكل' ? 35 : 45,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        // hall Number Dropdown
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          value: hallNumber,
                          items: hallNumbersList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            hallNumber = value;
                            setState(() {});
                            HomeService(dio: Dio())
                                .updateDataTable(
                                  dropDownChangedModel: DropDownChangedModel(
                                    applicationSystem: appName == 'الكل'
                                        ? null
                                        : appName,
                                    traninigHall: hallNumber == 'الكل'
                                        ? null
                                        : hallNumber,
                                    courseNumber: trainingNumber == 'الكل'
                                        ? null
                                        : trainingNumber,
                                    fromDate: fromDate,
                                    toDate: toDate,
                                  ),
                                )
                                .then((model) {
                                  tableList = [];
                                  tableList = model;
                                  setState(() {});
                                });
                          },
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: appName == 'الكل' ? 35 : 45,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        // Training Number Dropdown
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          value: trainingNumber,
                          items: trainingNumbersList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            trainingNumber = value;
                            setState(() {});
                            HomeService(dio: Dio())
                                .updateDataTable(
                                  dropDownChangedModel: DropDownChangedModel(
                                    applicationSystem: appName == 'الكل'
                                        ? null
                                        : appName,
                                    traninigHall: hallNumber == 'الكل'
                                        ? null
                                        : hallNumber,
                                    courseNumber: trainingNumber == 'الكل'
                                        ? null
                                        : trainingNumber,
                                    fromDate: fromDate,
                                    toDate: toDate,
                                  ),
                                )
                                .then((model) {
                                  tableList = [];
                                  tableList = model;
                                  setState(() {});
                                });
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'من',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime.now(),
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
                            HomeService(dio: Dio())
                                .updateDataTable(
                                  dropDownChangedModel: DropDownChangedModel(
                                    applicationSystem: appName == 'الكل'
                                        ? null
                                        : appName,
                                    traninigHall: hallNumber == 'الكل'
                                        ? null
                                        : hallNumber,
                                    courseNumber: trainingNumber == 'الكل'
                                        ? null
                                        : trainingNumber,
                                    fromDate: fromDate,
                                    toDate: toDate,
                                  ),
                                )
                                .then((model) {
                                  tableList = [];
                                  tableList = model;
                                  setState(() {});
                                });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                toDate == null
                                    ? 'اختر التاريخ'
                                    : intl.DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(toDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
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
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime.now(),
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
                            HomeService(dio: Dio())
                                .updateDataTable(
                                  dropDownChangedModel: DropDownChangedModel(
                                    applicationSystem: appName == 'الكل'
                                        ? null
                                        : appName,
                                    traninigHall: hallNumber == 'الكل'
                                        ? null
                                        : hallNumber,
                                    courseNumber: trainingNumber == 'الكل'
                                        ? null
                                        : trainingNumber,
                                    fromDate: fromDate,
                                    toDate: toDate,
                                  ),
                                )
                                .then((model) {
                                  tableList = [];
                                  tableList = model;
                                  setState(() {});
                                });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                fromDate == null
                                    ? 'اختر التاريخ'
                                    : intl.DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(fromDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
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
                  tableList.isEmpty
                      ? Center(
                          child: Text(
                            'لا يوجد بيانات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Directionality(
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
                                headingRowColor:
                                    WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) =>
                                          Colors.blue[50],
                                    ),
                                columns: [
                                  if (_columnVisibility['م']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('م'),
                                      numeric: true,
                                    ),
                                  if (_columnVisibility['رقم الدورة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('رقم الدورة'),
                                    ),
                                  if (_columnVisibility['رقم القاعة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('رقم القاعة'),
                                    ),
                                  if (_columnVisibility['الأسم']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('الأسم'),
                                    ),
                                  if (_columnVisibility['الوزارة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('الوزارة'),
                                    ),
                                  if (_columnVisibility['الجهة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('الجهة'),
                                    ),
                                  if (_columnVisibility['الرقم القومي']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('الرقم القومي'),
                                    ),
                                  if (_columnVisibility['فترة أولي']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('فترة أولي'),
                                    ),
                                  if (_columnVisibility['فترة ثانية']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('فترة ثانية'),
                                    ),
                                ],
                                rows: tableList.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;

                                  return DataRow(
                                    color:
                                        WidgetStateProperty.resolveWith<Color?>(
                                          (Set<WidgetState> states) {
                                            return index.isEven
                                                ? Colors.blueGrey[100]
                                                : null;
                                          },
                                        ),
                                    cells: [
                                      if (_columnVisibility['م']!)
                                        DataCell(
                                          Center(child: Text('${index + 1}')),
                                        ),
                                      if (_columnVisibility['رقم الدورة']!)
                                        DataCell(
                                          Center(
                                            child: Text(
                                              '${item.trainingNumber}',
                                            ),
                                          ),
                                        ),
                                      if (_columnVisibility['رقم القاعة']!)
                                        DataCell(
                                          Center(
                                            child: Text('${item.hallNumber}'),
                                          ),
                                        ),
                                      if (_columnVisibility['الأسم']!)
                                        DataCell(
                                          Center(child: Text(item.name)),
                                        ),
                                      if (_columnVisibility['الوزارة']!)
                                        DataCell(
                                          Center(
                                            child: Text(item.ministryName),
                                          ),
                                        ),
                                      if (_columnVisibility['الجهة']!)
                                        DataCell(
                                          Center(child: Text(item.partyName)),
                                        ),
                                      if (_columnVisibility['الرقم القومي']!)
                                        DataCell(
                                          Center(child: Text(item.nationalId)),
                                        ),
                                      if (_columnVisibility['فترة أولي']!)
                                        DataCell(
                                          Checkbox(
                                            value: item.firstPeriod,
                                            onChanged: (val) {
                                              setState(() {
                                                item.firstPeriod = val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                      if (_columnVisibility['فترة ثانية']!)
                                        DataCell(
                                          Checkbox(
                                            value: item.secondPeriod,
                                            onChanged: (val) {
                                              setState(() {
                                                item.secondPeriod =
                                                    val ?? false;
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

                  tableList.isEmpty
                      ? Container()
                      : Center(
                          child: isUpdateAttendanceLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    List<Map<String, dynamic>> checkBoxList =
                                        [];

                                    for (int i = 0; i < tableList.length; i++) {
                                      checkBoxList.add(
                                        CheckBoxAttendanceModel(
                                          nationalId: tableList[i].nationalId,
                                          morningattendacePeriod:
                                              tableList[i].firstPeriod,
                                          nightattendacePeriod:
                                              tableList[i].secondPeriod,
                                        ).toJson(),
                                      );
                                    }

                                    setState(
                                      () => isUpdateAttendanceLoading = true,
                                    );
                                    bool result = await HomeService(dio: Dio())
                                        .updateAttendance(
                                          checkBoxAttendanceList: checkBoxList,
                                        );

                                    if (result) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text('تم الحفظ بنجاح'),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              'حدث خطأ ما، حاول مرة أخرى',
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    setState(
                                      () => isUpdateAttendanceLoading = false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                          0.3,
                                      vertical: 4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'حفظ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                  SizedBox(height: 24),
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
