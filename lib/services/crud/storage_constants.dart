const String dbName = 'trip_records.db';
const String tableName = 'trip';
const String idColumn = 'id';
const String distanceColumn = 'distance';
const String dateColumn = 'date';

const String recordTableString = '''
CREATE TABLE IF NOT EXISTS $tableName (
$idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
$distanceColumn REAL NOT NULL,
$dateColumn TEXT NOT NULL
);''';
