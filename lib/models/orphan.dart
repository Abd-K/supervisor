import 'dart:io';
import 'package:intl/intl.dart';

enum OrphanStatus { good, missing, unknown }

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

class Orphan {
  final String id;
  final String firstName;
  final String fatherName;
  final String? grandfatherName;
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
  final String? hobbies;
  final String? skills;
  final int? numberOfSiblings;
  final String? siblingsDetails;

  Orphan({
    required this.id,
    required this.firstName,
    required this.fatherName,
    this.grandfatherName,
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
    this.hobbies,
    this.skills,
    this.numberOfSiblings,
    this.siblingsDetails,
  });

  factory Orphan.fromJson(Map<String, dynamic> json) {
    return Orphan(
      id: json['id'],
      firstName: json['first_name'],
      fatherName: json['father_name'],
      grandfatherName: json['grandfather_name'],
      familyName: json['family_name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'],
      guardianFullName: json['guardian']['name'],
      guardianRelationship: json['guardian']['relationship'],
      guardianIncome: (json['guardian']['income'] as num).toDouble(),
      institutionName: json['education']['school_name'],
      gradeLevel: json['education']['grade'],
      academicPerformance: json['education']['level'],
      healthStatus: json['health']['status'],
      disabilityType: json['health']['medical_conditions'],
      guardianEducation: '',
      guardianWork: '',
      guardianDependents: 0,
      guardianSupport: 0,
      hobbies: json['personal']?['hobbies'],
      skills: json['personal']?['skills'],
      numberOfSiblings: json['personal']?['number_of_siblings'],
      siblingsDetails: json['personal']?['siblings_details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'father_name': fatherName,
      'grandfather_name': grandfatherName,
      'family_name': familyName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender.toLowerCase(),
      'status': 'active', // Default status
      'father': {
        'name': fatherName,
        'date_of_death': fatherDateOfDeath?.toIso8601String(),
        'cause_of_death': fatherCauseOfDeath,
        'occupation': fatherWork,
      },
      'mother': {
        'name': motherFullName,
        'alive': motherAlive,
        'occupation': motherWork,
      },
      'education': {
        'level': academicPerformance,
        'school_name': institutionName,
        'grade': gradeLevel,
      },
      'health': {
        'status': healthStatus,
        'medical_conditions': disabilityType,
        'needs_medical_support': false, // Default value
      },
      'personal': {
        'hobbies': hobbies,
        'skills': skills,
        'number_of_siblings': numberOfSiblings,
        'siblings_details': siblingsDetails,
      }
    };
  }
}