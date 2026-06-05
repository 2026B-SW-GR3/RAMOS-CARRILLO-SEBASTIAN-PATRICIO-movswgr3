import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const _base = 'https://jsonplaceholder.typicode.com';

  Future<Post> getPost(int id) async {
    final res = await http.get(Uri.parse('$_base/posts/$id'));
    if (res.statusCode == 200) return Post.fromJson(jsonDecode(res.body));
    throw Exception('Error al obtener post');
  }

  Future<Post> updatePost(Post post) async {
    final res = await http.put(
      Uri.parse('$_base/posts/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if (res.statusCode == 200) return Post.fromJson(jsonDecode(res.body));
    throw Exception('Error al actualizar post');
  }
}