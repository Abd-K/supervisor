import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/models/orphan.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart'; // Added import for ApiService
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class OrphanFormPage extends StatelessWidget {
  final Orphan? orphan;

  const OrphanFormPage({super.key, this.orphan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orphan == null ? 'Orphan Registration Form' : 'Edit Orphan Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // The save logic is handled by the form itself.
              // We can use a GlobalKey to call the form's save method.
              // This is a common pattern for forms.
              // For now, we will rely on the button inside the form.
            },
          ),
        ],
      ),
      body: OrphanForm(orphan: orphan),
    );
  }
}

class OrphanForm extends StatefulWidget {
  final Orphan? orphan;
  const OrphanForm({super.key, this.orphan});

  @override
  State<OrphanForm> createState() => _OrphanFormState();
}

class _OrphanFormState extends State<OrphanForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers for form fields
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _sectionExpanded = {
    'child_info': false,
    'address': false,
    'father': false,
    'mother': false,
    'guardian': false,
    'education': false,
    'health': false,
    'nutrition': false,
    'psychological': false,
    'behavioral': false,
    'housing': false,
    'personal': false,
  };

  // Dropdown selections
  final Map<String, String?> _dropdownValues = {};

  // Image picker
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.orphan != null) {
      _prefillForm(widget.orphan!);
    } else {
      if (kDebugMode) {
        _prefillWithSampleData();
      }
    }
  }

  void _prefillWithSampleData() {
    _controllers['firstName']!.text = 'Ahmed';
    _controllers['fatherName']!.text = 'Mohammed';
    _controllers['grandfatherName']!.text = 'Ali';
    _controllers['familyName']!.text = 'Hassan';
    _controllers['dateOfBirth']!.text = '15/03/2015';
    
    _controllers['fatherDateOfDeath']!.text = '20/06/2023';
    _controllers['fatherCauseOfDeath']!.text = 'Heart attack';
    _controllers['fatherWork']!.text = 'Teacher';
    
    _controllers['motherFullName']!.text = 'Fatima Hassan';
    _controllers['motherWork']!.text = 'Housewife';
    
    _controllers['institutionName']!.text = 'Al-Noor Primary School';
    _controllers['gradeLevel']!.text = '3rd Grade';
    
    _controllers['disabilityType']!.text = 'None';

    _controllers['hobbies']!.text = 'Reading, Football';
    _controllers['skills']!.text = 'Good at mathematics';
    _controllers['numberOfSiblings']!.text = '2';
    _controllers['siblingsDetails']!.text = 'Older sister Sara (12), Younger brother Omar (5)';
    
    setState(() {
      _dropdownValues['gender'] = 'Male';
      _dropdownValues['fatherAlive'] = 'No';
      _dropdownValues['motherAlive'] = 'Yes';
      _dropdownValues['educationStage'] = 'Primary';
      _dropdownValues['healthStatus'] = 'Good';
    });
  }

  void _prefillForm(Orphan orphan) {
    // Pre-fill text fields
    _controllers['firstName']?.text = orphan.firstName;
    _controllers['fatherName']?.text = orphan.fatherName;
    _controllers['grandfatherName']?.text = orphan.grandfatherName ?? '';
    _controllers['familyName']?.text = orphan.familyName;
    _controllers['nickName']?.text = orphan.nickName ?? '';
    _controllers['dateOfBirth']?.text = DateFormat('dd/MM/yyyy').format(orphan.dateOfBirth);
    _controllers['placeOfBirth']?.text = orphan.placeOfBirth ?? '';
    _controllers['nationalId']?.text = orphan.nationalId ?? '';
    _controllers['nationality']?.text = orphan.nationality ?? '';
    _controllers['country']?.text = orphan.country ?? '';
    _controllers['province']?.text = orphan.province ?? '';
    _controllers['city']?.text = orphan.city ?? '';
    _controllers['village']?.text = orphan.village ?? '';
    _controllers['camp']?.text = orphan.camp ?? '';
    _controllers['neighborhood']?.text = orphan.neighborhood ?? '';
    _controllers['street']?.text = orphan.street ?? '';
    _controllers['mailingAddress']?.text = orphan.mailingAddress ?? '';
    _controllers['phoneNumber']?.text = orphan.phoneNumber ?? '';

    _controllers['hobbies']?.text = orphan.hobbies ?? '';
    _controllers['skills']?.text = orphan.skills ?? '';
    _controllers['numberOfSiblings']?.text = orphan.numberOfSiblings?.toString() ?? '';
    _controllers['siblingsDetails']?.text = orphan.siblingsDetails ?? '';

    // Pre-fill dropdowns
    setState(() {
      _dropdownValues['gender'] = orphan.gender;
      _dropdownValues['healthStatus'] = orphan.healthStatus;
      _dropdownValues['psychologicalStatus'] = orphan.psychologicalStatus;
      _dropdownValues['behavioralStatus'] = orphan.behavioralStatus;
      _dropdownValues['housingType'] = orphan.housingType;
      // Add other dropdowns as needed
    });
  }

  void _initializeControllers() {
    final fields = [
      // Child Info
      'firstName', 'fatherName', 'grandfatherName', 'familyName', 'nickName', 'dateOfBirth',
      'placeOfBirth', 'nationalId', 'nationality',
      // Address
      'country', 'province', 'city', 'village', 'camp', 'neighborhood',
      'street', 'mailingAddress', 'phoneNumber',
      // Father
      'fatherFirstName', 'fatherFatherName', 'fatherFamilyName', 'fatherDateOfBirth',
      'fatherDateOfDeath', 'fatherCauseOfDeath', 'fatherEducation', 'fatherWork',
      'fatherIncome', 'fatherWivesChildren',
      // Mother
      'motherFullName', 'motherDateOfBirth', 'motherDateOfDeath', 'motherCauseOfDeath',
      'motherEducation', 'motherWork', 'motherIncome',
      // Guardian
      'guardianFullName', 'guardianRelationship', 'guardianEducation', 'guardianWork',
      'guardianDependents', 'guardianIncome', 'guardianSupport',
      // Education
      'gradeLevel', 'academicYear', 'institutionName', 'institutionAddress',
      'tuitionCosts', 'excellentSubjects', 'weakSubjects', 'lastReportCard',
      'alternativeEducation', 'weaknessReason', 'improvementActions', 'dropoutReasons',
      // Health
      'disabilityType',
      // Nutrition
      'malnutritionCauses',
      // Housing
      'housingDescription',
      // Personal
      'hobbies', 'skills', 'numberOfSiblings', 'siblingsDetails',
    ];
    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildChildInfoSection(),
                  _buildAddressSection(),
                  _buildFatherSection(),
                  _buildMotherSection(),
                  _buildGuardianSection(),
                  _buildEducationSection(),
                  _buildHealthSection(),
                  _buildNutritionSection(),
                  _buildPsychologicalSection(),
                  _buildBehavioralSection(),
                  _buildHousingSection(),
                  _buildPersonalSection(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Saving child information...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

  Widget _buildExpandableSection({
    required String key,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: _sectionExpanded[key] ?? false,
        onExpansionChanged: (expanded) {
          setState(() => _sectionExpanded[key] = expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildChildInfoSection() => _buildExpandableSection(
    key: 'child_info',
    title: 'Child Information',
    icon: Icons.child_care,
    children: [
      _buildImagePicker(),
      _buildTextField('firstName', 'First Name', required: true),
      _buildTextField('fatherName', "Father's Name", required: true),
      _buildTextField('grandfatherName', "Grandfather's Name", required: true),
      _buildTextField('familyName', 'Family Name', required: true),
      _buildTextField('nickName', 'Nick Name'),
      _buildDatePicker('dateOfBirth', 'Date of Birth', required: true),
      _buildTextField('placeOfBirth', 'Place of Birth'),
      _buildTextField('nationalId', 'National ID Number'),
      _buildDropdown('gender', 'Gender', ['Male', 'Female'], required: true),
      _buildTextField('nationality', 'Nationality'),
    ],
  );

  Widget _buildAddressSection() => _buildExpandableSection(
    key: 'address',
    title: 'Current Address',
    icon: Icons.location_on,
    children: [
      _buildTextField('country', 'Country'),
      _buildTextField('province', 'Province / Region'),
      _buildTextField('city', 'City'),
      _buildTextField('village', 'Village'),
      _buildTextField('camp', 'Camp'),
      _buildTextField('neighborhood', 'Neighborhood'),
      _buildTextField('street', 'Street'),
      _buildTextField('mailingAddress', 'Mailing Address (detailed)', maxLines: 3),
      _buildTextField('phoneNumber', 'Phone Number', keyboardType: TextInputType.phone),
    ],
  );

  Widget _buildFatherSection() => _buildExpandableSection(
    key: 'father',
    title: "Child's Father",
    icon: Icons.man,
    children: [
      _buildTextField('fatherFirstName', 'First Name'),
      _buildTextField('fatherFatherName', "Father's Name"),
      _buildTextField('fatherFamilyName', 'Family Name'),
      _buildDatePicker('fatherDateOfBirth', 'Date of Birth'),
      _buildDropdown('fatherAlive', 'Alive', ['Yes', 'No']),
      _buildDatePicker('fatherDateOfDeath', 'Date of Death (if deceased)'),
      _buildTextField('fatherCauseOfDeath', 'Cause of Death (if deceased)', maxLines: 2),
      _buildTextField('fatherEducation', 'Educational Background'),
      _buildTextField('fatherWork', 'Type of Work / Employment'),
      _buildNumberField('fatherIncome', 'Monthly Income'),
      _buildNumberField('fatherWivesChildren', 'Number of Wives and Living Children'),
    ],
  );

  Widget _buildMotherSection() => _buildExpandableSection(
    key: 'mother',
    title: "Child's Mother",
    icon: Icons.woman,
    children: [
      _buildTextField('motherFullName', 'Full Name'),
      _buildDatePicker('motherDateOfBirth', 'Date of Birth'),
      _buildDropdown('motherAlive', 'Alive', ['Yes', 'No']),
      _buildDatePicker('motherDateOfDeath', 'Date of Death (if deceased)'),
      _buildTextField('motherCauseOfDeath', 'Cause of Death (if deceased)', maxLines: 2),
      _buildTextField('motherEducation', 'Educational Background'),
      _buildTextField('motherWork', 'Type of Work / Employment'),
      _buildNumberField('motherIncome', 'Monthly Income'),
      _buildDropdown('motherRemarried', 'Is she currently remarried?', ['Yes', 'No']),
    ],
  );

  Widget _buildGuardianSection() => _buildExpandableSection(
    key: 'guardian',
    title: 'Current Guardian of the Child',
    icon: Icons.family_restroom,
    children: [
      _buildTextField('guardianFullName', 'Full Name', required: true),
      _buildTextField('guardianRelationship', 'Relationship to the Child', required: true),
      _buildTextField('guardianEducation', 'Educational Level', required: true),
      _buildTextField('guardianWork', 'Type of Work', required: true),
      _buildNumberField('guardianDependents', 'Number of Dependents', required: true),
      _buildNumberField('guardianIncome', 'Monthly Income', required: true),
      _buildNumberField('guardianSupport', 'Estimated Financial Support for the Child', required: true),
    ],
  );

  Widget _buildEducationSection() => _buildExpandableSection(
    key: 'education',
    title: 'Educational Status of the Child',
    icon: Icons.school,
    children: [
      _buildDropdown('educationType', 'Type of Education', ['Academic', 'Vocational']),
      _buildDropdown('educationStage', 'Educational Stage', ['Preschool', 'Primary', 'Middle', 'Secondary', 'University']),
      _buildTextField('gradeLevel', 'Grade Level'),
      _buildTextField('academicYear', 'Academic Year'),
      _buildTextField('institutionName', 'Name of Educational Institution'),
      _buildTextField('institutionAddress', 'Address of Educational Institution'),
      _buildNumberField('tuitionCosts', 'Tuition / Education Costs'),
      _buildTextField('excellentSubjects', 'Subjects of Excellence', maxLines: 2),
      _buildTextField('weakSubjects', 'Subjects of Weakness', maxLines: 2),
      _buildTextField('lastReportCard', 'Last Report Card Result'),
      _buildTextField('alternativeEducation', 'Alternative Education Plan (if not enrolled)', maxLines: 3),
      _buildDropdown('academicPerformance', 'Academic Performance Level', ['Weak', 'Acceptable', 'Good', 'Very Good', 'Excellent']),
      _buildTextField('weaknessReason', 'Reason for Academic Weakness (if any)', maxLines: 2),
      _buildTextField('improvementActions', 'Actions Taken to Improve Academic Performance', maxLines: 3),
      _buildTextField('dropoutReasons', 'If Dropped Out: Reasons for Leaving School', maxLines: 2),
    ],
  );

  Widget _buildHealthSection() => _buildExpandableSection(
    key: 'health',
    title: 'Health Status of the Child',
    icon: Icons.health_and_safety,
    children: [
      _buildDropdown('healthStatus', 'General Health Status', ['Good', 'Chronic Illness', 'Special Needs']),
      _buildTextField('disabilityType', 'Type of Disability (if any)', maxLines: 2),
    ],
  );

  Widget _buildNutritionSection() => _buildExpandableSection(
    key: 'nutrition',
    title: 'Nutrition',
    icon: Icons.restaurant,
    children: [
      _buildDropdown('nutritionType', 'Type of Nutrition', ['Balanced', 'Weak', 'Poor']),
      _buildTextField('malnutritionCauses', 'If Malnourished: What are the Causes?', maxLines: 3),
    ],
  );

  Widget _buildPsychologicalSection() => _buildExpandableSection(
    key: 'psychological',
    title: 'Psychological Condition of the Child',
    icon: Icons.psychology,
    children: [
      _buildDropdown('psychologicalStatus', 'Psychological Status', ['Stable', 'Anxious', 'Disturbed']),
    ],
  );

  Widget _buildBehavioralSection() => _buildExpandableSection(
    key: 'behavioral',
    title: 'Behavioral Condition of the Child',
    icon: Icons.emoji_emotions,
    children: [
      _buildDropdown('behavioralStatus', 'Behavioral Status', ['Disciplined', 'Average', 'Poor']),
    ],
  );

  Widget _buildHousingSection() => _buildExpandableSection(
    key: 'housing',
    title: 'Housing Status',
    icon: Icons.home,
    children: [
      _buildDropdown('housingType', 'Current Housing Type', ['Rent', 'Borrowed', 'Other']),
      _buildTextField('housingDescription', 'Housing Type (e.g. apartment, tent, etc.)'),
      _buildDropdown('housingCondition', 'Housing Condition', ['Good', 'Moderate', 'Poor']),
      _buildDropdown('furnitureCondition', 'Furniture Condition', ['Good', 'Moderate', 'Poor']),
    ],
  );

  Widget _buildPersonalSection() => _buildExpandableSection(
    key: 'personal',
    title: 'Personal Information',
    icon: Icons.person,
    children: [
      _buildTextField('hobbies', 'Hobbies'),
      _buildTextField('skills', 'Skills'),
      _buildNumberField('numberOfSiblings', 'Number of Siblings'),
      _buildTextField('siblingsDetails', 'Siblings Details', maxLines: 3),
    ],
  );

  Widget _buildTextField(
    String key,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Builder(
        builder: (context) => Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              Future.delayed(const Duration(milliseconds: 300), () {
                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 300),
                  alignment: 0.1, // Ensure proper scrolling
                );
              });
            }
          },
          child: TextFormField(
            controller: _controllers[key],
            decoration: InputDecoration(
              labelText: required ? '$label *' : label,
              border: const OutlineInputBorder(),
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: required
                ? (value) => value?.isEmpty == true ? 'This field is required' : null
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String key, String label, {bool required = false}) {
    return _buildTextField(
      key,
      label,
      required: required,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdown(String key, String label, List<String> options, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
        ),
        items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        value: _dropdownValues[key],
        onChanged: (v) => setState(() => _dropdownValues[key] = v),
        validator: required
            ? (v) => v == null ? 'Please select an option' : null
            : null,
      ),
    );
  }

  Widget _buildDatePicker(String key, String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() {
              _controllers[key]!.text = DateFormat('dd/MM/yyyy').format(date);
            });
          }
        },
        validator: required
            ? (value) => value?.isEmpty == true ? 'This field is required' : null
            : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Picture',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: _profileImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(58),
                      child: Image.file(
                        _profileImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          if (_profileImage != null)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _profileImage = null;
                });
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Select Photo Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : const Text('Save'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
  // 1️⃣ Tell Flutter you’re about to change everything
  setState(() {
    // 2️⃣ Reset the FormState (clears built-in FormField state)
    _formKey.currentState?.reset();

    // 3️⃣ Manually clear every TextEditingController
    for (final controller in _controllers.values) {
      controller.clear();
    }

    // 4️⃣ Reset your dropdown map to “no selection”
    _dropdownValues.clear();

    // 5️⃣ Collapse all except the first section
    _sectionExpanded.updateAll((section, _) => section == 'child_info');
  });

  // 6️⃣ (Optional) Scroll back to top so the user sees the very first section
  _scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
}

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      // --- Data Transformation ---
      DateTime? dateOfBirth = _controllers['dateOfBirth']!.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_controllers['dateOfBirth']!.text)
          : null;
      DateTime? fatherDateOfDeath = _controllers['fatherDateOfDeath']!.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_controllers['fatherDateOfDeath']!.text)
          : null;
          
      final orphanData = {
        "first_name": _controllers['firstName']!.text,
        "father_name": _controllers['fatherName']!.text,
        "grandfather_name": _controllers['grandfatherName']!.text,
        "family_name": _controllers['familyName']!.text,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "gender": _dropdownValues['gender']?.toLowerCase(),
        "status": "active",
        "father": {
          "name": _controllers['fatherName']!.text,
          "date_of_death": fatherDateOfDeath?.toIso8601String(),
          "cause_of_death": _controllers['fatherCauseOfDeath']!.text,
          "occupation": _controllers['fatherWork']!.text,
        },
        "mother": {
            "name": _controllers['motherFullName']!.text,
            "alive": _dropdownValues['motherAlive'] == 'Yes',
            "occupation": _controllers['motherWork']!.text,
        },
        "education": {
            "level": _dropdownValues['educationStage'],
            "school_name": _controllers['institutionName']!.text,
            "grade": _controllers['gradeLevel']!.text,
        },
        "health": {
            "status": _dropdownValues['healthStatus'],
            "medical_conditions": _controllers['disabilityType']!.text,
            "needs_medical_support": false, 
        },
        "personal": {
            "hobbies": _controllers['hobbies']!.text,
            "skills": _controllers['skills']!.text,
            "number_of_siblings": int.tryParse(_controllers['numberOfSiblings']!.text),
            "siblings_details": _controllers['siblingsDetails']!.text,
        }
      };

      // --- API Call with Logging ---
      final apiService = ApiService();
      try {
        developer.log('Sending orphan data to API: ${jsonEncode(orphanData)}', name: 'ApiService');
        final response = await apiService.createOrphan(orphanData);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          developer.log('Orphan saved successfully!', name: 'ApiService');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Orphan saved successfully!')),
            );
            Navigator.of(context).pop();
          }
        } else {
          developer.log('Error saving orphan: ${response.statusCode} ${response.body}', name: 'ApiService');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}')),
            );
          }
        }
      } catch (e, s) {
        developer.log('Error saving orphan', name: 'ApiService', error: e, stackTrace: s);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _scrollToFirstError(FormState formState) {
    // ... existing code ...

}
}