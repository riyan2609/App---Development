import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class ExcelService {
  // Export attendance to Excel
  static Future<void> exportAttendanceToExcel({
    required String studentName,
    required String rollNo,
    required String className,
    required List<Map<String, dynamic>> attendanceData,
    required Map<String, dynamic> summary,
  }) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Attendance Report'];

    // Header styling
    CellStyle headerStyle = CellStyle(
      bold: true,
      fontSize: 12,
      backgroundColorHex: ExcelColor.fromHexString('#4A90E2'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    // Title
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('E1'));
    var titleCell = sheet.cell(CellIndex.indexByString('A1'));
    titleCell.value = TextCellValue('Attendance Report');
    titleCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Student Info
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Student Name:');
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(studentName);
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Roll No:');
    sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue(rollNo);
    sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue('Class:');
    sheet.cell(CellIndex.indexByString('B5')).value = TextCellValue(className);

    // Summary
    sheet.cell(CellIndex.indexByString('D3')).value = TextCellValue('Overall Percentage:');
    sheet.cell(CellIndex.indexByString('E3')).value = TextCellValue('${summary['percentage']}%');
    sheet.cell(CellIndex.indexByString('D4')).value = TextCellValue('Present:');
    sheet.cell(CellIndex.indexByString('E4')).value = IntCellValue(summary['present'] as int);
    sheet.cell(CellIndex.indexByString('D5')).value = TextCellValue('Absent:');
    sheet.cell(CellIndex.indexByString('E5')).value = IntCellValue(summary['absent'] as int);

    // Headers
    int headerRow = 7;
    var headers = ['Date', 'Subject', 'Status', 'Teacher', 'Time'];
    for (int i = 0; i < headers.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: headerRow));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Data
    int dataStartRow = headerRow + 1;
    for (int i = 0; i < attendanceData.length; i++) {
      var record = attendanceData[i];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: dataStartRow + i)).value = TextCellValue(record['date'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: dataStartRow + i)).value = TextCellValue(record['subject'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: dataStartRow + i)).value = TextCellValue(record['status'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: dataStartRow + i)).value = TextCellValue(record['teacher'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: dataStartRow + i)).value = TextCellValue(record['time'] as String);
      
      // Color code status
      var statusCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: dataStartRow + i));
      if (record['status'] == 'Present') {
        statusCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#D4EDDA'));
      } else if (record['status'] == 'Absent') {
        statusCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#F8D7DA'));
      } else if (record['status'] == 'Late') {
        statusCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#FFF3CD'));
      }
    }

    // Auto-fit columns
    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 20);
    }

    // Save file
    await _saveExcel(excel, 'attendance_report.xlsx');
  }

  // Export class report to Excel (for teachers)
  static Future<void> exportClassReportToExcel({
    required String className,
    required String subjectName,
    required DateTime date,
    required List<Map<String, dynamic>> studentList,
    required Map<String, int> summary,
  }) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Class Report'];

    // Header styling
    CellStyle headerStyle = CellStyle(
      bold: true,
      fontSize: 12,
      backgroundColorHex: ExcelColor.fromHexString('#4A90E2'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    // Title
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
    var titleCell = sheet.cell(CellIndex.indexByString('A1'));
    titleCell.value = TextCellValue('Class Attendance Report');
    titleCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Class Info
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Class:');
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(className);
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Subject:');
    sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue(subjectName);
    sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue('Date:');
    sheet.cell(CellIndex.indexByString('B5')).value = TextCellValue(date.toString().split(' ')[0]);

    // Summary
    sheet.cell(CellIndex.indexByString('D3')).value = TextCellValue('Total Students:');
    sheet.cell(CellIndex.indexByString('E3')).value = IntCellValue(summary['total'] as int);
    sheet.cell(CellIndex.indexByString('D4')).value = TextCellValue('Present:');
    sheet.cell(CellIndex.indexByString('E4')).value = IntCellValue(summary['present'] as int);
    sheet.cell(CellIndex.indexByString('D5')).value = TextCellValue('Absent:');
    sheet.cell(CellIndex.indexByString('E5')).value = IntCellValue(summary['absent'] as int);

    // Headers
    int headerRow = 7;
    var headers = ['Roll No', 'Student Name', 'Status', 'Remarks'];
    for (int i = 0; i < headers.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: headerRow));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Data
    int dataStartRow = headerRow + 1;
    for (int i = 0; i < studentList.length; i++) {
      var student = studentList[i];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: dataStartRow + i)).value = TextCellValue(student['rollNo'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: dataStartRow + i)).value = TextCellValue(student['name'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: dataStartRow + i)).value = TextCellValue(student['status'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: dataStartRow + i)).value = TextCellValue((student['remarks'] as String?) ?? '');
      
      // Color code status
      var statusCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: dataStartRow + i));
      if (student['status'] == 'Present') {
        statusCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#D4EDDA'));
      } else if (student['status'] == 'Absent') {
        statusCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#F8D7DA'));
      } else if (student['status'] == 'Late') {
        statusCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#FFF3CD'));
      }
    }

    // Auto-fit columns
    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 20);
    }

    // Save file
    await _saveExcel(excel, 'class_report_${date.toString().split(' ')[0]}.xlsx');
  }

  // Export defaulters list
  static Future<void> exportDefaultersToExcel({
    required String className,
    required List<Map<String, dynamic>> defaultersList,
  }) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Defaulters List'];

    // Header styling
    CellStyle headerStyle = CellStyle(
      bold: true,
      fontSize: 12,
      backgroundColorHex: ExcelColor.fromHexString('#DC3545'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    // Title
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('E1'));
    var titleCell = sheet.cell(CellIndex.indexByString('A1'));
    titleCell.value = TextCellValue('Defaulters List - Below 75%');
    titleCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Class Info
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Class:');
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(className);
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Generated On:');
    sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue(DateTime.now().toString().split(' ')[0]);

    // Headers
    int headerRow = 6;
    var headers = ['Roll No', 'Student Name', 'Percentage', 'Present', 'Absent', 'Total'];
    for (int i = 0; i < headers.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: headerRow));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Data
    int dataStartRow = headerRow + 1;
    for (int i = 0; i < defaultersList.length; i++) {
      var student = defaultersList[i];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: dataStartRow + i)).value = TextCellValue(student['rollNo'] as String);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: dataStartRow + i)).value = TextCellValue(student['name'] as String);
      
      var percentageCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: dataStartRow + i));
      percentageCell.value = TextCellValue('${student['percentage']}%');
      
      // Color code based on severity
      double percentage = double.parse(student['percentage'].toString());
      if (percentage < 65) {
        percentageCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#F8D7DA'), fontColorHex: ExcelColor.fromHexString('#721C24'));
      } else {
        percentageCell.cellStyle = CellStyle(backgroundColorHex: ExcelColor.fromHexString('#FFF3CD'), fontColorHex: ExcelColor.fromHexString('#856404'));
      }
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: dataStartRow + i)).value = IntCellValue(student['present'] as int);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: dataStartRow + i)).value = IntCellValue(student['absent'] as int);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: dataStartRow + i)).value = IntCellValue(student['total'] as int);
    }

    // Auto-fit columns
    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 18);
    }

    // Save file
    await _saveExcel(excel, 'defaulters_list.xlsx');
  }

  // Save Excel file
  static Future<void> _saveExcel(Excel excel, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename';
      
      File file = File(path);
      List<int>? bytes = excel.encode();
      
      await file.writeAsBytes(bytes!);
      
      // Open the file
      await OpenFile.open(path);
      
      print('Excel file saved at: $path');
        } catch (e) {
      print('Error saving Excel file: $e');
    }
  }
}
