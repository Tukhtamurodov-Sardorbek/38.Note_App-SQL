import 'package:note_app_sql_database/models/note.dart';
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

  // * Initialize Database
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
  Future _createDatabase(Database database, int version) async {
    // * Define Type
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    // * Define all the Columns inside of the parenthesis (Column name & Type,)
    // * In order to create multiple data tables => simply duplicate the following
    //   and then create the next data table...
    await database.execute('''
CREATE TABLE $tableNotes (
    ${NoteFields.id} $idType,
    ${NoteFields.isImportant} $boolType,
    ${NoteFields.title} $textType,
    ${NoteFields.description} $textType,
    ${NoteFields.time} $textType
    )
''');
  }

  /// CRUD
  Future<Note> create(Note note) async {
    // * Reference to database
    final database = await instance.database;
    /*
    In order to create our own SQL statements
    final json = note.toJson();
    final columns = '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    final values = '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    final id = await database.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
     */
    // The whole code above does the same thing the code below does
    final id = await database.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> read(int id) async {
    // * Reference to database
    final database = await instance.database;

    final maps = await database.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?', // Should be as much as args list length
      whereArgs: [id], // For each question marks, the args are put
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID: $id not found');
    }
  }

  Future<List<Note>> readAll(bool isAscendingOrder, bool byTime) async {
    // * Reference to database
    final database = await instance.database;
    // timeOrImportance == true => time else => isImportant
    // final orderBy = isAscendingOrder ? '${NoteFields.time} ASC' : '${NoteFields.time} DESC'; // ASC = ascending order
    // final orderBy = isAscendingOrder ? '${NoteFields.isImportant} ASC' : '${NoteFields.isImportant} DESC'; // ASC = ascending order

    final orderBy = isAscendingOrder && byTime
        ? '${NoteFields.time} ASC'
        : !isAscendingOrder && byTime
            ? '${NoteFields.time} DESC'
            : isAscendingOrder && !byTime
                ? '${NoteFields.isImportant} ASC'
                : '${NoteFields.isImportant} DESC'; // ASC = ascending order

    // final orderBy = '${NoteFields.time} DESC'; // ASC = descending order
    final result = await database.query(tableNotes, orderBy: orderBy);

    // * In order to create our own query statement
    // final result = await database.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    // * Reference to database
    final database = await instance.database;
    // * In order to use a SQL statement => use database.rawUpdate
    return database.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    // * Reference to database
    final database = await instance.database;

    return await database.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future deleteAll(List<int> id) async {
    // * Reference to database
    final database = await instance.database;

    for(int i = 0; i < id.length; i++){
      await database.delete(
        tableNotes,
        where: '${NoteFields.id} = ?',
        whereArgs: [id[i]],
      );
    }
  }

  Future close() async {
    // * Access The Database
    final database = await instance.database;
    database.close();
  }
}
