import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/orphan.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'orphans.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orphans(
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        fatherName TEXT NOT NULL,
        familyName TEXT NOT NULL,
        nickName TEXT,
        dateOfBirth TEXT NOT NULL,
        placeOfBirth TEXT,
        nationalId TEXT,
        gender TEXT NOT NULL,
        nationality TEXT,
        guardianFullName TEXT NOT NULL,
        guardianRelationship TEXT NOT NULL,
        guardianEducation TEXT NOT NULL,
        guardianWork TEXT NOT NULL,
        guardianDependents INTEGER NOT NULL,
        guardianIncome REAL NOT NULL,
        guardianSupport REAL NOT NULL,
        institutionName TEXT,
        gradeLevel TEXT,
        academicPerformance TEXT,
        healthStatus TEXT,
        disabilityType TEXT,
        createdAt TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0
      )
    ''');
  }

  // Save orphan to database
  Future<int> insertOrphan(Orphan orphan) async {
    final db = await database;
    return await db.insert('orphans', {
      'id': orphan.id,
      'firstName': orphan.firstName,
      'fatherName': orphan.fatherName,
      'familyName': orphan.familyName,
      'nickName': orphan.nickName,
      'dateOfBirth': orphan.dateOfBirth.toIso8601String(),
      'placeOfBirth': orphan.placeOfBirth,
      'nationalId': orphan.nationalId,
      'gender': orphan.gender,
      'nationality': orphan.nationality,
      'guardianFullName': orphan.guardianFullName,
      'guardianRelationship': orphan.guardianRelationship,
      'guardianEducation': orphan.guardianEducation,
      'guardianWork': orphan.guardianWork,
      'guardianDependents': orphan.guardianDependents,
      'guardianIncome': orphan.guardianIncome,
      'guardianSupport': orphan.guardianSupport,
      'institutionName': orphan.institutionName,
      'gradeLevel': orphan.gradeLevel,
      'academicPerformance': orphan.academicPerformance,
      'healthStatus': orphan.healthStatus,
      'disabilityType': orphan.disabilityType,
      'createdAt': DateTime.now().toIso8601String(),
      'isSynced': 0,
    });
  }

  // Get all orphans from database
  Future<List<Orphan>> getAllOrphans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orphans');

    return List.generate(maps.length, (i) {
      return Orphan(
        id: maps[i]['id'],
        firstName: maps[i]['firstName'],
        fatherName: maps[i]['fatherName'],
        familyName: maps[i]['familyName'],
        nickName: maps[i]['nickName'],
        dateOfBirth: DateTime.parse(maps[i]['dateOfBirth']),
        placeOfBirth: maps[i]['placeOfBirth'],
        nationalId: maps[i]['nationalId'],
        gender: maps[i]['gender'],
        nationality: maps[i]['nationality'],
        guardianFullName: maps[i]['guardianFullName'],
        guardianRelationship: maps[i]['guardianRelationship'],
        guardianEducation: maps[i]['guardianEducation'],
        guardianWork: maps[i]['guardianWork'],
        guardianDependents: maps[i]['guardianDependents'],
        guardianIncome: maps[i]['guardianIncome'],
        guardianSupport: maps[i]['guardianSupport'],
        institutionName: maps[i]['institutionName'],
        gradeLevel: maps[i]['gradeLevel'],
        academicPerformance: maps[i]['academicPerformance'],
        healthStatus: maps[i]['healthStatus'],
        disabilityType: maps[i]['disabilityType'],
      );
    });
  }

  // Update orphan in database
  Future<int> updateOrphan(Orphan orphan) async {
    final db = await database;
    return await db.update(
      'orphans',
      {
        'firstName': orphan.firstName,
        'fatherName': orphan.fatherName,
        'familyName': orphan.familyName,
        'nickName': orphan.nickName,
        'dateOfBirth': orphan.dateOfBirth.toIso8601String(),
        'placeOfBirth': orphan.placeOfBirth,
        'nationalId': orphan.nationalId,
        'gender': orphan.gender,
        'nationality': orphan.nationality,
        'guardianFullName': orphan.guardianFullName,
        'guardianRelationship': orphan.guardianRelationship,
        'guardianEducation': orphan.guardianEducation,
        'guardianWork': orphan.guardianWork,
        'guardianDependents': orphan.guardianDependents,
        'guardianIncome': orphan.guardianIncome,
        'guardianSupport': orphan.guardianSupport,
        'institutionName': orphan.institutionName,
        'gradeLevel': orphan.gradeLevel,
        'academicPerformance': orphan.academicPerformance,
        'healthStatus': orphan.healthStatus,
        'disabilityType': orphan.disabilityType,
        'isSynced': 0,
      },
      where: 'id = ?',
      whereArgs: [orphan.id],
    );
  }

  // Delete orphan from database
  Future<int> deleteOrphan(String id) async {
    final db = await database;
    return await db.delete(
      'orphans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all unsynced orphans (for syncing later)
  Future<List<Map<String, dynamic>>> getUnsyncedOrphans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orphans',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    print('Found ${maps.length} unsynced orphans');
    return maps;
  }

  // Mark orphan as synced (after successful API call)
  Future<int> markAsSynced(String orphanId) async {
    final db = await database;
    return await db.update(
      'orphans',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [orphanId],
    );
  }
}
