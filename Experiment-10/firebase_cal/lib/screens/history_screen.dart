import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference history = FirebaseFirestore.instance.collection(
      'calculatorHistory',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Calculation History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: history.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("No history yet 😄", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.brown[100],
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    "${data['expression']} = ${data['result']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate().toString()
                        : 'No time recorded',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.calculate_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
