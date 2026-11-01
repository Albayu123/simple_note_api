import 'dart:convert';
import 'package:http/http.dart' as http;

class ToDoService {
  static const String baseUrl = 'https://6ad2145766cd28aed82d9a74.mockapi.io/api/v1/todos';

  // GET: mengambil list todo
  static Future<List?> fetchToDo() async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json is List) {
          return json;
        } else if (json is Map && json.containsKey('items')) {
          return json['items'] as List;
        }
        return [];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // POST: menambah todo baru
  static Future<bool> addToDo(Map body) async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // PUT: mengedit data todo berdasarkan ID
  static Future<bool> updateToDo(String id, Map body) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Toggle status completed
  static Future<bool> toggleStatus(String id, Map currentItem, bool isCompleted) async {
    final updated = Map<String, dynamic>.from(currentItem);
    updated['is_completed'] = isCompleted;
    return updateToDo(id, updated);
  }

  // DELETE: menghapus todo berdasarkan ID
  static Future<bool> deleteById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');
      final response = await http.delete(uri);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
