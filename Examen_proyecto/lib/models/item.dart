import 'package:hive/hive.dart';

part 'item.g.dart'; // generado por build_runner

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  int? id; // solo para SQLite

  @HiveField(1)
  String name;

  Item({this.id, required this.name});
}