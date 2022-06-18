import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLDatabase {
  // * Private Constructor
  SQLDatabase._init();

  // * Global Field => instance calling the constructor
  static final SQLDatabase instance = SQLDatabase._init();

  // * Field For Database => From SQFLite Package
  static Database? _database;

  // * Open Database
  Future<Database> get database async {
    // * Return database if it already exists
    if (_database != null) return _database!;
    // * Otherwise initialize the database
    _database = await _initializeDatabase('notes.db');
    return _database!;
  }

  // * Initialize The Database
  Future<Database> _initializeDatabase(String filePath) async {
    // On Android, it is typically data/data/ /databases
    // On iOS and MacOS, it is the Documents directory.
    // Note for iOS: Using path_provider is recommended to get the databases
    // directory. The most appropriate location on iOS would be the Library
    // directory that you could get from the path_provider package
    // await getApplicationDocumentsDirectory()
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);

    return await openDatabase(
      path,
      version: 1, // * Everytime if we increment the version number by 1,
      // for new version of out data table, then it is going inside of onUpgrade method
      onCreate: _createDatabase,
      // * If we want to update our Scheme and also want to include other
      // fields or other data tables, then we always can do it here onUpgrade:
    );
  }

  // * Create Database Table
  Future _createDatabase(Database database, int version) async {}

  Future close() async {
    // * Access The Database
    final database = await instance.database;
    database.close();
  }
}
