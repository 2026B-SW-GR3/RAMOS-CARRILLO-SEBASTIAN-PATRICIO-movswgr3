import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/db_provider.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});
  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DbProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo 2 — Persistencia Dual'),
        actions: [
          Row(children: [
            Text(
              db.useSQL ? 'SQL' : 'NoSQL',
              style: TextStyle(
                color: db.useSQL ? Colors.blue : Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: db.useSQL,
              onChanged: db.toggle,
            ),
          ]),
        ],
      ),
      body: Column(
        children: [
          // Indicador visual del modo actual
          Container(
            color: db.useSQL ? Colors.blue.shade50 : Colors.purple.shade50,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Row(children: [
              Icon(
                db.useSQL ? Icons.storage : Icons.folder_open,
                size: 16,
                color: db.useSQL ? Colors.blue : Colors.purple,
              ),
              const SizedBox(width: 8),
              Text(
                db.useSQL ? 'Origen: SQLite (relacional)' : 'Origen: Hive (NoSQL)',
                style: TextStyle(
                  color: db.useSQL ? Colors.blue.shade800 : Colors.purple.shade800,
                  fontSize: 13,
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Nuevo ítem',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_ctrl.text.isNotEmpty) {
                    db.add(_ctrl.text);
                    _ctrl.clear();
                  }
                },
                child: const Text('Agregar'),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: db.items.length,
              itemBuilder: (_, i) => ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(db.items[i].name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => db.remove(i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}