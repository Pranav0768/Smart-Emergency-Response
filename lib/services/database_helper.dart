import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/incident.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('incidents.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE incidents (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  priority TEXT NOT NULL,
  location TEXT NOT NULL,
  status TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  assignedResponder TEXT,
  isSynced INTEGER NOT NULL
)
''');
  }

  Future<Incident> create(Incident incident) async {
    final db = await instance.database;
    await db.insert('incidents', incident.toMap());
    return incident;
  }

  Future<Incident> readIncident(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'incidents',
      columns: ['id', 'title', 'description', 'category', 'priority', 'location', 'status', 'timestamp', 'assignedResponder', 'isSynced'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Incident.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Incident>> readAllIncidents() async {
    final db = await instance.database;
    const orderBy = 'timestamp DESC';
    final result = await db.query('incidents', orderBy: orderBy);
    return result.map((json) => Incident.fromMap(json)).toList();
  }

  Future<int> update(Incident incident) async {
    final db = await instance.database;
    return db.update(
      'incidents',
      incident.toMap(),
      where: 'id = ?',
      whereArgs: [incident.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      'incidents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
