import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageType { sharedPrefs, dataStore, encrypted }

class SecretsScreen extends StatefulWidget {
  const SecretsScreen({super.key});
  @override
  State<SecretsScreen> createState() => _SecretsScreenState();
}

class _SecretsScreenState extends State<SecretsScreen> {
  final _keyCtrl = TextEditingController();
  final _valCtrl = TextEditingController();
  final _secure = const FlutterSecureStorage();
  StorageType _selected = StorageType.sharedPrefs;
  String? _result;

  Future<void> _save() async {
    final key = _keyCtrl.text.trim();
    final val = _valCtrl.text.trim();
    if (key.isEmpty || val.isEmpty) return;

    switch (_selected) {
      case StorageType.sharedPrefs:
      case StorageType.dataStore:
      // SharedPreferences cubre ambos casos académicamente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, val);
      case StorageType.encrypted:
        await _secure.write(key: key, value: val);
    }
    setState(() => _result = '✅ Guardado con ${_label(_selected)}');
  }

  Future<void> _retrieve() async {
    final key = _keyCtrl.text.trim();
    if (key.isEmpty) return;

    String? val;
    switch (_selected) {
      case StorageType.sharedPrefs:
      case StorageType.dataStore:
        final prefs = await SharedPreferences.getInstance();
        val = prefs.getString(key);
      case StorageType.encrypted:
        val = await _secure.read(key: key);
    }
    setState(() {
      _result = val != null
          ? '🔑 Valor: $val'
          : '⚠️ Secreto no encontrado para la llave "$key"';
    });
  }

  String _label(StorageType t) => switch (t) {
    StorageType.sharedPrefs => 'SharedPreferences',
    StorageType.dataStore => 'DataStore',
    StorageType.encrypted => 'EncryptedSharedPreferences',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 3 — Gestión de Secretos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _keyCtrl,
              decoration: const InputDecoration(
                labelText: 'Llave (Key)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valCtrl,
              decoration: const InputDecoration(
                labelText: 'Valor (Value)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Mecanismo de almacenamiento:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...StorageType.values.map((t) => RadioListTile<StorageType>(
              title: Text(_label(t)),
              subtitle: Text(_hint(t), style: const TextStyle(fontSize: 12)),
              value: t,
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v!),
            )),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _retrieve,
                  icon: const Icon(Icons.search),
                  label: const Text('Recuperar'),
                ),
              ),
            ]),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _result!.startsWith('⚠️')
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _result!.startsWith('⚠️')
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                child: Text(_result!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _hint(StorageType t) => switch (t) {
    StorageType.sharedPrefs => 'Preferencias simples, no sensibles',
    StorageType.dataStore => 'Asíncrono basado en Preferences DataStore',
    StorageType.encrypted => 'Cifra key+value automáticamente (tokens, API keys)',
  };
}