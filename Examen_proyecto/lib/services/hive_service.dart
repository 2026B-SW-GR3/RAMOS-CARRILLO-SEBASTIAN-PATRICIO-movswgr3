import 'package:hive_flutter/hive_flutter.dart';
import '../models/item.dart';

class HiveService {
  static const _boxName = 'items';

  Box<Item> get box => Hive.box<Item>(_boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Item>(_boxName);
    }
  }

  List<Item> getAll() => box.values.toList();

  Future<void> insert(String name) => box.add(Item(name: name));

  Future<void> delete(int index) => box.deleteAt(index);
}