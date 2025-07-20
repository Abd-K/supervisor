import 'package:flutter/material.dart';
import 'package:supervisor/models/orphan.dart';
import 'package:supervisor/orphan_form.dart';

class OrphanDetailsPage extends StatefulWidget {
  final Orphan orphan;

  const OrphanDetailsPage({super.key, required this.orphan});

  @override
  _OrphanDetailsPageState createState() => _OrphanDetailsPageState();
}

class _OrphanDetailsPageState extends State<OrphanDetailsPage> {
  late Orphan _orphan;

  @override
  void initState() {
    super.initState();
    _orphan = widget.orphan;
  }

  void _updateStatus(String newStatus) {
    // In a real app, you would update the status in your database or API.
    // For this example, we'll just update the local state.
    // setState(() {
    //   _orphan.s = newStatus;
    // });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Orphan status updated to $newStatus')),
    );
  }

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Orphan Status'),
          content: const Text('This feature is not yet implemented.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_orphan.firstName} ${_orphan.familyName}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Details',
            onPressed: () async {
              final updatedOrphan = await Navigator.push<Orphan>(
                context,
                MaterialPageRoute(
                  builder: (context) => OrphanFormPage(orphan: _orphan),
                ),
              );
              if (updatedOrphan != null) {
                setState(() {
                  _orphan = updatedOrphan;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.update),
            tooltip: 'Update Status',
            onPressed: _showStatusUpdateDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Personal Information'),
            _buildDetailCard([
              _buildDetailRow('Full Name', '${_orphan.firstName} ${_orphan.fatherName} ${_orphan.familyName}'),
              _buildDetailRow('Date of Birth', '${_orphan.dateOfBirth.toLocal()}'.split(' ')[0]),
              _buildDetailRow('Gender', _orphan.gender),
              _buildDetailRow('Nationality', _orphan.nationality ?? 'N/A'),
            ]),
            _buildSectionTitle('Guardian Information'),
            _buildDetailCard([
              _buildDetailRow('Guardian Name', _orphan.guardianFullName),
              _buildDetailRow('Relationship', _orphan.guardianRelationship),
              _buildDetailRow('Monthly Income', '\$${_orphan.guardianIncome.toStringAsFixed(2)}'),
            ]),
            _buildSectionTitle('Educational Status'),
            _buildDetailCard([
              _buildDetailRow('School Name', _orphan.institutionName ?? 'N/A'),
              _buildDetailRow('Grade Level', _orphan.gradeLevel ?? 'N/A'),
              _buildDetailRow('Academic Performance', _orphan.academicPerformance ?? 'N/A'),
            ]),
            _buildSectionTitle('Health Status'),
            _buildDetailCard([
              _buildDetailRow('General Health', _orphan.healthStatus ?? 'N/A'),
              _buildDetailRow('Disability', _orphan.disabilityType ?? 'None'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: details),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
} 