import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ServiceReportPdfGenerator {
  static Future<Uint8List> generateServiceReportPdf({
    required String workOrderNumber,
    required String assetCode,
    required String assetName,
    required String location,
    required String technicianName,
    required String failureCategory,
    required String issueDescription,
    required String actionTaken,
    required String fiveWhySummary,
    required int downtimeMinutes,
    required List<Map<String, dynamic>> partsUsed,
  }) async {
    final pdf = pw.Document();

    final nowStr = DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. BAŞLIK & LOGO
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blueGrey900,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'TEKNIK BAKIM & ARIZA MÜDAHALE FORMU',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Saha Servis ve Kök Neden Raporu',
                          style: const pw.TextStyle(color: PdfColors.grey300, fontSize: 10),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'İş Emri No: #$workOrderNumber',
                          style: pw.TextStyle(
                            color: PdfColors.amberAccent,
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Tarih: $nowStr',
                          style: const pw.TextStyle(color: PdfColors.grey300, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // 2. EKİPMAN BİLGİLERİ TABLOSU
              pw.Text('1. EKİPMAN BİLGİLERİ', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.8),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      _th('Ekipman Kodu'),
                      _th('Ekipman / Makine Adı'),
                      _th('Bölüm / Hat'),
                      _th('Arıza Kategorisi'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _td(assetCode),
                      _td(assetName),
                      _td(location),
                      _td(failureCategory.toUpperCase()),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 14),

              // 3. OPERATÖR BİLDİRİMİ VE DURUŞ SÜRESİ
              pw.Text('2. ARIZA TESPİTİ & DURUŞ SÜRESİ', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
              pw.SizedBox(height: 6),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Operatör Bildirimi / İlk Belirti:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.Text('Net Üretim Duruşu: $downtimeMinutes Dakika', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.red800)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(issueDescription, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),

              // 4. UYGULANAN ÇÖZÜM VE KÖK NEDEN (5-WHY)
              pw.Text('3. YAPILAN MÜDAHALE & 5-WHY KÖK NEDEN ANALİZİ', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
              pw.SizedBox(height: 6),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Teknik Müdahale & Uygulanan Çözüm:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    pw.SizedBox(height: 3),
                    pw.Text(actionTaken, style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 8),
                    pw.Text('5-Why Kök Neden Özeti:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.blueGrey900)),
                    pw.SizedBox(height: 3),
                    pw.Text(fiveWhySummary, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),

              // 5. KULLANILAN YEDEK PARÇA VE SARF MALZEMELER
              pw.Text('4. TÜKETİLEN YEDEK PARÇALAR', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
              pw.SizedBox(height: 6),
              if (partsUsed.isEmpty)
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Bu müdahalede yedek parça kullanılmamıştır (Ayar / Temizlik yapıldı).', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                )
              else
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.8),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        _th('Parça Kodu'),
                        _th('Parça Tanımı'),
                        _th('Miktar'),
                        _th('Birim'),
                      ],
                    ),
                    ...partsUsed.map((p) => pw.TableRow(
                          children: [
                            _td(p['part_number'] ?? '-'),
                            _td(p['name'] ?? '-'),
                            _td('${p['quantity']}'),
                            _td(p['unit'] ?? 'Adet'),
                          ],
                        )),
                  ],
                ),

              pw.Spacer(),

              // 6. İMZA VE ONAY ALANI
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Müdahale Eden Teknisyen:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(technicianName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      pw.SizedBox(height: 18),
                      pw.Text('İmza: ...........................................', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Bakım Müdürü / Vardiya Amiri Onayı:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text('Evren Zak (Bakım Müdürü)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      pw.SizedBox(height: 18),
                      pw.Text('İmza: ...........................................', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _th(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.blueGrey900),
      ),
    );
  }

  static pw.Widget _td(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }
}
