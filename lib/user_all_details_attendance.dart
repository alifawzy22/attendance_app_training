import 'package:attendance_app_training/models/attendance_model.dart';
import 'package:attendance_app_training/services/home_service.dart';
import 'package:attendance_app_training/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'login_view.dart';
import 'models/drop_down_changed_model.dart';

class UserAllDetailsAttendance extends StatefulWidget {
  const UserAllDetailsAttendance({super.key});

  @override
  State<UserAllDetailsAttendance> createState() =>
      _UserAllDetailsAttendanceState();
}

class _UserAllDetailsAttendanceState extends State<UserAllDetailsAttendance> {
  DateTime? attendanceDate;
  String? hallNumber;
  String? appName;
  String? trainingNumber;
  String? nationalId;
  DateTime? fromDate;
  DateTime? toDate;

  List<String> hallNumbersList = [];
  List<String> appNamesList = [];
  List<String> trainingNumbersList = [];

  bool isDropDwonsAdndTableLoading = true;
  bool isDropDwonsEmpty = false;
  List<AttendanceModel> tableList = [];
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
    'المنظومة': true,
    'تاريخ بداية الدورة': true,
    'تاريخ نهاية الدورة': true,
    'تاريخ الحضور': true,
    'فترة أولي': true,
    'فترة ثانية': true,
    'ملاحظات': true,
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

        HomeService(dio: Dio()).getAttandance(dropDownChangedModel: null).then((
          model,
        ) {
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
          "إستعلام حضور التدريب",
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

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (Route<dynamic> route) => false,
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
                                .getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
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
                                .getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
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
                                .getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
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
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime(2300, 12, 31),
                            helpText: 'أختر التاريخ',
                            cancelText: 'إلغاء',
                            confirmText: 'موافق',
                            fieldHintText: 'شهر/يوم/سنة',
                            fieldLabelText: 'تاريخ',
                            initialDatePickerMode: DatePickerMode.day,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            selectableDayPredicate: (day) {
                              // Disable weekends (Saturday and Sunday)
                              // if (day.weekday == DateTime.friday ||
                              //     day.weekday == DateTime.saturday) {
                              //   return false;
                              // }
                              return true;
                            },
                          );
                          if (date != null) {
                            toDate = date;
                            setState(() {});

                            List<AttendanceModel> filterDataList =
                                await HomeService(dio: Dio()).getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
                                  ),
                                );

