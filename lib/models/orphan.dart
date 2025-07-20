import 'dart:io';
import 'package:intl/intl.dart';

enum OrphanStatus { active, missing, unknown }

enum EducationType { academic, vocational }

enum EducationStage { preschool, primary, middle, secondary, university }

enum AcademicPerformance { weak, acceptable, good, veryGood, excellent }

enum HealthStatus { good, chronicIllness, specialNeeds }

enum NutritionType { balanced, weak, poor }

enum PsychologicalStatus { stable, anxious, disturbed }

enum BehavioralStatus { disciplined, average, poor }

enum HousingType { rent, borrowed, other }

enum HousingCondition { good, moderate, poor }

enum FurnitureCondition { good, moderate, poor }

class OrphanData {
  // Child Information
  final String? firstName;
  final String? fatherName;
  final String? familyName;
  final String? nickName;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? nationalId;
  final String? gender;
  final String? nationality;
  final File? profileImage;

  // Address Information
  final String? country;
  final String? province;
  final String? city;
  final String? village;
  final String? camp;
  final String? neighborhood;
  final String? street;
  final String? mailingAddress;
  final String? phoneNumber;

  // Father Information
  final String? fatherFirstName;
  final String? fatherFatherName;
  final String? fatherFamilyName;
  final String? fatherDateOfBirth;
  final String? fatherAlive;
  final String? fatherDateOfDeath;
  final String? fatherCauseOfDeath;
  final String? fatherEducation;
  final String? fatherWork;
  final double? fatherIncome;
  final int? fatherWivesChildren;

  // Mother Information
  final String? motherFullName;
  final String? motherDateOfBirth;
  final String? motherAlive;
  final String? motherDateOfDeath;
  final String? motherCauseOfDeath;
  final String? motherEducation;
  final String? motherWork;
  final double? motherIncome;
  final String? motherRemarried;

  // Guardian Information
  final String? guardianFullName;
  final String? guardianRelationship;
  final String? guardianEducation;
  final String? guardianWork;
  final int? guardianDependents;
  final double? guardianIncome;
  final double? guardianSupport;

  // Education Information
  final String? educationType;
  final String? educationStage;
  final String? gradeLevel;
  final String? academicYear;
  final String? institutionName;
  final String? institutionAddress;
  final double? tuitionCosts;
  final String? excellentSubjects;
  final String? weakSubjects;
  final String? lastReportCard;
  final String? alternativeEducation;
  final String? academicPerformance;
  final String? weaknessReason;
  final String? improvementActions;
  final String? dropoutReasons;

  // Health Information
  final String? healthStatus;
  final String? disabilityType;

  // Nutrition Information
  final String? nutritionType;
  final String? malnutritionCauses;

  // Psychological Information
  final String? psychologicalStatus;

  // Behavioral Information
  final String? behavioralStatus;

  // Housing Information
  final String? housingType;
  final String? housingDescription;
  final String? housingCondition;
  final String? furnitureCondition;

