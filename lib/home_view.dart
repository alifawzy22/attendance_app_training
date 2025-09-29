import 'package:attendance_app_training/table_item.dart';
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
  String? date;

  final List<TableItem> _tableItems = [
    TableItem(
      trainingNumber: 1,
      hallNumber: 1,
      name: 'ahmed',
      ministryName: 'وزارة النقل',
      partyName: 'النقل',
      appName: 'PM',
      nationalId: "123457865555",
      morningPeroid: true,
      eveningPeroid: true,
    ),

    TableItem(
      trainingNumber: 1,
      hallNumber: 1,
      name: 'ahmed',
      ministryName: 'وزارة النقل',
      partyName: 'النقل',
      appName: 'PM',
      nationalId: "78578878778",
      morningPeroid: true,
      eveningPeroid: false,
    ),

    TableItem(
      trainingNumber: 1,
      hallNumber: 1,
      name: 'ahmed',
      ministryName: 'وزارة الثقافة',
      partyName: 'الثقافة',
      appName: 'CM',
      nationalId: "89454588765787",
      morningPeroid: false,
      eveningPeroid: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "حضور التدريب",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[50],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(width: 4),
                Expanded(
                  child: ListTile(
                    title: Text("التطبيق"),
                    subtitle: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8),
                      underline: Container(),
                      value: hallNumber,
                      hint: Text("أسم التطبيق"),
                      items: <String>['1', '2', '3', '4', '5']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          appName = newValue;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(child: ListTile()),
                SizedBox(width: 4),
                Expanded(child: ListTile()),
                SizedBox(width: 4),
              ],
            ),

            // Table
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  SingleChildScrollView(
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
                              (Set<WidgetState> states) => Colors.blue[50],
                            ),
                        columns: const [
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'م',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'رقم الدورة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'رقم القاعة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'الأسم',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'الوزارة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'الجهة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'الرقم القومي',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'فترة أولي',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'فترة ثانية',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                        rows: _tableItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>((
                              Set<WidgetState> states,
                            ) {
                              // Zebra striping for better readability
                              return index.isEven ? Colors.blueGrey[100] : null;
                            }),
                            cells: [
                              // Column 1: Index (based on list position)
                              DataCell(
                                Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              // Column 2: ID (Number)
                              DataCell(
                                Center(
                                  child: Text(
                                    item.trainingNumber.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              // Column 3: Price (Number)
                              DataCell(
                                Center(
                                  child: Text(
                                    '${item.hallNumber}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              // Column 4: Name (String)
                              DataCell(
                                Center(
                                  child: Text(
                                    item.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              // Column 5: Category (String)
                              DataCell(
                                Center(
                                  child: Text(
                                    item.ministryName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              // Column 6: Description (String)
                              DataCell(
                                Center(
                                  child: Text(
                                    item.partyName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    item.nationalId,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),

                              DataCell(
                                Checkbox(
                                  value: item.morningPeroid,
                                  onChanged: (value) {
                                    setState(() {
                                      item.morningPeroid = value ?? false;
                                    });
                                  },
                                ),
                              ),

                              DataCell(
                                Checkbox(
                                  value: item.eveningPeroid,
                                  onChanged: (value) {
                                    setState(() {
                                      item.eveningPeroid = value ?? false;
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
                ],
              ),
            ),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'حفظ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
