import 'package:flutter/material.dart';
import 'models/orphan.dart';
import 'orphan_form.dart';
import 'evidence_upload_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';

// TODO: Update this URL with your current ngrok URL
const String API_BASE_URL = 'https://753f06e15b5f.ngrok-free.app';
const String API_KEY = 'orphan_hq_demo_2025';

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
  late OrphanData _orphan;

  @override
  void initState() {
    super.initState();
    _orphan = widget.orphan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _orphan.displayName,
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
            if (_orphan.hasPaymentAvailable) _buildPaymentActionCard(),
            if (!_orphan.isSynced) _buildSyncActionCard(),
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
                      color: _getStatusColor(_orphan.status),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: _orphan.profileImage != null &&
                            _orphan.profileImage!.existsSync()
                        ? Image.file(
                            _orphan.profileImage!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              _orphan.gender == 'Male' ? Icons.boy : Icons.girl,
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
                        _orphan.displayName,
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
                          color: _getStatusColor(_orphan.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(_orphan.status),
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
                  isActive: _orphan.hasPaymentAvailable,
                  color: Colors.green,
                ),
                _buildStatusIndicator(
                  icon: Icons.notification_important,
                  label: 'Pending',
                  isActive: _orphan.hasPendingActions,
                  color: Colors.orange,
                ),
                _buildStatusIndicator(
                  icon: Icons.sync,
                  label: 'Synced',
                  isActive: _orphan.isSynced,
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
      subtitle: 'Change the status of the orphan (e.g., missing)',
      icon: Icons.edit,
      iconColor: Colors.orange,
      onTap: () => _showUpdateStatusDialog(),
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

  void _navigateToEvidenceUpload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EvidenceUploadPage(),
      ),
    );
  }

  void _syncData() {
    // TODO: Implement data synchronization logic
    setState(() {
      _isLoading = true;
    });

    // Simulate network call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        // _orphan = _orphan.copyWith(isSynced: true);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data synced successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showUpdateStatusDialog() {
    OrphanStatus? selectedStatus = _orphan.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Orphan Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: OrphanStatus.values.map((status) {
                  return RadioListTile<OrphanStatus>(
                    title: Text(_getStatusText(status)),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (OrphanStatus? value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    activeColor: _getStatusColor(status),
                    secondary: Icon(
                      Icons.circle,
                      color: _getStatusColor(status),
                    ),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedStatus != null) {
                      Navigator.of(context).pop(); // Close dialog first
                      _updateOrphanStatus(selectedStatus!); // Then update status
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateOrphanStatus(OrphanStatus newStatus) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Check internet connectivity first
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          throw SocketException('No Internet connection');
        }
      } on SocketException catch (_) {
        throw SocketException('No Internet connection');
      }

      // Convert OrphanStatus to the API's expected string format
      String statusString;
      switch (newStatus) {
        case OrphanStatus.missing:
          statusString = 'missing';
          break;
        case OrphanStatus.active:
          statusString = 'active';
          break;
        case OrphanStatus.unknown:
          statusString = 'found'; // Map unknown to found for API compatibility
          break;
      }

      developer.log('Updating orphan status',
          name: 'OrphanActionsScreen',
          error: 'Sending request to update status to: $statusString');

      // Make API call
      final url = '$API_BASE_URL/api/orphans/${_orphan.id}/updateStatus';
      developer.log('Making API call to: $url', name: 'OrphanActionsScreen');

      // Create a client with longer timeout
      final client = http.Client();
      try {
        final response = await client.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': API_KEY,
          },
          body: jsonEncode({
            'status': statusString,
          }),
        ).timeout(
          const Duration(seconds: 30), // Increased timeout to 30 seconds
          onTimeout: () {
            client.close();
            throw TimeoutException('The connection has timed out, please try again.');
          },
        );

        developer.log('API Response',
            name: 'OrphanActionsScreen',
            error: 'Status Code: ${response.statusCode}, Body: ${response.body}');

        if (response.statusCode == 200) {
          // Update local state on success
          setState(() {
            _orphan = _orphan.copyWith(
              status: newStatus,
              updatedAt: DateTime.now(),
              isSynced: true, // Mark as synced since API call succeeded
            );
            _isLoading = false;
          });

          // Show success message with checkmark icon
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Orphan status updated to "${_getStatusText(newStatus)}"'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          // Handle API error
          developer.log('API Error',
              name: 'OrphanActionsScreen',
              error: 'Failed to update status: ${response.statusCode}');
          throw Exception('Server error: ${response.statusCode}. Please try again.');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      developer.log('Exception',
          name: 'OrphanActionsScreen',
          error: 'Error updating status: ${e.toString()}');

      // Handle any errors
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        String errorMessage;
        if (e is SocketException) {
          errorMessage = 'No internet connection. Please check your connection and try again.';
        } else if (e is TimeoutException) {
          errorMessage = 'Connection timed out. The server is taking too long to respond. Please try again.';
        } else if (e.toString().contains('Failed host lookup')) {
          errorMessage = 'Cannot connect to server. Please check your internet connection or the server might be down.';
        } else {
          errorMessage = 'Failed to update status: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(errorMessage),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _updateOrphanStatus(newStatus);
              },
            ),
          ),
        );
      }
    }
  }

  void _navigateToEditForm() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrphanFormPage(orphan: _orphan),
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
      case OrphanStatus.active:
        return Colors.green;
      case OrphanStatus.missing:
        return Colors.red;
      case OrphanStatus.unknown:
        return Colors.orange;
    }
  }

  String _getStatusText(OrphanStatus status) {
    switch (status) {
      case OrphanStatus.active:
        return 'Active';
      case OrphanStatus.missing:
        return 'Missing';
      case OrphanStatus.unknown:
        return 'Unknown';
    }
  }

  String _getAgeAndGender() {
    final parts = <String>[];

    // Calculate age from date of birth
    if (_orphan.dateOfBirth != null && _orphan.dateOfBirth!.isNotEmpty) {
      try {
        final dateParts = _orphan.dateOfBirth!.split('/');
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

    if (_orphan.gender != null) {
      parts.add(_orphan.gender!);
    }

    return parts.join(' • ');
  }
}
