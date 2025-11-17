import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants/app_constants.dart';

class PdfService {
  // Generate attendance report
  static Future<void> generateAttendanceReport({
    required String studentName,
    required String rollNo,
    required String className,
    required double percentage,
    required int present,
    required int absent,
    required int late,
    required int total,
    required Map<String, dynamic> subjectWise,
    required List<Map<String, dynamic>> recentAttendance,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          _buildHeader(studentName, rollNo, className),
          pw.SizedBox(height: 20),

          // Overall Stats
          _buildOverallStats(percentage, present, absent, late, total),
          pw.SizedBox(height: 20),

          // Subject-wise breakdown
          _buildSubjectWiseTable(subjectWise),
          pw.SizedBox(height: 20),

          // Recent attendance
          _buildRecentAttendanceTable(recentAttendance),
          pw.SizedBox(height: 20),

          // Footer
          _buildFooter(),
        ],
      ),
    );

    // Save and share PDF
    await _savePdf(pdf, 'attendance_report.pdf');
  }

  static pw.Widget _buildHeader(String name, String rollNo, String className) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Attendance Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 2),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Student Name: $name',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 4),
                pw.Text('Roll No: $rollNo', style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 4),
                pw.Text('Class: $className', style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Generated On:', style: const pw.TextStyle(fontSize: 12)),
                pw.Text(
                  DateTime.now().toString().split(' ')[0],
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildOverallStats(
    double percentage,
    int present,
    int absent,
    int late,
    int total,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Overall Attendance Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox(
                'Percentage',
                '${percentage.toStringAsFixed(1)}%',
                PdfColors.blue,
              ),
              _buildStatBox('Present', '$present', PdfColors.green),
              _buildStatBox('Absent', '$absent', PdfColors.red),
              _buildStatBox('Late', '$late', PdfColors.orange),
              _buildStatBox('Total', '$total', PdfColors.grey800),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatBox(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildSubjectWiseTable(Map<String, dynamic> subjectWise) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Subject-wise Attendance',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildTableCell('Subject', isHeader: true),
                _buildTableCell('Present', isHeader: true),
                _buildTableCell('Absent', isHeader: true),
                _buildTableCell('Total', isHeader: true),
                _buildTableCell('Percentage', isHeader: true),
              ],
            ),
            // Data rows
            ...subjectWise.entries.map((entry) {
              final subject = entry.value;
              return pw.TableRow(
                children: [
                  _buildTableCell(subject['subjectName']),
                  _buildTableCell('${subject['present']}'),
                  _buildTableCell('${subject['absent']}'),
                  _buildTableCell('${subject['total']}'),
                  _buildTableCell(
                    '${subject['percentage'].toStringAsFixed(1)}%',
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRecentAttendanceTable(
    List<Map<String, dynamic>> recentAttendance,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Recent Attendance Records',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildTableCell('Date', isHeader: true),
                _buildTableCell('Subject', isHeader: true),
                _buildTableCell('Status', isHeader: true),
                _buildTableCell('Teacher', isHeader: true),
              ],
            ),
            // Data rows
            ...recentAttendance.take(10).map((record) {
              return pw.TableRow(
                children: [
                  _buildTableCell(record['date'] ?? ''),
                  _buildTableCell(record['subject'] ?? ''),
                  _buildTableCell(record['status'] ?? ''),
                  _buildTableCell(record['teacher'] ?? ''),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          'Generated by ${AppConstants.appName}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        ),
        pw.Text(
          'This is an auto-generated report',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
        ),
      ],
    );
  }

  // Save PDF to device
  static Future<void> _savePdf(pw.Document pdf, String filename) async {
    try {
      // For mobile - save and open
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$filename');
      await file.writeAsBytes(await pdf.save());

      // Open the PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: filename);
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }

  // Generate class report for teachers
  static Future<void> generateClassReport({
    required String className,
    required String subjectName,
    required DateTime date,
    required int totalStudents,
    required int present,
    required int absent,
    required int late,
    required List<Map<String, dynamic>> studentList,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Text(
            'Class Attendance Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 10),

          // Class info
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Class: $className',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Subject: $subjectName',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Date: ${date.toString().split(' ')[0]}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Stats
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildStatBox('Total', '$totalStudents', PdfColors.grey800),
                _buildStatBox('Present', '$present', PdfColors.green),
                _buildStatBox('Absent', '$absent', PdfColors.red),
                _buildStatBox('Late', '$late', PdfColors.orange),
                _buildStatBox(
                  'Percentage',
                  '${((present / totalStudents) * 100).toStringAsFixed(1)}%',
                  PdfColors.blue,
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Student list
          pw.Text(
            'Student Attendance List',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _buildTableCell('Roll No', isHeader: true),
                  _buildTableCell('Name', isHeader: true),
                  _buildTableCell('Status', isHeader: true),
                ],
              ),
              ...studentList.map((student) {
                return pw.TableRow(
                  children: [
                    _buildTableCell(student['rollNo'] ?? ''),
                    _buildTableCell(student['name'] ?? ''),
                    _buildTableCell(student['status'] ?? ''),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );

    await _savePdf(pdf, 'class_report_${date.toString().split(' ')[0]}.pdf');
  }
}
