import 'package:flutter/material.dart';
import 'package:supervisor/models/orphan.dart';
import 'package:supervisor/orphan_form.dart';
import 'package:supervisor/evidence_upload_page.dart';

class OrphanActionsScreen extends StatefulWidget {
  final Orphan orphan;

  const OrphanActionsScreen({
    super.key,
    required this.orphan,
  });

  @override
  State<OrphanActionsScreen> createState() => _OrphanActionsScreenState();
}

class _OrphanActionsScreenState extends State<OrphanActionsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.orphan.firstName} ${widget.orphan.familyName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Orphan summary card
            _buildOrphanSummaryCard(),
            const SizedBox(height: 24),
            
            // Actions title
            const Text(
              'Available Actions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Action cards
            _buildUpdateStatusActionCard(),
            _buildUpdateDetailsActionCard(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrphanSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Profile image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green, // Replace with dynamic status color if available
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: Colors.grey[200],
                      child: Icon(
                        widget.orphan.gender == 'Male' ? Icons.boy : Icons.girl,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Orphan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.orphan.firstName} ${widget.orphan.familyName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getAgeAndGender(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green, // Replace with dynamic status color if available
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.orphan.healthStatus ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateStatusActionCard() {
    return _buildActionCard(
      title: 'Update Status',
      subtitle: 'Change orphan status (Good, Missing, Unknown)',
      icon: Icons.update,
      iconColor: Colors.orange,
      onTap: () => _showStatusUpdateDialog(),
    );
  }

  Widget _buildUpdateDetailsActionCard() {
    return _buildActionCard(
      title: 'Update Details',
      subtitle: 'Edit orphan information',
      icon: Icons.edit,
      iconColor: Colors.blue,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrphanFormPage(orphan: widget.orphan),
          ),
        );
        if (result == true) {
          // You might want to refresh the data here.
          // For now, we'll just pop the screen.
          Navigator.of(context).pop(true);
        }
      },
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _navigateToEvidenceUpload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EvidenceUploadPage(),
      ),
    );
  }

  void _syncData() {
    setState(() => _isLoading = true);
    // TODO: Implement actual data sync logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Syncing data...')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data synced successfully!')),
      );
    });
  }

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedStatus = widget.orphan.healthStatus;
        return AlertDialog(
          title: const Text('Update Status'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                items: ['Good', 'Missing', 'Unknown'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setDialogState(() {
                    selectedStatus = newValue;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement status update logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Status updated to $selectedStatus')),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  String _getAgeAndGender() {
    final age = DateTime.now().difference(widget.orphan.dateOfBirth).inDays ~/ 365;
    return 'Age: $age, Gender: ${widget.orphan.gender}';
  }
}
