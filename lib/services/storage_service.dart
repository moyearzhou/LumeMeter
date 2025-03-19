import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StorageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'lightmeter.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE shots(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp INTEGER NOT NULL,
            ev REAL NOT NULL,
            iso INTEGER NOT NULL,
            shutter_speed REAL NOT NULL,
            aperture REAL NOT NULL,
            image_path TEXT,
            metering_mode TEXT NOT NULL
          )
          ''',
        );
      },
    );
  }

  Future<int> saveShot({
    required double ev,
    required int iso,
    required double shutterSpeed,
    required double aperture,
    required String meteringMode,
    String? imagePath,
  }) async {
    final db = await database;
    return await db.insert(
      'shots',
      {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'ev': ev,
        'iso': iso,
        'shutter_speed': shutterSpeed,
        'aperture': aperture,
        'metering_mode': meteringMode,
        'image_path': imagePath,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getShots() async {
    final db = await database;
    return await db.query('shots', orderBy: 'timestamp DESC');
  }
}