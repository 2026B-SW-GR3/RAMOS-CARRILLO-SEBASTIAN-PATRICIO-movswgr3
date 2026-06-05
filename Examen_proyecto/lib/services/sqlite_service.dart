import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class SqliteService {
  static Database? _db;

  Future<Database> get db async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'items.db'),
      version: 1,
      onCreate: (db, _) => db.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
      ),
    );
    return _db!;
  }

  Future<List<Item>> getAll() async {
    final rows = await (await db).query('items');
    return rows.map((r) => Item(id: r['id'] as int, name: r['name'] as String)).toList();
  }

  Future<void> insert(String name) async =>
      (await db).insert('items', {'name': name});

  Future<void> delete(int id) async =>
      (await db).delete('items', where: 'id = ?', whereArgs: [id]);
}