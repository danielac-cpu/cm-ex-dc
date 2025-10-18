import 'package:flutter/foundation.dart';
import '../services/products_service.dart';

class ProductsProvider extends ChangeNotifier {
  final _svc = ProductsService();
  bool loading = false;
  String? error;
  List<Map<String, dynamic>> items = [];

  Future<void> load() async {
    try {
      loading = true;
      error = null;
      notifyListeners();
      items = await _svc.fetchList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> add(String name, num price, String image) async {
    await _svc.create(name: name, price: price, image: image);
    await load();
  }

  Future<void> edit(
    int id,
    String name,
    num price,
    String image,
    String state,
  ) async {
    await _svc.update(
      id: id,
      name: name,
      price: price,
      image: image,
      state: state,
    );
    await load();
  }

  Future<void> delete(int id) async {
    await _svc.remove(id);
    items.removeWhere((e) => (e['product_id'] ?? e['id']) == id);
    notifyListeners();
  }
}
