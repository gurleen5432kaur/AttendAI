import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/attendance_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'attendance.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentName TEXT,
            enrollment TEXT,
            date TEXT,
            time TEXT,
            isPresent INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertAttendance(AttendanceModel attendance) async {
    final db = await database;

    await db.insert(
      'attendance',
      {
        'studentName': attendance.studentName,
        'enrollment': attendance.enrollment,
        'date': attendance.date,
        'time': attendance.time,
        'isPresent': attendance.isPresent ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AttendanceModel>> getAttendance() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('attendance');

    return List.generate(
      maps.length,
          (i) => AttendanceModel(
        studentName: maps[i]['studentName'],
        enrollment: maps[i]['enrollment'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        isPresent: maps[i]['isPresent'] == 1,
      ),
    );
  }

  Future<void> clearAttendance() async {
    final db = await database;
    await db.delete('attendance');
  }
}