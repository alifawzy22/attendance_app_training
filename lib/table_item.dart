class TableItem {
  final int trainingNumber;
  final int hallNumber;
  final String name;
  final String ministryName;
  final String partyName;
  final String appName;
  final String nationalId;
  bool morningPeroid;
  bool eveningPeroid;

  TableItem({
    required this.trainingNumber,
    required this.hallNumber,
    required this.name,
    required this.ministryName,
    required this.partyName,
    required this.appName,
    required this.nationalId,
    required this.morningPeroid,
    required this.eveningPeroid,
  });
}
