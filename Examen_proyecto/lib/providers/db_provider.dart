import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/sqlite_service.dart';
import '../services/hive_service.dart';

class DbProvider extends ChangeNotifier {
  bool useSQL = true; // true = SQLite, false = Hive
  List<Item> items = [];

  final _sql = SqliteService();
  final _hive = HiveService();

  Future<void> init() async => await _hive.init();

  Future<void> load() async {
    items = useSQL ? await _sql.getAll() : _hive.getAll();
    notifyListeners();
  }

  Future<void> toggle(bool value) async {
    useSQL = value;
    await load();
  }

  Future<void> add(String name) async {
    if (useSQL) {
      await _sql.insert(name);
    } else {
      await _hive.insert(name);
    }
    await load();
  }

  Future<void> remove(int indexOrId) async {
    if (useSQL) {
      await _sql.delete(items[indexOrId].id!);
    } else {
      await _hive.delete(indexOrId);
    }
    await load();
  }
}