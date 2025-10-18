import 'package:flutter/foundation.dart';
import '../services/providers_service.dart';

class SuppliersProvider extends ChangeNotifier {
  final _svc = SuppliersService();
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

  Future<void> add(
    String name,
    String lastName,
    String email,
    String state,
  ) async {
    await _svc.create(
      name: name,
      lastName: lastName,
      email: email,
      state: state,
    );
    await load();
  }

  Future<void> edit(
    int id,
    String name,
    String lastName,
    String email,
    String state,
  ) async {
    await _svc.update(
      id: id,
      name: name,
      lastName: lastName,
      email: email,
      state: state,
    );
    await load();
  }

  Future<void> delete(int id) async {
    await _svc.remove(id);
    items.removeWhere((e) => (e['provider_id'] ?? e['id']) == id);
    notifyListeners();
  }
}
