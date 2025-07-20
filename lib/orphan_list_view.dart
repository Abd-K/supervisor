import 'package:flutter/material.dart';
import 'models/orphan.dart';
import 'orphan_form.dart';
import 'orphan_actions_screen.dart';
import 'dart:io';

class OrphanListView extends StatefulWidget {
  const OrphanListView({super.key});

  @override
  State<OrphanListView> createState() => _OrphanListViewState();
}

class _OrphanListViewState extends State<OrphanListView> {
  List<OrphanData> orphans = [];
  List<OrphanData> filteredOrphans = [];
  final TextEditingController _searchController = TextEditingController();
  
  // Filter states
  bool _filterPendingActions = false;
  bool _filterPaymentAvailable = false;
  bool _filterUnsyncedData = false;
  String? _selectedAgeFilter;
  
  final List<String> _ageFilters = [
    'Under 5',
    '5-10',
    '11-15',
    '16-18',
    'Over 18'
  ];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _loadDummyData() {
    // Create dummy data with 4 orphans
    orphans = [
      OrphanData(
        id: '1',
        firstName: 'Ahmed',
        fatherName: 'Mohammed',
        familyName: 'Al-Rashid',
        dateOfBirth: '15/03/2015',
        gender: 'Male',
        status: OrphanStatus.active,
        hasPaymentAvailable: true,
        hasPendingActions: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        isSynced: true,
      ),
      OrphanData(
        id: '60e4ca3d-f089-4fc1-bba8-4dc18c25cc6b',
        firstName: 'نور',
        fatherName: 'حسين',
        familyName: 'السلامة',
        dateOfBirth: '27/04/2020', // 1587993890 epoch seconds to date
        gender: 'Female', // 0 = Female
        status: OrphanStatus.active, // 0 = active
        hasPaymentAvailable: false,
        hasPendingActions: true,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1753017890 * 1000), // last_updated
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1753017890 * 1000), // last_updated
        isSynced: false,
        profileImage: File('/storage/emulated/0/Download/noor.jpg'),
      ),
      OrphanData(
        id: '3',
        firstName: 'Omar',
        fatherName: 'Abdullah',
        familyName: 'Al-Mahmoud',
        dateOfBirth: '08/11/2016',
        gender: 'Male',
        status: OrphanStatus.unknown,
        hasPaymentAvailable: true,
        hasPendingActions: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isSynced: true,
      ),
      OrphanData(
        id: '4',
        firstName: 'Aisha',
        fatherName: 'Khalil',
        familyName: 'Al-Zahra',
        dateOfBirth: '03/05/2014',
        gender: 'Female',
        status: OrphanStatus.active,
        hasPaymentAvailable: false,
        hasPendingActions: false,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isSynced: true,
      ),
    ];
    _applyFilters();
  }

  void _applyFilters() {
    List<OrphanData> filtered = List.from(orphans);
    
    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase().trim();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((orphan) {
        final fullName = orphan.displayName.toLowerCase();
        return fullName.contains(searchQuery);
      }).toList();
    }
    
    // Apply pending actions filter
    if (_filterPendingActions) {
      filtered = filtered.where((orphan) => orphan.hasPendingActions).toList();
    }
    
    // Apply payment available filter
    if (_filterPaymentAvailable) {
      filtered = filtered.where((orphan) => orphan.hasPaymentAvailable).toList();
    }
    
    // Apply unsynced data filter
    if (_filterUnsyncedData) {
      filtered = filtered.where((orphan) => !orphan.isSynced).toList();
    }
    
    // Apply age filter
    if (_selectedAgeFilter != null) {
      filtered = filtered.where((orphan) {
        final age = _calculateAge(orphan.dateOfBirth);
        if (age == null) return false;
        
        switch (_selectedAgeFilter) {
          case 'Under 5':
            return age < 5;
          case '5-10':
            return age >= 5 && age <= 10;
          case '11-15':
            return age >= 11 && age <= 15;
          case '16-18':
            return age >= 16 && age <= 18;
          case 'Over 18':
            return age > 18;
          default:
            return true;
        }
      }).toList();
    }
    
    setState(() {
      filteredOrphans = filtered;
    });
  }

  int? _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;
    
    try {
      final dateParts = dateOfBirth.split('/');
      if (dateParts.length == 3) {
        final birthDate = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
        );
        return DateTime.now().difference(birthDate).inDays ~/ 365;
      }
    } catch (e) {
      // If date parsing fails, return null
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orphans List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          // Active Filters Chips
          if (_hasActiveFilters()) _buildActiveFiltersChips(),
          
          // Orphans List
          Expanded(
            child: filteredOrphans.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      // TODO: Implement refresh from database/API
                      setState(() {
                        _loadDummyData();
                      });
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredOrphans.length,
                      itemBuilder: (context, index) {
                        final orphan = filteredOrphans[index];
                        return _buildOrphanCard(orphan);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrphanFormPage()),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Orphan'),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _filterPendingActions ||
           _filterPaymentAvailable ||
           _filterUnsyncedData ||
           _selectedAgeFilter != null;
  }

  Widget _buildActiveFiltersChips() {
    final activeFilters = <Widget>[];
    
    if (_filterPendingActions) {
      activeFilters.add(_buildFilterChip('Pending Actions', () {
        setState(() {
          _filterPendingActions = false;
          _applyFilters();
        });
      }));
    }
    
    if (_filterPaymentAvailable) {
      activeFilters.add(_buildFilterChip('Payment Available', () {
        setState(() {
          _filterPaymentAvailable = false;
          _applyFilters();
        });
      }));
    }
    
    if (_filterUnsyncedData) {
      activeFilters.add(_buildFilterChip('Unsynced', () {
        setState(() {
          _filterUnsyncedData = false;
          _applyFilters();
        });
      }));
    }
    
    if (_selectedAgeFilter != null) {
      activeFilters.add(_buildFilterChip('Age: $_selectedAgeFilter', () {
        setState(() {
          _selectedAgeFilter = null;
          _applyFilters();
        });
      }));
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: activeFilters,
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
        onDeleted: onDeleted,
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = 'No orphans found';
    String description = 'Try adjusting your search or filters';
    
    if (_searchController.text.isNotEmpty) {
      message = 'No orphans found for "${_searchController.text}"';
    } else if (_hasActiveFilters()) {
      message = 'No orphans match the current filters';
    } else if (orphans.isEmpty) {
      message = 'No orphans registered yet';
      description = 'Add orphans to get started';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Filter switches
              SwitchListTile(
                title: const Text('Pending Actions'),
                subtitle: const Text('Show orphans with pending actions'),
                value: _filterPendingActions,
                activeColor: Colors.green,
                onChanged: (value) {
                  setModalState(() {
                    _filterPendingActions = value;
                  });
                },
              ),
              
              SwitchListTile(
                title: const Text('Payment Available'),
                subtitle: const Text('Show orphans with available payments'),
                value: _filterPaymentAvailable,
                activeColor: Colors.green,
                onChanged: (value) {
                  setModalState(() {
                    _filterPaymentAvailable = value;
                  });
                },
              ),
              
              SwitchListTile(
                title: const Text('Unsynced Data'),
                subtitle: const Text('Show orphans with unsynced data'),
                value: _filterUnsyncedData,
                activeColor: Colors.green,
                onChanged: (value) {
                  setModalState(() {
                    _filterUnsyncedData = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Age filter dropdown
              const Text(
                'Age Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select age range',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: _selectedAgeFilter,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All ages'),
                  ),
                  ..._ageFilters.map(
                    (age) => DropdownMenuItem(
                      value: age,
                      child: Text(age),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setModalState(() {
                    _selectedAgeFilter = value;
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          _filterPendingActions = false;
                          _filterPaymentAvailable = false;
                          _filterUnsyncedData = false;
                          _selectedAgeFilter = null;
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Apply filters
                          _applyFilters();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrphanCard(OrphanData orphan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrphanActionsScreen(orphan: orphan),
            ),
          );
          
          // If any action was performed, refresh the list
          if (result == true) {
            setState(() {
              _loadDummyData();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              _buildProfileImage(orphan),
              const SizedBox(width: 16),
              
              // Orphan Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      orphan.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Age and Gender
                    Text(
                      _getAgeAndGender(orphan),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Status with dot
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(orphan.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getStatusText(orphan.status),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(orphan.status),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Indicators
              Column(
                children: [
                  // Payment Available Indicator
                  if (orphan.hasPaymentAvailable)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  
                  // Pending Actions Indicator
                  if (orphan.hasPendingActions)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.notification_important,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                  
                  // Sync Status Indicator
                  if (!orphan.isSynced)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.sync_problem,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(OrphanData orphan) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getStatusColor(orphan.status),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: orphan.id == '60e4ca3d-f089-4fc1-bba8-4dc18c25cc6b'
            ? Image.asset(
                'assets/images/noor.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar(orphan);
                },
              )
            : orphan.profileImage != null && orphan.profileImage!.existsSync()
                ? Image.file(
                    orphan.profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(orphan);
                    },
                  )
                : _buildDefaultAvatar(orphan),
      ),
    );
  }

  Widget _buildDefaultAvatar(OrphanData orphan) {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        orphan.gender == 'Male' ? Icons.boy : Icons.girl,
        size: 35,
        color: Colors.grey[400],
      ),
    );
  }

  String _getAgeAndGender(OrphanData orphan) {
    final parts = <String>[];
    
    // Calculate age from date of birth
    if (orphan.dateOfBirth != null && orphan.dateOfBirth!.isNotEmpty) {
      try {
        final dateParts = orphan.dateOfBirth!.split('/');
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
    
    if (orphan.gender != null) {
      parts.add(orphan.gender!);
    }
    
    return parts.join(' • ');
  }
}
