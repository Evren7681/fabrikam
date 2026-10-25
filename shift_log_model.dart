class ShiftLogModel {
  final String id;
  final String? assetId;
  final String? assetCode;
  final String? assetName;
  final String shiftName; // '08:00 - 16:00', '16:00 - 24:00', '24:00 - 08:00'
  final DateTime shiftDate;
  final String operatorName;
  final String department;
  final String generalNotes;
  final String? criticalWarning;
  final String? pendingIssues;

  ShiftLogModel({
    required this.id,
    this.assetId,
    this.assetCode,
    this.assetName,
    required this.shiftName,
    required this.shiftDate,
    required this.operatorName,
    required this.department,
    required this.generalNotes,
    this.criticalWarning,
    this.pendingIssues,
  });
}
