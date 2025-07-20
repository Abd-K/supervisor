import 'package:flutter/material.dart';
import 'orphan_form.dart';
import 'orphan_list_view.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.assignment),
            label: const Text('Orphan Form'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrphanFormPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text('Orphans List'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrphanListView()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
} 