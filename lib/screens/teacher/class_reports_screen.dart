import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ClassReportsScreen extends StatefulWidget {
  const ClassReportsScreen({super.key});

  @override
  State<ClassReportsScreen> createState() => _ClassReportsScreenState();
}

class _ClassReportsScreenState extends State<ClassReportsScreen> {
  String? _selectedClass;
  String? _selectedSubject;
  final DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Download report
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            _buildFilters(),
            const SizedBox(height: 20),

            // Overall Stats
            _buildOverallStats(),
            const SizedBox(height: 20),

            // Defaulters List
            const Text(
              'Students Below 75%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDefaultersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Class dropdown, Subject dropdown, Date picker
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats() {
    return const Row(
      children: [
        Expanded(
          child: Card(
            color: AppConstants.presentColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.people, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    '45',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Present', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Card(
            color: AppConstants.absentColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.person_off, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Absent', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultersList() {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppConstants.errorColor,
              child: Icon(Icons.warning, color: Colors.white),
            ),
            title: Text('Student ${index + 1}'),
            subtitle: const Text('Roll No: 10${1 + 1}'),
            trailing: const Text(
              '65%',
              style: TextStyle(
                color: AppConstants.errorColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
