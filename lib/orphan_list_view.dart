import 'package:flutter/material.dart';
import 'package:supervisor/models/orphan.dart';
import 'package:supervisor/orphan_form.dart';
import 'package:supervisor/orphan_details_page.dart';

class OrphanListView extends StatefulWidget {
  const OrphanListView({super.key});

  @override
  State<OrphanListView> createState() => _OrphanListViewState();
}

class _OrphanListViewState extends State<OrphanListView> {
  List<Orphan> orphans = [];
  List<Orphan> filteredOrphans = [];
  final TextEditingController _searchController = TextEditingController();

  // Filter states
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
    orphans = List.generate(10, (index) {
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
    _applyFilters();
  }

  void _applyFilters() {
    List<Orphan> filtered = List.from(orphans);
    
    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase().trim();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((orphan) {
        final fullName = '${orphan.firstName} ${orphan.fatherName} ${orphan.familyName}'.toLowerCase();
        return fullName.contains(searchQuery);
      }).toList();
    }
    
    // Apply age filter
    if (_selectedAgeFilter != null) {
      filtered = filtered.where((orphan) {
        final age = _calculateAge(orphan.dateOfBirth);
        
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

  int _calculateAge(DateTime birthDate) {
    return DateTime.now().difference(birthDate).inDays ~/ 365;
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
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
          // List of orphans
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrphans.length,
              itemBuilder: (context, index) {
                final orphan = filteredOrphans[index];
                return _buildOrphanCard(orphan);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrphanFormPage()),
          );
          if (result == true) {
            _loadDummyData();
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filter by Age'),
                  DropdownButton<String>(
                    value: _selectedAgeFilter,
                    hint: const Text('Select age range'),
                    isExpanded: true,
                    items: _ageFilters.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setDialogState(() {
                        _selectedAgeFilter = newValue;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _selectedAgeFilter = null;
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrphanCard(Orphan orphan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _buildDefaultAvatar(orphan),
        title: Text(
          '${orphan.firstName} ${orphan.fatherName} ${orphan.familyName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_getAgeAndGender(orphan)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
  }

  Widget _buildDefaultAvatar(Orphan orphan) {
    final initial = orphan.firstName.isNotEmpty ? orphan.firstName[0].toUpperCase() : '';
    return CircleAvatar(
      backgroundColor: Colors.green,
      child: Text(
        initial,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getAgeAndGender(Orphan orphan) {
    final age = _calculateAge(orphan.dateOfBirth);
    return 'Age: $age, Gender: ${orphan.gender}';
  }
}
