import 'dart:convert';
import 'api_service.dart';

class ProductsService extends ApiService {
  bool _ok(int code) => code == 200 || code == 201;

  Future<List<Map<String, dynamic>>> fetchList() async {
    final res = await get('ejemplos/product_list_rest/');
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
    required num price,
    required String image,
  }) async {
    final res = await post('ejemplos/product_add_rest/', {
      'product_name': name,
      'product_price': price,
      'product_image': image,
    });
    if (!_ok(res.statusCode)) {
      throw Exception('POST add error: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> update({
    required int id,
    required String name,
    required num price,
    required String image,
    required String state,
  }) async {
    final res = await post('ejemplos/product_edit_rest/', {
      'product_id': id,
      'product_name': name,
      'product_price': price,
      'product_image': image,
      'product_state': state,
    });
    if (!_ok(res.statusCode)) {
      throw Exception('POST edit error: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> remove(int id) async {
    final res = await post('ejemplos/product_del_rest/', {'product_id': id});
    if (!_ok(res.statusCode)) {
      throw Exception('POST delete error: ${res.statusCode} ${res.body}');
    }
  }
}
