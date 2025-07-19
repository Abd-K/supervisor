import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphans List'),
      ),
      body: const Center(
        child: Text(
          'List of orphans will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 