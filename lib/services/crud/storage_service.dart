import 'package:astrum_test_app/services/crud/record_model.dart';
import 'package:astrum_test_app/services/crud/storage_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StorageService {
// Making the service as singleton
  StorageService._privateConstructor();
  static final StorageService _singleton = StorageService._privateConstructor();
  factory StorageService() => _singleton;

  Database? _db;
  // Handy function to make sure the [_db] is not null
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw 'DB is null';
    return db;
  }

  // When the trip starts we create and update on the way
  Future<int> createRecord(RecordModel note) async {
    final db = _getDatabaseOrThrow();
    final id = await db.insert(tableName, note.toRow());

    return id;
  }

  // To show in the history page
  Future<List<RecordModel>> readAllRecords() async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(tableName);
    return result.map((note) => RecordModel.fromRow(note)).toList();
  }

  // We need to update a record not to lose the data we have
  Future<void> updateRecord(RecordModel note) async {
    final db = _getDatabaseOrThrow();
    await db.update(
      tableName,
      {distanceColumn: note.distance},
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Opening the DB
  Future<void> open() async {
    try {
      final appDocsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(recordTableString);
    } on MissingPlatformDirectoryException {
      rethrow;
    }
  }
}
