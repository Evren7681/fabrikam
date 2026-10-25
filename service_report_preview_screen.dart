import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'service_report_pdf_generator.dart';

class ServiceReportPreviewScreen extends StatelessWidget {
  final String workOrderNumber;
  final String assetCode;
  final String assetName;
  final String location;
  final String technicianName;
  final String failureCategory;
  final String issueDescription;
  final String actionTaken;
  final String fiveWhySummary;
  final int downtimeMinutes;
  final List<Map<String, dynamic>> partsUsed;

  const ServiceReportPreviewScreen({
    super.key,
    required this.workOrderNumber,
    required this.assetCode,
    required this.assetName,
    required this.location,
    required this.technicianName,
    required this.failureCategory,
    required this.issueDescription,
    required this.actionTaken,
    required this.fiveWhySummary,
    required this.downtimeMinutes,
    required this.partsUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İş Emri #$workOrderNumber Servis Formu'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) => ServiceReportPdfGenerator.generateServiceReportPdf(
          workOrderNumber: workOrderNumber,
          assetCode: assetCode,
          assetName: assetName,
          location: location,
          technicianName: technicianName,
          failureCategory: failureCategory,
          issueDescription: issueDescription,
          actionTaken: actionTaken,
          fiveWhySummary: fiveWhySummary,
          downtimeMinutes: downtimeMinutes,
          partsUsed: partsUsed,
        ),
        canChangeOrientation: false,
        canChangePageFormat: false,
        pdfFileName: 'Servis_Raporu_${assetCode}_WO_$workOrderNumber.pdf',
      ),
    );
  }
}
