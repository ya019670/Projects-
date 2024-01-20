import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'voting_database.db';
  static final _databaseVersion = 1;

  // Define the table names and columns
  static final tableCandidates = 'candidates';
  static final tableVotes = 'votes';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnNumber = 'number';
  static final columnElectionProgram = 'electionProgram';
  static final columnState = 'state';
  static final columnCity = 'city';
  static final columnParty = 'party';

  static final columnUserId = 'userId';
  static final columnCandidateId = 'candidateId';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableCandidates (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnNumber INTEGER NOT NULL,
      $columnElectionProgram TEXT NOT NULL,
      $columnState TEXT NOT NULL,
      $columnCity TEXT NOT NULL,
      $columnParty TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE $tableVotes (
      $columnId INTEGER PRIMARY KEY,
      $columnUserId TEXT NOT NULL,
      $columnCandidateId INTEGER NOT NULL,
      FOREIGN KEY ($columnCandidateId) REFERENCES $tableCandidates ($columnId)
    )
  ''');
  }

  // Add a candidate to the candidates table
  Future<int> addCandidate(String name, int number, String electionProgram,
      String state, String city, String party) async {
    Database db = await instance.database;
    return await db.insert(
      tableCandidates,
      {
        columnName: name,
        columnNumber: number,
        columnElectionProgram: electionProgram,
        columnState: state,
        columnCity: city,
        columnParty: party,
      },
    );
  }

  // Delete a candidate from the candidates table
  Future<int> deleteCandidate(int candidateId) async {
    Database db = await instance.database;
    return await db.delete(
      tableCandidates,
      where: '$columnId = ?',
      whereArgs: [candidateId],
    );
  }

  // Add a vote to the votes table
  Future<int> addVote(String userId, int candidateId) async {
    Database db = await instance.database;
    return await db.insert(
      tableVotes,
      {columnUserId: userId, columnCandidateId: candidateId},
    );
  }

  // Delete a vote from the votes table (if needed)
  Future<int> deleteVote(int voteId) async {
    Database db = await instance.database;
    return await db.delete(
      tableVotes,
      where: '$columnId = ?',
      whereArgs: [voteId],
    );
  }
}
