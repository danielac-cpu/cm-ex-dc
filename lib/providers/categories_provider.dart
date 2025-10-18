import 'package:flutter/foundation.dart';
import '../services/categories_service.dart';

class CategoriesProvider extends ChangeNotifier {
  final _svc = CategoriesService();
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

  Future<void> add(String name) async {
    await _svc.create(name: name);
    await load();
  }

  Future<void> edit(int id, String name, String state) async {
    await _svc.update(id: id, name: name, state: state);
    await load();
  }

  Future<void> delete(int id) async {
    await _svc.remove(id);
    items.removeWhere((e) => (e['category_id'] ?? e['id']) == id);
    notifyListeners();
  }
}
