import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CandidateDatabaseHelper {
  static final CandidateDatabaseHelper instance = CandidateDatabaseHelper._privateConstructor();
  static Database? _database;

  CandidateDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'candidates_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE candidates(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        details TEXT,
        city TEXT,
        state TEXT,
        extraInfo TEXT,
        image TEXT,
        votes INTEGER
      )
    ''');
  }

  Future<void> updateVotes(int candidateId, int newVotes) async {
    final db = await database;
    await db.update(
      'candidates',
      {'votes': newVotes},
      where: 'id = ?',
      whereArgs: [candidateId],
    );
  }


  Future<void> insertCandidate(Map<String, dynamic> candidate) async {
    final db = await database;
    await db.insert('candidates', {
      ...candidate,
      'votes': candidate['votes'] ?? 0, // Set default value if not provided
    });
  }

  Future<List<Map<String, dynamic>>> getCandidates({String? city, String? state}) async {
    final db = await database;
    return await db.query('candidates', where: 'city = ? AND state = ?', whereArgs: [city, state]);
  }

  Future<List<Map<String, dynamic>>> getAllCandidates() async {
    final db = await database;
    return await db.query('candidates');
  }

  Future<void> deleteCandidateByName(String candidateName) async {
    final db = await database;
    await db.delete(
      'candidates',
      where: 'name = ?',
      whereArgs: [candidateName],
    );
  }

  Future<List<Map<String, dynamic>>> getCandidatesByStateAndCity(
      {required String state, required String city}) async {
    final db = await database;
    return await db.query('candidates',
        where: 'state = ? AND city = ?', whereArgs: [state, city]);
  }




}
