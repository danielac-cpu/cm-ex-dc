import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/categories_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/empty_state.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});
  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoriesProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoriesProvider>();

    Widget body;
    if (vm.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (vm.error != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: ${vm.error}', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.read<CategoriesProvider>().load(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else if (vm.items.isEmpty) {
      body = EmptyState(
        icon: Icons.category_outlined,
        title: 'Sin categorías',
        message:
            'Aún no has agregado categorías. Crea la primera para organizar tus productos.',
        cta: 'Nueva categoría',
        onAction: () => Navigator.pushNamed(context, AppRoutes.categoryEdit),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.items.length,
        itemBuilder: (_, i) {
          final it = vm.items[i];
          final id = it['category_id'] ?? it['id'];
          final name = (it['category_name'] ?? '').toString();
          final state = (it['category_state'] ?? 'Activa').toString();
          return Card(
            child: ListTile(
              title: Text(name),
              subtitle: Text('Estado: $state'),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.categoryDetail,
                arguments: it,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.categoryEdit,
                      arguments: it,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Eliminar'),
                          content: Text('¿Eliminar "$name"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true && id != null) {
                        await context.read<CategoriesProvider>().delete(id);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      drawer: const AppNavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.categoryEdit),
        child: const Icon(Icons.add),
      ),
      body: body,
    );
  }
}
