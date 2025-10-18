import 'dart:convert';
import 'api_service.dart';

class SuppliersService extends ApiService {
  bool _ok(int code) => code == 200 || code == 201;

  Future<List<Map<String, dynamic>>> fetchList() async {
    final res = await get('ejemplos/provider_list_rest/');
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

  Future<void> create({
    required String name,
    required String lastName,
    required String email,
    required String state,
  }) async {
    final res = await post('ejemplos/provider_add_rest/', {
      'provider_name': name,
      'provider_last_name': lastName,
      'provider_mail': email,
      'provider_state': state,
    });
    if (!_ok(res.statusCode)) {
      throw Exception('POST add error: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> update({
    required int id,
    required String name,
    required String lastName,
    required String email,
    required String state,
  }) async {
    final res = await post('ejemplos/provider_edit_rest/', {
      'provider_id': id,
      'provider_name': name,
      'provider_last_name': lastName,
      'provider_mail': email,
      'provider_state': state,
    });
    if (!_ok(res.statusCode)) {
      throw Exception('POST edit error: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> remove(int id) async {
    final res = await post('ejemplos/provider_del_rest/', {'provider_id': id});
    if (!_ok(res.statusCode)) {
      throw Exception('POST delete error: ${res.statusCode} ${res.body}');
    }
  }
}
