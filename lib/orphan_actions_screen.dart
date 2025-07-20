import 'package:flutter/material.dart';
import 'models/orphan.dart';
import 'orphan_form.dart';
import 'evidence_upload_page.dart';

class OrphanActionsScreen extends StatefulWidget {
  final OrphanData orphan;

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
          widget.orphan.displayName,
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
            if (widget.orphan.hasPaymentAvailable) _buildPaymentActionCard(),
            if (!widget.orphan.isSynced) _buildSyncActionCard(),
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
                      color: _getStatusColor(widget.orphan.status),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: widget.orphan.profileImage != null && 
                           widget.orphan.profileImage!.existsSync()
                        ? Image.file(
                            widget.orphan.profileImage!,
                            fit: BoxFit.cover,
                          )
                        : Container(
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
                        widget.orphan.displayName,
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
                          color: _getStatusColor(widget.orphan.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(widget.orphan.status),
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
            
            const SizedBox(height: 16),
            
            // Status indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusIndicator(
                  icon: Icons.account_balance_wallet,
                  label: 'Payment',
                  isActive: widget.orphan.hasPaymentAvailable,
                  color: Colors.green,
                ),
                _buildStatusIndicator(
                  icon: Icons.notification_important,
                  label: 'Pending',
                  isActive: widget.orphan.hasPendingActions,
                  color: Colors.orange,
                ),
                _buildStatusIndicator(
                  icon: Icons.sync,
                  label: 'Synced',
                  isActive: widget.orphan.isSynced,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? color : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? color : Colors.grey,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentActionCard() {
    return _buildActionCard(
      title: 'Confirm Payment Withdrawal',
      subtitle: 'Upload evidence for payment withdrawal',
      icon: Icons.account_balance_wallet,
      iconColor: Colors.green,
      onTap: () => _navigateToEvidenceUpload(),
    );
  }

  Widget _buildSyncActionCard() {
    return _buildActionCard(
      title: 'Sync Data',
      subtitle: 'Upload local changes to server',
      icon: Icons.sync,
      iconColor: Colors.blue,
      onTap: () => _syncData(),
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
      subtitle: 'Edit orphan information and records',
      icon: Icons.edit,
      iconColor: Colors.purple,
      onTap: () => _navigateToEditForm(),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isLoading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEvidenceUpload() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EvidenceUploadPage(),
      ),
    );
    
    // If evidence was uploaded successfully, navigate back to the list
    if (result == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Evidence uploaded for ${widget.orphan.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to list
        Navigator.pop(context, true);
      }
    }
  }

  void _showStatusUpdateDialog() {
    OrphanStatus? selectedStatus = widget.orphan.status;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Update status for ${widget.orphan.displayName}:'),
              const SizedBox(height: 16),
              ...OrphanStatus.values.map(
                (status) => RadioListTile<OrphanStatus>(
                  title: Text(_getStatusText(status)),
                  value: status,
                  groupValue: selectedStatus,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setDialogState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedStatus != widget.orphan.status
                  ? () {
                      Navigator.pop(context);
                      _updateStatus(selectedStatus!);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _syncData() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement actual data sync
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data synced for ${widget.orphan.displayName}'),
            backgroundColor: Colors.blue,
          ),
        );
        
        // Navigate back to list
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sync data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateStatus(OrphanStatus newStatus) async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement actual status update
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated for ${widget.orphan.displayName}'),
            backgroundColor: Colors.orange,
          ),
        );
        
        // Navigate back to list
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToEditForm() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrphanFormPage(orphan: widget.orphan),
      ),
    );
    
    // If the form was saved successfully, navigate back to the list
    if (result != null && result is OrphanData) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orphan details updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to list with updated data
        Navigator.pop(context, true);
      }
    }
  }

  Color _getStatusColor(OrphanStatus status) {
    switch (status) {
      case OrphanStatus.good:
        return Colors.green;
      case OrphanStatus.missing:
        return Colors.red;
      case OrphanStatus.unknown:
        return Colors.orange;
    }
  }

  String _getStatusText(OrphanStatus status) {
    switch (status) {
      case OrphanStatus.good:
        return 'Good';
      case OrphanStatus.missing:
        return 'Missing';
      case OrphanStatus.unknown:
        return 'Unknown';
    }
  }

  String _getAgeAndGender() {
    final parts = <String>[];
    
    // Calculate age from date of birth
    if (widget.orphan.dateOfBirth != null && widget.orphan.dateOfBirth!.isNotEmpty) {
      try {
        final dateParts = widget.orphan.dateOfBirth!.split('/');
        if (dateParts.length == 3) {
          final birthDate = DateTime(
            int.parse(dateParts[2]), // year
            int.parse(dateParts[1]), // month
            int.parse(dateParts[0]), // day
          );
          final age = DateTime.now().difference(birthDate).inDays ~/ 365;
          parts.add('$age years old');
        }
      } catch (e) {
        // If date parsing fails, don't show age
      }
    }
    
    if (widget.orphan.gender != null) {
      parts.add(widget.orphan.gender!);
    }
    
    return parts.join(' • ');
  }
}