  // Additional fields for list view
  final OrphanStatus status;
  final bool hasPaymentAvailable;
  final bool hasPendingActions;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const OrphanData({
    // Child Information
    this.firstName,
    this.fatherName,
    this.familyName,
    this.nickName,
    this.dateOfBirth,
    this.placeOfBirth,
    this.nationalId,
    this.gender,
    this.nationality,
    this.profileImage,

    // Address Information
    this.country,
    this.province,
    this.city,
    this.village,
    this.camp,
    this.neighborhood,
    this.street,
    this.mailingAddress,
    this.phoneNumber,

    // Father Information
    this.fatherFirstName,
    this.fatherFatherName,
    this.fatherFamilyName,
    this.fatherDateOfBirth,
    this.fatherAlive,
    this.fatherDateOfDeath,
    this.fatherCauseOfDeath,
    this.fatherEducation,
    this.fatherWork,
    this.fatherIncome,
    this.fatherWivesChildren,

    // Mother Information
    this.motherFullName,
    this.motherDateOfBirth,
    this.motherAlive,
    this.motherDateOfDeath,
    this.motherCauseOfDeath,
    this.motherEducation,
    this.motherWork,
    this.motherIncome,
    this.motherRemarried,

    // Guardian Information
    this.guardianFullName,
    this.guardianRelationship,
    this.guardianEducation,
    this.guardianWork,
    this.guardianDependents,
    this.guardianIncome,
    this.guardianSupport,

    // Education Information
    this.educationType,
    this.educationStage,
    this.gradeLevel,
    this.academicYear,
    this.institutionName,
    this.institutionAddress,
    this.tuitionCosts,
    this.excellentSubjects,
    this.weakSubjects,
    this.lastReportCard,
    this.alternativeEducation,
    this.academicPerformance,
    this.weaknessReason,
    this.improvementActions,
    this.dropoutReasons,

    // Health Information
    this.healthStatus,
    this.disabilityType,

    // Nutrition Information
    this.nutritionType,
    this.malnutritionCauses,

    // Psychological Information
    this.psychologicalStatus,

    // Behavioral Information
    this.behavioralStatus,

    // Housing Information
    this.housingType,
    this.housingDescription,
    this.housingCondition,
    this.furnitureCondition,

    // Additional fields
    this.status = OrphanStatus.unknown,
    this.hasPaymentAvailable = false,
    this.hasPendingActions = false,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  // Get display name for the orphan
  String get displayName {
    final parts = <String>[];
    if (firstName?.isNotEmpty == true) parts.add(firstName!);
    if (fatherName?.isNotEmpty == true) parts.add(fatherName!);
    if (familyName?.isNotEmpty == true) parts.add(familyName!);
    return parts.isNotEmpty ? parts.join(' ') : 'Unknown';
  }

  // Factory constructor to create OrphanData from form controllers and dropdowns
  factory OrphanData.fromForm({
    required Map<String, String> textValues,
    required Map<String, String?> dropdownValues,
    File? profileImage,
    OrphanStatus status = OrphanStatus.unknown,
    bool hasPaymentAvailable = false,
    bool hasPendingActions = false,
    required String id,
  }) {
    return OrphanData(
      // Child Information
      firstName: textValues['firstName'],
      fatherName: textValues['fatherName'],
      familyName: textValues['familyName'],
      nickName: textValues['nickName'],
      dateOfBirth: textValues['dateOfBirth'],
      placeOfBirth: textValues['placeOfBirth'],
      nationalId: textValues['nationalId'],
      gender: dropdownValues['gender'],
      nationality: textValues['nationality'],
      profileImage: profileImage,

      // Address Information
      country: textValues['country'],
      province: textValues['province'],
      city: textValues['city'],
      village: textValues['village'],
      camp: textValues['camp'],
      neighborhood: textValues['neighborhood'],
      street: textValues['street'],
      mailingAddress: textValues['mailingAddress'],
      phoneNumber: textValues['phoneNumber'],

      // Father Information
      fatherFirstName: textValues['fatherFirstName'],
      fatherFatherName: textValues['fatherFatherName'],
      fatherFamilyName: textValues['fatherFamilyName'],
      fatherDateOfBirth: textValues['fatherDateOfBirth'],
      fatherAlive: dropdownValues['fatherAlive'],
      fatherDateOfDeath: textValues['fatherDateOfDeath'],
      fatherCauseOfDeath: textValues['fatherCauseOfDeath'],
      fatherEducation: textValues['fatherEducation'],
      fatherWork: textValues['fatherWork'],
      fatherIncome: double.tryParse(textValues['fatherIncome'] ?? ''),
      fatherWivesChildren: int.tryParse(textValues['fatherWivesChildren'] ?? ''),

      // Mother Information
      motherFullName: textValues['motherFullName'],
      motherDateOfBirth: textValues['motherDateOfBirth'],
      motherAlive: dropdownValues['motherAlive'],
      motherDateOfDeath: textValues['motherDateOfDeath'],
      motherCauseOfDeath: textValues['motherCauseOfDeath'],
      motherEducation: textValues['motherEducation'],
      motherWork: textValues['motherWork'],
      motherIncome: double.tryParse(textValues['motherIncome'] ?? ''),
      motherRemarried: dropdownValues['motherRemarried'],

      // Guardian Information
      guardianFullName: textValues['guardianFullName'],
      guardianRelationship: textValues['guardianRelationship'],
      guardianEducation: textValues['guardianEducation'],
      guardianWork: textValues['guardianWork'],
      guardianDependents: int.tryParse(textValues['guardianDependents'] ?? ''),
      guardianIncome: double.tryParse(textValues['guardianIncome'] ?? ''),
      guardianSupport: double.tryParse(textValues['guardianSupport'] ?? ''),

      // Education Information
      educationType: dropdownValues['educationType'],
      educationStage: dropdownValues['educationStage'],
      gradeLevel: textValues['gradeLevel'],
      academicYear: textValues['academicYear'],
      institutionName: textValues['institutionName'],
      institutionAddress: textValues['institutionAddress'],
      tuitionCosts: double.tryParse(textValues['tuitionCosts'] ?? ''),
      excellentSubjects: textValues['excellentSubjects'],
      weakSubjects: textValues['weakSubjects'],
      lastReportCard: textValues['lastReportCard'],
      alternativeEducation: textValues['alternativeEducation'],
      academicPerformance: dropdownValues['academicPerformance'],
      weaknessReason: textValues['weaknessReason'],
      improvementActions: textValues['improvementActions'],
      dropoutReasons: textValues['dropoutReasons'],

      // Health Information
      healthStatus: dropdownValues['healthStatus'],
      disabilityType: textValues['disabilityType'],

      // Nutrition Information
      nutritionType: dropdownValues['nutritionType'],
      malnutritionCauses: textValues['malnutritionCauses'],

      // Psychological Information
      psychologicalStatus: dropdownValues['psychologicalStatus'],

      // Behavioral Information
      behavioralStatus: dropdownValues['behavioralStatus'],

      // Housing Information
      housingType: dropdownValues['housingType'],
      housingDescription: textValues['housingDescription'],
      housingCondition: dropdownValues['housingCondition'],
      furnitureCondition: dropdownValues['furnitureCondition'],

      // Additional fields
      status: status,
      hasPaymentAvailable: hasPaymentAvailable,
      hasPendingActions: hasPendingActions,
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
    );
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'fatherName': fatherName,
      'familyName': familyName,
      'nickName': nickName,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'nationalId': nationalId,
      'gender': gender,
      'nationality': nationality,
      'country': country,
      'province': province,
      'city': city,
      'village': village,
      'camp': camp,
      'neighborhood': neighborhood,
      'street': street,
      'mailingAddress': mailingAddress,
      'phoneNumber': phoneNumber,
      'fatherFirstName': fatherFirstName,
      'fatherFatherName': fatherFatherName,
      'fatherFamilyName': fatherFamilyName,
      'fatherDateOfBirth': fatherDateOfBirth,
      'fatherAlive': fatherAlive,
      'fatherDateOfDeath': fatherDateOfDeath,
      'fatherCauseOfDeath': fatherCauseOfDeath,
      'fatherEducation': fatherEducation,
      'fatherWork': fatherWork,
      'fatherIncome': fatherIncome,
      'fatherWivesChildren': fatherWivesChildren,
      'motherFullName': motherFullName,
      'motherDateOfBirth': motherDateOfBirth,
      'motherAlive': motherAlive,
      'motherDateOfDeath': motherDateOfDeath,
      'motherCauseOfDeath': motherCauseOfDeath,
      'motherEducation': motherEducation,
      'motherWork': motherWork,
      'motherIncome': motherIncome,
      'motherRemarried': motherRemarried,
      'guardianFullName': guardianFullName,
      'guardianRelationship': guardianRelationship,
      'guardianEducation': guardianEducation,
      'guardianWork': guardianWork,
      'guardianDependents': guardianDependents,
      'guardianIncome': guardianIncome,
      'guardianSupport': guardianSupport,
      'educationType': educationType,
      'educationStage': educationStage,
      'gradeLevel': gradeLevel,
      'academicYear': academicYear,
      'institutionName': institutionName,
      'institutionAddress': institutionAddress,
      'tuitionCosts': tuitionCosts,
      'excellentSubjects': excellentSubjects,
      'weakSubjects': weakSubjects,
      'lastReportCard': lastReportCard,
      'alternativeEducation': alternativeEducation,
      'academicPerformance': academicPerformance,
      'weaknessReason': weaknessReason,
      'improvementActions': improvementActions,
      'dropoutReasons': dropoutReasons,
      'healthStatus': healthStatus,
      'disabilityType': disabilityType,
      'nutritionType': nutritionType,
      'malnutritionCauses': malnutritionCauses,
      'psychologicalStatus': psychologicalStatus,
      'behavioralStatus': behavioralStatus,
      'housingType': housingType,
      'housingDescription': housingDescription,
      'housingCondition': housingCondition,
      'furnitureCondition': furnitureCondition,
      'status': status.name,
      'hasPaymentAvailable': hasPaymentAvailable,
      'hasPendingActions': hasPendingActions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  // Copy with method for updates
  OrphanData copyWith({
    String? firstName,
    String? fatherName,
    String? familyName,
    String? nickName,
    String? dateOfBirth,
    String? placeOfBirth,
    String? nationalId,
    String? gender,
    String? nationality,
    File? profileImage,
    String? country,
    String? province,
    String? city,
    String? village,
    String? camp,
    String? neighborhood,
    String? street,
    String? mailingAddress,
    String? phoneNumber,
    String? fatherFirstName,
    String? fatherFatherName,
    String? fatherFamilyName,
    String? fatherDateOfBirth,
    String? fatherAlive,
    String? fatherDateOfDeath,
    String? fatherCauseOfDeath,
    String? fatherEducation,
    String? fatherWork,
    double? fatherIncome,
    int? fatherWivesChildren,
    String? motherFullName,
    String? motherDateOfBirth,
    String? motherAlive,
    String? motherDateOfDeath,
    String? motherCauseOfDeath,
    String? motherEducation,
    String? motherWork,
    double? motherIncome,
    String? motherRemarried,
    String? guardianFullName,
    String? guardianRelationship,
    String? guardianEducation,
    String? guardianWork,
    int? guardianDependents,
    double? guardianIncome,
    double? guardianSupport,
    String? educationType,
    String? educationStage,
    String? gradeLevel,
    String? academicYear,
    String? institutionName,
    String? institutionAddress,
    double? tuitionCosts,
    String? excellentSubjects,
    String? weakSubjects,
    String? lastReportCard,
    String? alternativeEducation,
    String? academicPerformance,
    String? weaknessReason,
    String? improvementActions,
    String? dropoutReasons,
    String? healthStatus,
    String? disabilityType,
    String? nutritionType,
    String? malnutritionCauses,
    String? psychologicalStatus,
    String? behavioralStatus,
    String? housingType,
    String? housingDescription,
    String? housingCondition,
    String? furnitureCondition,
    OrphanStatus? status,
    bool? hasPaymentAvailable,
    bool? hasPendingActions,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return OrphanData(
      firstName: firstName ?? this.firstName,
      fatherName: fatherName ?? this.fatherName,
      familyName: familyName ?? this.familyName,
      nickName: nickName ?? this.nickName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      nationalId: nationalId ?? this.nationalId,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      profileImage: profileImage ?? this.profileImage,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      village: village ?? this.village,
      camp: camp ?? this.camp,
      neighborhood: neighborhood ?? this.neighborhood,
      street: street ?? this.street,
      mailingAddress: mailingAddress ?? this.mailingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fatherFirstName: fatherFirstName ?? this.fatherFirstName,
      fatherFatherName: fatherFatherName ?? this.fatherFatherName,
      fatherFamilyName: fatherFamilyName ?? this.fatherFamilyName,
      fatherDateOfBirth: fatherDateOfBirth ?? this.fatherDateOfBirth,
      fatherAlive: fatherAlive ?? this.fatherAlive,
      fatherDateOfDeath: fatherDateOfDeath ?? this.fatherDateOfDeath,
      fatherCauseOfDeath: fatherCauseOfDeath ?? this.fatherCauseOfDeath,
      fatherEducation: fatherEducation ?? this.fatherEducation,
      fatherWork: fatherWork ?? this.fatherWork,
      fatherIncome: fatherIncome ?? this.fatherIncome,
      fatherWivesChildren: fatherWivesChildren ?? this.fatherWivesChildren,
      motherFullName: motherFullName ?? this.motherFullName,
      motherDateOfBirth: motherDateOfBirth ?? this.motherDateOfBirth,
      motherAlive: motherAlive ?? this.motherAlive,
      motherDateOfDeath: motherDateOfDeath ?? this.motherDateOfDeath,
      motherCauseOfDeath: motherCauseOfDeath ?? this.motherCauseOfDeath,
      motherEducation: motherEducation ?? this.motherEducation,
      motherWork: motherWork ?? this.motherWork,
      motherIncome: motherIncome ?? this.motherIncome,
      motherRemarried: motherRemarried ?? this.motherRemarried,
      guardianFullName: guardianFullName ?? this.guardianFullName,
      guardianRelationship: guardianRelationship ?? this.guardianRelationship,
      guardianEducation: guardianEducation ?? this.guardianEducation,
      guardianWork: guardianWork ?? this.guardianWork,
      guardianDependents: guardianDependents ?? this.guardianDependents,
      guardianIncome: guardianIncome ?? this.guardianIncome,
      guardianSupport: guardianSupport ?? this.guardianSupport,
      educationType: educationType ?? this.educationType,
      educationStage: educationStage ?? this.educationStage,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      academicYear: academicYear ?? this.academicYear,
      institutionName: institutionName ?? this.institutionName,
      institutionAddress: institutionAddress ?? this.institutionAddress,
      tuitionCosts: tuitionCosts ?? this.tuitionCosts,
      excellentSubjects: excellentSubjects ?? this.excellentSubjects,
      weakSubjects: weakSubjects ?? this.weakSubjects,
      lastReportCard: lastReportCard ?? this.lastReportCard,
      alternativeEducation: alternativeEducation ?? this.alternativeEducation,
      academicPerformance: academicPerformance ?? this.academicPerformance,
      weaknessReason: weaknessReason ?? this.weaknessReason,
      improvementActions: improvementActions ?? this.improvementActions,
      dropoutReasons: dropoutReasons ?? this.dropoutReasons,
      healthStatus: healthStatus ?? this.healthStatus,
      disabilityType: disabilityType ?? this.disabilityType,
      nutritionType: nutritionType ?? this.nutritionType,
      malnutritionCauses: malnutritionCauses ?? this.malnutritionCauses,
      psychologicalStatus: psychologicalStatus ?? this.psychologicalStatus,
      behavioralStatus: behavioralStatus ?? this.behavioralStatus,
      housingType: housingType ?? this.housingType,
      housingDescription: housingDescription ?? this.housingDescription,
      housingCondition: housingCondition ?? this.housingCondition,
      furnitureCondition: furnitureCondition ?? this.furnitureCondition,
      status: status ?? this.status,
      hasPaymentAvailable: hasPaymentAvailable ?? this.hasPaymentAvailable,
      hasPendingActions: hasPendingActions ?? this.hasPendingActions,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

// Simple Orphan class for compatibility with existing list view code
class Orphan {
  final String id;
  final String firstName;
  final String fatherName;
  final String familyName;
  final String? nickName;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String? nationalId;
  final String gender;
  final String? nationality;
  final String? country;
  final String? province;
  final String? city;
  final String? village;
  final String? camp;
  final String? neighborhood;
  final String? street;
  final String? mailingAddress;
  final String? phoneNumber;
  final String? fatherFirstName;
  final String? fatherFatherName;
  final String? fatherFamilyName;
  final DateTime? fatherDateOfBirth;
  final bool? fatherAlive;
  final DateTime? fatherDateOfDeath;
  final String? fatherCauseOfDeath;
  final String? fatherEducation;
  final String? fatherWork;
  final double? fatherIncome;
  final int? fatherWivesChildren;
  final String? motherFullName;
  final DateTime? motherDateOfBirth;
  final bool? motherAlive;
  final DateTime? motherDateOfDeath;
  final String? motherCauseOfDeath;
  final String? motherEducation;
  final String? motherWork;
  final double? motherIncome;
  final bool? motherRemarried;
  final String guardianFullName;
  final String guardianRelationship;
  final String guardianEducation;
  final String guardianWork;
  final int guardianDependents;
  final double guardianIncome;
  final double guardianSupport;
  final String? educationType;
  final String? educationStage;
  final String? gradeLevel;
  final String? academicYear;
  final String? institutionName;
  final String? institutionAddress;
  final double? tuitionCosts;
  final String? excellentSubjects;
  final String? weakSubjects;
  final String? lastReportCard;
  final String? alternativeEducation;
  final String? academicPerformance;
  final String? weaknessReason;
  final String? improvementActions;
  final String? dropoutReasons;
  final String? healthStatus;
  final String? disabilityType;
  final String? nutritionType;
  final String? malnutritionCauses;
  final String? psychologicalStatus;
  final String? behavioralStatus;
  final String? housingType;
  final String? housingDescription;
  final String? housingCondition;
  final String? furnitureCondition;

  Orphan({
    required this.id,
    required this.firstName,
    required this.fatherName,
    required this.familyName,
    this.nickName,
    required this.dateOfBirth,
    this.placeOfBirth,
    this.nationalId,
    required this.gender,
    this.nationality,
    this.country,
    this.province,
    this.city,
    this.village,
    this.camp,
    this.neighborhood,
    this.street,
    this.mailingAddress,
    this.phoneNumber,
    this.fatherFirstName,
    this.fatherFatherName,
    this.fatherFamilyName,
    this.fatherDateOfBirth,
    this.fatherAlive,
    this.fatherDateOfDeath,
    this.fatherCauseOfDeath,
    this.fatherEducation,
    this.fatherWork,
    this.fatherIncome,
    this.fatherWivesChildren,
    this.motherFullName,
    this.motherDateOfBirth,
    this.motherAlive,
    this.motherDateOfDeath,
    this.motherCauseOfDeath,
    this.motherEducation,
    this.motherWork,
    this.motherIncome,
    this.motherRemarried,
    required this.guardianFullName,
    required this.guardianRelationship,
    required this.guardianEducation,
    required this.guardianWork,
    required this.guardianDependents,
    required this.guardianIncome,
    required this.guardianSupport,
    this.educationType,
    this.educationStage,
    this.gradeLevel,
    this.academicYear,
    this.institutionName,
    this.institutionAddress,
    this.tuitionCosts,
    this.excellentSubjects,
    this.weakSubjects,
    this.lastReportCard,
    this.alternativeEducation,
    this.academicPerformance,
    this.weaknessReason,
    this.improvementActions,
    this.dropoutReasons,
    this.healthStatus,
    this.disabilityType,
    this.nutritionType,
    this.malnutritionCauses,
    this.psychologicalStatus,
    this.behavioralStatus,
    this.housingType,
    this.housingDescription,
    this.housingCondition,
     this.furnitureCondition,
   });

  // Convert Orphan to OrphanData for compatibility
  OrphanData toOrphanData() {
    return OrphanData(
      id: id,
      firstName: firstName,
      fatherName: fatherName,
      familyName: familyName,
      nickName: nickName,
      dateOfBirth: DateFormat('dd/MM/yyyy').format(dateOfBirth),
      placeOfBirth: placeOfBirth,
      nationalId: nationalId,
      gender: gender,
      nationality: nationality,
      country: country,
      province: province,
      city: city,
      village: village,
      camp: camp,
      neighborhood: neighborhood,
      street: street,
      mailingAddress: mailingAddress,
      phoneNumber: phoneNumber,
      fatherFirstName: fatherFirstName,
      fatherFatherName: fatherFatherName,
      fatherFamilyName: fatherFamilyName,
      fatherDateOfBirth: fatherDateOfBirth != null ? DateFormat('dd/MM/yyyy').format(fatherDateOfBirth!) : null,
      fatherAlive: fatherAlive?.toString(),
      fatherDateOfDeath: fatherDateOfDeath != null ? DateFormat('dd/MM/yyyy').format(fatherDateOfDeath!) : null,
      fatherCauseOfDeath: fatherCauseOfDeath,
      fatherEducation: fatherEducation,
      fatherWork: fatherWork,
      fatherIncome: fatherIncome,
      fatherWivesChildren: fatherWivesChildren,
      motherFullName: motherFullName,
      motherDateOfBirth: motherDateOfBirth != null ? DateFormat('dd/MM/yyyy').format(motherDateOfBirth!) : null,
      motherAlive: motherAlive?.toString(),
      motherDateOfDeath: motherDateOfDeath != null ? DateFormat('dd/MM/yyyy').format(motherDateOfDeath!) : null,
      motherCauseOfDeath: motherCauseOfDeath,
      motherEducation: motherEducation,
      motherWork: motherWork,
      motherIncome: motherIncome,
      motherRemarried: motherRemarried?.toString(),
      guardianFullName: guardianFullName,
      guardianRelationship: guardianRelationship,
      guardianEducation: guardianEducation,
      guardianWork: guardianWork,
      guardianDependents: guardianDependents,
      guardianIncome: guardianIncome,
      guardianSupport: guardianSupport,
      educationType: educationType,
      educationStage: educationStage,
      gradeLevel: gradeLevel,
      academicYear: academicYear,
      institutionName: institutionName,
      institutionAddress: institutionAddress,
      tuitionCosts: tuitionCosts,
      excellentSubjects: excellentSubjects,
      weakSubjects: weakSubjects,
      lastReportCard: lastReportCard,
      alternativeEducation: alternativeEducation,
      academicPerformance: academicPerformance,
      weaknessReason: weaknessReason,
      improvementActions: improvementActions,
      dropoutReasons: dropoutReasons,
      healthStatus: healthStatus,
      disabilityType: disabilityType,
      nutritionType: nutritionType,
      malnutritionCauses: malnutritionCauses,
      psychologicalStatus: psychologicalStatus,
      behavioralStatus: behavioralStatus,
      housingType: housingType,
      housingDescription: housingDescription,
      housingCondition: housingCondition,
      furnitureCondition: furnitureCondition,
      status: OrphanStatus.unknown, // Default status
      hasPaymentAvailable: false, // Default
      hasPendingActions: false, // Default
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: true, // Assume synced for existing data
    );
  }
}