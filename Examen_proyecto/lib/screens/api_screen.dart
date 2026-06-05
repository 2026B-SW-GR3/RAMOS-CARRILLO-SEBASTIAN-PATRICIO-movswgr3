import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});
  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _svc = ApiService();

  bool _loading = false;
  Post? _post;
  String? _message;

  Future<void> _getPost() async {
    final id = int.tryParse(_idController.text);
    if (id == null) return;
    setState(() { _loading = true; _message = null; });
    try {
      final post = await _svc.getPost(id);
      setState(() {
        _post = post;
        _titleController.text = post.title;
        _bodyController.text = post.body;
      });
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _updatePost() async {
    if (_post == null) return;
    setState(() { _loading = true; _message = null; });
    try {
      final updated = Post(
        id: _post!.id,
        title: _titleController.text,
        body: _bodyController.text,
      );
      await _svc.updatePost(updated);
      setState(() => _message = '✅ Actualizado correctamente (respuesta 200 OK)');
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 1 — API REST')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ID del post',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _loading ? null : _getPost,
                child: const Text('Obtener'),
              ),
            ]),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            if (_post != null) ...[
              TextField(
                controller: _titleController,
                enabled: !_loading,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bodyController,
                enabled: !_loading,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Cuerpo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _updatePost,
                child: const Text('Actualizar'),
              ),
            ],
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!, style: TextStyle(
                color: _message!.startsWith('✅')
                    ? Colors.green
                    : Colors.red,
              )),
            ],
          ],
        ),
      ),
    );
  }
}