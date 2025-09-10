import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

   static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Open DB
  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'n3n3_dummy.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create Patients table
        await db.execute('''
          CREATE TABLE Patients(
            national_id TEXT PRIMARY KEY,
            first_name TEXT,
            last_name TEXT,
            password TEXT,
            phone TEXT,
            email TEXT
          )
        ''');

        // Create Doctors table
        await db.execute('''
          CREATE TABLE Doctors(
            syndicate_id TEXT PRIMARY KEY,
            first_name TEXT,
            last_name TEXT,
            password TEXT,
            phone TEXT,
            email TEXT
          )
        ''');

        // Create Admins table
        await db.execute('''
          CREATE TABLE Admins(
            admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT,
            last_name TEXT,
            password TEXT,
            phone TEXT,
            email TEXT UNIQUE
          )
        ''');
      },
    );
  }

  // Insert dummy doctors
  static Future<void> insertDummyData() async {
    final db = await initDB();

    // Insert a patient
    await db.insert('Patients', {
      'national_id': '12345678901234',
      'first_name': 'Ali',
      'last_name': 'Hassan',
      'password': 'pass123',
      'phone': '0111111111',
      'email': 'ali@example.com',
    });

    // Insert a doctor
    await db.insert('Doctors', {
      'syndicate_id': 'D5678',
      'first_name': 'Mona',
      'last_name': 'Adel',
      'password': 'docpass',
      'phone': '0122222222',
      'email': 'mona@hospital.com',
    });

    // Insert an admin
    await db.insert('Admins', {
      'email': 'mohammedhany1807@gmail.com', 
      'first_name': 'Mohammed',
      'last_name': 'Hany',
      'password': 'adminpass',
      'phone': '0111111111',
    });

    // Insert an admin
    await db.insert('Admins', {
      'email': 'loaypre2510@gmail.com', 
      'first_name': 'Loay',
      'last_name': 'Medhat',
      'password': 'adminpass',
      'phone': '0111111111',
    });

    await db.insert('Admins', {
      'email': 'ahmedsamir1598@gmail.com', 
      'first_name': 'Ahmed',
      'last_name': 'Samir',
      'password': 'adminpass',
      'phone': '0111111111',
    });
  }

  static Future<bool> loginDoctor(String syndicateId, String password) async {
    final db = await database;
    final res = await db.query(
      'Doctors',
      where: 'syndicate_id = ? AND password = ?',
      whereArgs: [syndicateId, password],
    );
    return res.isNotEmpty;
  }

  static Future<bool> loginPatient(String nationalId, String password) async {
    final db = await database;
    final res = await db.query(
      'Patients',
      where: 'national_id = ? AND password = ?',
      whereArgs: [nationalId, password],
    );
    return res.isNotEmpty;
  }

  static Future<bool> loginAdmin(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'Admins',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty;
  }

    static Future<bool> doctorExists(String syndicateId) async {
    final db = await database;
    final res = await db.query(
      'Doctors',
      where: 'syndicate_id = ?',
      whereArgs: [syndicateId],
    );
    return res.isNotEmpty;
  }

  static Future<void> registerDoctor({
    required String syndicateId,
    required String firstName,
    required String lastName,
    required String password,
    required String phone,
    String? email,
  }) async {
    final db = await database;

    // Check if doctor already exists
    final exists = await doctorExists(syndicateId);
    if (exists) {
      throw Exception("Doctor with this Syndicate ID already exists.");
    }

    await db.insert(
      'Doctors',
      {
        'syndicate_id': syndicateId,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'phone': phone,
        'email': email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getDoctorById(String syndicateId) async {
      final db = await database;
      print("Running query for doctorId: $syndicateId");

      final res = await db.query(
        'Doctors',
        where: 'syndicate_id = ?',
        whereArgs: [syndicateId],
      );

      print("Query result: $res"); // <---- Important
      return res.isNotEmpty ? res.first : null;
    }


}
