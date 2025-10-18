import 'dart:convert';
import 'api_service.dart';

class CategoriesService extends ApiService {
  bool _ok(int code) => code == 200 || code == 201;

  Future<List<Map<String, dynamic>>> fetchList() async {
    final res = await get('ejemplos/category_list_rest/');
    if (!_ok(res.statusCode)) {
      throw Exception('GET list error: ${res.statusCode} ${res.body}');
    }
    final data = jsonDecode(res.body);
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['listado'] is List) {
      return (data['listado'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> create({required String name}) async {
    final res = await post('ejemplos/category_add_rest/', {
      'category_name': name,
    });
    if (!_ok(res.statusCode)) {
      throw Exception('POST add error: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> update({
    required int id,
    required String name,
    required String state,
  }) async {
    final res = await post('ejemplos/category_edit_rest/', {
      'category_id': id,
      'category_name': name,
      'category_state': state,
    });
    if (!_ok(res.statusCode)) {
      throw Exception('POST edit error: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> remove(int id) async {
    final res = await post('ejemplos/category_del_rest/', {'category_id': id});
    if (!_ok(res.statusCode)) {
      throw Exception('POST delete error: ${res.statusCode} ${res.body}');
    }
  }
}
