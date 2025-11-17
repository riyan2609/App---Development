import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants/app_constants.dart';

class AttendanceLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AttendanceLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  return Text(
                    data[value.toInt()]['week'].toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(
                    e.key.toDouble(),
                    e.value['percentage'].toDouble(),
                  ),
                )
                .toList(),
            isCurved: true,
            color: AppConstants.primaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppConstants.primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendancePieChart extends StatelessWidget {
  final int present;
  final int absent;
  final int late;

  const AttendancePieChart({
    super.key,
    required this.present,
    required this.absent,
    required this.late,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: present.toDouble(),
            title: 'Present',
            color: AppConstants.presentColor,
            radius: 50,
          ),
          PieChartSectionData(
            value: absent.toDouble(),
            title: 'Absent',
            color: AppConstants.absentColor,
            radius: 50,
          ),
          PieChartSectionData(
            value: late.toDouble(),
            title: 'Late',
            color: AppConstants.lateColor,
            radius: 50,
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
