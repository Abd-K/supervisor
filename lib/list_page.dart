import 'package:flutter/material.dart';
import 'package:supervisor/models/orphan.dart';
import 'package:supervisor/orphan_details_page.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from a database or API
    final List<Orphan> orphans = List.generate(10, (index) {
      return Orphan(
        id: 'orphan_$index',
        firstName: 'Orphan',
        fatherName: 'Father',
        familyName: '${index + 1}',
        dateOfBirth: DateTime(2010, 5, 15),
        gender: 'Male',
        nationality: 'Syrian',
        guardianFullName: 'Guardian Name',
        guardianRelationship: 'Uncle',
        guardianIncome: 1500.00,
        institutionName: 'Future Generation School',
        gradeLevel: '5th Grade',
        academicPerformance: 'Good',
        healthStatus: 'Good',
        disabilityType: 'None',
        guardianEducation: 'High School',
        guardianWork: 'Merchant',
        guardianDependents: 3,
        guardianSupport: 300.0,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphans List'),
      ),
      body: ListView.builder(
        itemCount: orphans.length,
        itemBuilder: (context, index) {
          final orphan = orphans[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: const Icon(Icons.child_care, color: Colors.green, size: 40),
              title: Text('${orphan.firstName} ${orphan.familyName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Guardian: ${orphan.guardianFullName}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrphanDetailsPage(orphan: orphan),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
} 