                            tableList = [];
                            tableList = filterDataList;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
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
                              Expanded(
                                child: Center(
                                  child: Text(
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
                                ),
                              ),
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            fromDate = null;
                            toDate = null;
                            attendanceDate = null;
                          });
                          HomeService(dio: Dio())
                              .getAttandance(
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
                                  attendanceDate: attendanceDate,
                                  nationalID: nationalId,
                                ),
                              )
                              .then((model) {
                                tableList = [];
                                tableList = model;
                                setState(() {});
                              });
                        },
                        icon: Icon(
                          Icons.event_repeat_outlined,
                          size: 26,
                          color: const Color.fromARGB(255, 124, 60, 55),
                        ),
                      ),
                      //From date
                      GestureDetector(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime(2300, 12, 31),
                            helpText: 'أختر التاريخ',
                            cancelText: 'إلغاء',
                            confirmText: 'موافق',
                            fieldHintText: 'شهر/يوم/سنة',
                            fieldLabelText: 'تاريخ',
                            initialDatePickerMode: DatePickerMode.day,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            selectableDayPredicate: (day) {
                              // Disable weekends (Saturday and Sunday)
                              // if (day.weekday == DateTime.friday ||
                              //     day.weekday == DateTime.saturday) {
                              //   return false;
                              // }
                              return true;
                            },
                          );
                          if (date != null) {
                            fromDate = date;
                            setState(() {});

                            List<AttendanceModel> filterDataList =
                                await HomeService(dio: Dio()).getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
                                  ),
                                );

                            tableList = [];
                            tableList = filterDataList;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
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
                              Expanded(
                                child: Center(
                                  child: Text(
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
                                ),
                              ),
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
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
                          'الرقم القومي',
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
                          'تاريخ الحضور',
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
                      // الرقم القومي
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.46,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) async {
                            nationalId = value;
                            setState(() {});

                            List<AttendanceModel> filterDataList =
                                await HomeService(dio: Dio()).getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
                                  ),
                                );

                            tableList = [];
                            tableList = filterDataList;
                            setState(() {});
                          },
                        ),
                      ),
                      //تاريخ الحضور
                      GestureDetector(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000, 1, 1),
                            lastDate: DateTime(2300, 12, 31),
                            helpText: 'أختر التاريخ',
                            cancelText: 'إلغاء',
                            confirmText: 'موافق',
                            fieldHintText: 'شهر/يوم/سنة',
                            fieldLabelText: 'تاريخ',
                            initialDatePickerMode: DatePickerMode.day,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            selectableDayPredicate: (day) {
                              // Disable weekends (Saturday and Sunday)
                              // if (day.weekday == DateTime.friday ||
                              //     day.weekday == DateTime.saturday) {
                              //   return false;
                              // }
                              return true;
                            },
                          );
                          if (date != null) {
                            attendanceDate = date;
                            setState(() {});

                            List<AttendanceModel> filterDataList =
                                await HomeService(dio: Dio()).getAttandance(
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
                                    attendanceDate: attendanceDate,
                                    nationalID: nationalId,
                                  ),
                                );

                            tableList = [];
                            tableList = filterDataList;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.46,
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
                              Expanded(
                                child: Center(
                                  child: Text(
                                    attendanceDate == null
                                        ? 'اختر التاريخ'
                                        : intl.DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(attendanceDate!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueGrey,
                                ),
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
                                dataRowMinHeight: 60,
                                dataRowMaxHeight: double.infinity,

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
                                  if (_columnVisibility['المنظومة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('المنظومة'),
                                    ),
                                  if (_columnVisibility['تاريخ بداية الدورة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('تاريخ بداية الدورة'),
                                    ),
                                  if (_columnVisibility['تاريخ نهاية الدورة']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('تاريخ نهاية الدورة'),
                                    ),

                                  if (_columnVisibility['تاريخ الحضور']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('تاريخ الحضور'),
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

                                  if (_columnVisibility['ملاحظات']!)
                                    const DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('ملاحظات'),
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
                                            child: Text(item.trainingNumber),
                                          ),
                                        ),
                                      if (_columnVisibility['رقم القاعة']!)
                                        DataCell(
                                          Center(child: Text(item.hallNumber)),
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
                                          Center(
                                            child: Text(
                                              item.alternativeSpecialization,
                                            ),
                                          ),
                                        ),
                                      if (_columnVisibility['الرقم القومي']!)
                                        DataCell(
                                          Center(child: Text(item.nationalId)),
                                        ),
                                      if (_columnVisibility['المنظومة']!)
                                        DataCell(
                                          Center(
                                            child: Text(item.applicationSystem),
                                          ),
                                        ),
                                      if (_columnVisibility['تاريخ بداية الدورة']!)
                                        DataCell(
                                          Center(
                                            child: Text(
                                              intl.DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(
                                                DateTime.parse(item.startDate),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (_columnVisibility['تاريخ نهاية الدورة']!)
                                        DataCell(
                                          Center(
                                            child: Text(
                                              intl.DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(
                                                DateTime.parse(
                                                  item.completeDate,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      if (_columnVisibility['تاريخ الحضور']!)
                                        DataCell(
                                          Center(
                                            child: Text(
                                              intl.DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(
                                                DateTime.parse(
                                                  item.attendanceDate,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      if (_columnVisibility['فترة أولي']!)
                                        DataCell(
                                          Checkbox(
                                            value: item.firstPeriod,
                                            onChanged: (val) {},
                                            //  (val) {
                                            //   setState(() {
                                            //     item.firstPeriod = val ?? false;
                                            //   });
                                            // },
                                          ),
                                        ),
                                      if (_columnVisibility['فترة ثانية']!)
                                        DataCell(
                                          Checkbox(
                                            value: item.secondPeriod,
                                            onChanged: (val) {},
                                            //  (val) {
                                            //   setState(() {
                                            //     item.secondPeriod =
                                            //         val ?? false;
                                            //   });
                                            // },
                                          ),
                                        ),
                                      if (_columnVisibility['ملاحظات']!)
                                        DataCell(
                                          Center(
                                            child: Text(
                                              softWrap: true,
                                              item.notes.contains(
                                                    'Auto-generated',
                                                  )
                                                  ? ''
                                                  : item.notes,
                                              maxLines: null,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
