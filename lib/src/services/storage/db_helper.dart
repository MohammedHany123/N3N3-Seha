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
            email TEXT,
            date_of_birth TEXT,
            gender TEXT
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
            email TEXT,
            profile_image TEXT NULL
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

        // Create Appointments table
        await db.execute('''
          CREATE TABLE Appointments(
            appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
            patient_id TEXT,
            doctor_id TEXT,
            scheduled_at TEXT,
            status TEXT,
            notes TEXT,
            FOREIGN KEY (patient_id) REFERENCES Patients(national_id),
            FOREIGN KEY (doctor_id) REFERENCES Doctors(syndicate_id)
          )
        ''');

        // Create Diagnostics table
        await db.execute('''
          CREATE TABLE Diagnostics(
            diagnostic_id INTEGER PRIMARY KEY AUTOINCREMENT,
            patient_id TEXT,
            doctor_id TEXT,
            ai_result TEXT,
            doctor_notes TEXT,
            created_at TEXT,
            diagnostic_type TEXT,
            FOREIGN KEY (patient_id) REFERENCES Patients(national_id),
            FOREIGN KEY (doctor_id) REFERENCES Doctors(syndicate_id)
          )
        ''');

        // Create Patient History table
        await db.execute('''
          CREATE TABLE PatientHistory(
            history_id INTEGER PRIMARY KEY AUTOINCREMENT,
            patient_id TEXT,
            doctor_id TEXT,
            visit_date TEXT,
            symptoms TEXT,
            diagnosis TEXT,
            treatment TEXT,
            medications TEXT,
            notes TEXT,
            FOREIGN KEY (patient_id) REFERENCES Patients(national_id),
            FOREIGN KEY (doctor_id) REFERENCES Doctors(syndicate_id)
          )
        ''');

        // Create Reports table
        await db.execute('''
          CREATE TABLE Reports(
            report_id INTEGER PRIMARY KEY AUTOINCREMENT,
            patient_id TEXT,
            doctor_id TEXT,
            report_type TEXT,
            file_path TEXT,
            created_at TEXT,
            FOREIGN KEY (patient_id) REFERENCES Patients(national_id),
            FOREIGN KEY (doctor_id) REFERENCES Doctors(syndicate_id)
          )
        ''');

        await db.execute('''
          CREATE TABLE Alerts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            doctor_id TEXT,
            patient_id TEXT,
            title TEXT,
            description TEXT,
            datetime TEXT,
            status TEXT, -- 'unread' or 'read'
            FOREIGN KEY (doctor_id) REFERENCES Doctors(syndicate_id),
            FOREIGN KEY (patient_id) REFERENCES Patients(national_id)
          )
        ''');
      },
    );
  }

  // Insert dummy data
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
      'date_of_birth': '1980-01-01',
      'gender': 'Male',
    });

    // Insert another patient
    await db.insert('Patients', {
      'national_id': '98765432109876',
      'first_name': 'Sara',
      'last_name': 'Mostafa',
      'password': 'pass456',
      'phone': '0123456789',
      'email': 'sara@example.com',
      'date_of_birth': '1992-05-15',
      'gender': 'Female',
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

    // Insert admins
    await db.insert('Admins', {
      'email': 'mohammedhany1807@gmail.com',
      'first_name': 'Mohammed',
      'last_name': 'Hany',
      'password': 'adminpass',
      'phone': '0111111111',
    });

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

    // Insert Appointments
    await db.insert('Appointments', {
      'patient_id': '12345678901234',
      'doctor_id': 'D5678',
      'scheduled_at': '2025-09-10 10:00:00',
      'status': 'scheduled',
      'notes': 'Routine dental check-up',
    });

    await db.insert('Appointments', {
      'patient_id': '98765432109876',
      'doctor_id': 'D5678',
      'scheduled_at': '2025-09-12 14:30:00',
      'status': 'completed',
      'notes': 'Follow-up for root canal',
    });

    // Insert Diagnostics
    await db.insert('Diagnostics', {
      'patient_id': '12345678901234',
      'doctor_id': 'D5678',
      'ai_result': 'Cavity detected with 85% confidence',
      'doctor_notes': 'Confirmed presence of cavity, treatment needed',
      'created_at': DateTime.now().toIso8601String(),
      'diagnostic_type': 'Dental Image',
    });

    await db.insert('Diagnostics', {
      'patient_id': '98765432109876',
      'doctor_id': 'D5678',
      'ai_result': 'CBC: Low hemoglobin detected',
      'doctor_notes': 'Possible anemia, further tests required',
      'created_at': DateTime.now().toIso8601String(),
      'diagnostic_type': 'CBC Analyzer',
    });

    // Insert Patient History
    await db.insert('PatientHistory', {
      'patient_id': '12345678901234',
      'doctor_id': 'D5678',
      'visit_date': '2025-08-20',
      'symptoms': 'Toothache',
      'diagnosis': 'Cavity',
      'treatment': 'Filling recommended',
      'medications': 'Painkillers prescribed',
      'notes': 'Needs follow-up in 2 weeks',
    });

    await db.insert('PatientHistory', {
      'patient_id': '98765432109876',
      'doctor_id': 'D5678',
      'visit_date': '2025-07-15',
      'symptoms': 'Fatigue',
      'diagnosis': 'Anemia suspicion',
      'treatment': 'Blood tests advised',
      'medications': 'Iron supplements',
      'notes': 'Monitor for 1 month',
    });

    await db.insert('Alerts', {
      'doctor_id': 'D5678',
      'patient_id': '12345678901234',
      'title': 'Abnormal CBC Detected',
      'description': 'CBC result for Ali Hassan shows low hemoglobin.',
      'datetime': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'status': 'unread',
    });
    await db.insert('Alerts', {
      'doctor_id': 'D5678',
      'patient_id': '98765432109876',
      'title': 'Urgent Dental Case',
      'description': 'Sara Mostafa reported severe tooth pain.',
      'datetime': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'status': 'read',
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

  static Future<List<Map<String, dynamic>>> getAllPatients() async {
    final db = await database; // <-- your existing database getter

    // Make sure the Patients table has these columns:
    // id (PK), firstName, lastName, nationalId, profilePic (optional)
    final List<Map<String, dynamic>> result = await db.query(
      'Patients',
      orderBy: 'first_name ASC',
    );
    return result;
  }

  static Future<List<Map<String, dynamic>>> searchPatients(String query) async {
    final db = await database;
    return await db.query(
      'Patients',
      where: 'first_name LIKE ? OR last_name LIKE ? OR national_id LIKE ?',
      whereArgs: [
        '%$query%', // partial match for first name
        '%$query%', // partial match for last name
        '%$query%', // partial match for nationalId
      ],
      orderBy: 'first_name ASC',
    );
  }

  static Future<bool> patientExists(String nationalId) async {
    final db = await database;
    final res = await db.query(
      'Patients',
      where: 'national_id = ?',
      whereArgs: [nationalId],
    );
    return res.isNotEmpty;
  }

  static Future<void> addPatient({
    required String nationalId,
    required String firstName,
    required String lastName,
    required String password,
    required String phone,
    String? email,
    required DateTime dateOfBirth,
    required String gender,
  }) async {
    final db = await database;

    // Check if patient already exists
    final exists = await patientExists(nationalId);
    if (exists) {
      throw Exception("Patient with this National ID already exists.");
    }

    await db.insert(
      'Patients',
      {
        'national_id': nationalId,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'phone': phone,
        'email': email,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'gender': gender,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getPatientById(String nationalId) async {
    final db = await database;
    final res = await db.query(
      'Patients',
      where: 'national_id = ?',
      whereArgs: [nationalId],
    );
    return res.isNotEmpty ? res.first : null;
  }

  static Future<List<Map<String, dynamic>>> getPatientHistory(String nationalId) async {
    final db = await database;
    return await db.query(
      'PatientHistory',
      where: 'patient_id = ?',
      whereArgs: [nationalId],
      orderBy: 'visit_date DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> getPatientDiagnostics(String nationalId) async {
    final db = await database;
    return await db.query(
      'Diagnostics',
      where: 'patient_id = ?',
      whereArgs: [nationalId],
      orderBy: 'created_at DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> getPatientAppointments(String nationalId) async {
    final db = await database;
    return await db.query(
      'Appointments',
      where: 'patient_id = ?',
      whereArgs: [nationalId],
      orderBy: 'scheduled_at DESC',
    );
  }

  static Future<void> addPatientHistory({
    required String patientId,
    required String doctorId,
    required DateTime visitDate,
    required String symptoms,
    required String diagnosis,
    required String treatment,
    required String medications,
    required String notes,
  }) async {
    final db = await database;
    await db.insert(
      'PatientHistory',
      {
        'patient_id': patientId,
        'doctor_id': doctorId,
        'visit_date': visitDate.toIso8601String(),
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'treatment': treatment,
        'medications': medications,
        'notes': notes,
      },
    );
  }

  static Future<void> addDiagnostic({
    required String patientId,
    required String doctorId,
    required String aiResult,
    required String doctorNotes,
    required String diagnosticType,
  }) async {
    final db = await database;
    await db.insert(
      'Diagnostics',
      {
        'patient_id': patientId,
        'doctor_id': doctorId,
        'ai_result': aiResult,
        'doctor_notes': doctorNotes,
        'diagnostic_type': diagnosticType,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<void> updateDoctorProfile(
      String doctorId, {
      required String name,
      required String email,
      required String phone,
    }) async {
    final db = await database;
    final parts = name.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    await db.update(
      'Doctors',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
      },
      where: 'syndicate_id = ?',
      whereArgs: [doctorId],
    );
  }

  static Future<void> updateDoctorPassword(String doctorId, String newPassword) async {
    final db = await database;
    await db.update(
      'Doctors',
      {'password': newPassword},
      where: 'syndicate_id = ?',
      whereArgs: [doctorId],
    );
  }

  static Future<void> updateDoctorProfileImage(String doctorId, String imagePath) async {
    final db = await database;
    await db.update(
      'Doctors',
      {'profile_image': imagePath},
      where: 'syndicate_id = ?',
      whereArgs: [doctorId],
    );
  }

  // Insert a new alert
  static Future<void> insertAlert({
    required String doctorId,
    required String patientId,
    required String title,
    required String description,
    String status = 'unread',
    DateTime? dateTime,
  }) async {
    final db = await database;
    await db.insert(
      'Alerts',
      {
        'doctor_id': doctorId,
        'patient_id': patientId,
        'title': title,
        'description': description,
        'datetime': (dateTime ?? DateTime.now()).toIso8601String(),
        'status': status,
      },
    );
  }
  
  // Fetch all alerts for a doctor, newest first
  static Future<List<Map<String, dynamic>>> getDoctorAlerts(String doctorId) async {
    final db = await database;
    return await db.query(
      'Alerts',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
      orderBy: 'datetime DESC',
    );
  }
  
  // Mark alert as read
  static Future<void> markAlertAsRead(int alertId) async {
    final db = await database;
    await db.update(
      'Alerts',
      {'status': 'read'},
      where: 'id = ?',
      whereArgs: [alertId],
    );
  }
  
  // Mark alert as unread
  static Future<void> markAlertAsUnread(int alertId) async {
    final db = await database;
    await db.update(
      'Alerts',
      {'status': 'unread'},
      where: 'id = ?',
      whereArgs: [alertId],
    );
  }
  
  // Delete alert
  static Future<void> deleteAlert(int alertId) async {
    final db = await database;
    await db.delete(
      'Alerts',
      where: 'id = ?',
      whereArgs: [alertId],
    );
  }

  // Fetch all reports for a doctor with patient details
  static Future<List<Map<String, dynamic>>> getDoctorReports(String doctorId) async {
  final db = await database;
  return await db.rawQuery('''
    SELECT Diagnostics.diagnostic_id, Diagnostics.patient_id, Diagnostics.diagnostic_type, Diagnostics.ai_result, Diagnostics.created_at,
           Patients.first_name, Patients.last_name, Patients.national_id
    FROM Diagnostics
    JOIN Patients ON Diagnostics.patient_id = Patients.national_id
    WHERE Diagnostics.doctor_id = ?
    ORDER BY Diagnostics.created_at DESC
  ''', [doctorId]);
}

}
