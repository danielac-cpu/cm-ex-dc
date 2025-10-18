import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/suppliers_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/empty_state.dart';

class SuppliersListScreen extends StatefulWidget {
  const SuppliersListScreen({super.key});
  @override
  State<SuppliersListScreen> createState() => _SuppliersListScreenState();
}

class _SuppliersListScreenState extends State<SuppliersListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<SuppliersProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SuppliersProvider>();

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
                onPressed: () => context.read<SuppliersProvider>().load(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else if (vm.items.isEmpty) {
      body = EmptyState(
        icon: Icons.local_shipping_outlined,
        title: 'Sin proveedores',
        message:
            'Cuando agregues proveedores, podrás vincularlos a tus productos.',
        cta: 'Nuevo proveedor',
        onAction: () => Navigator.pushNamed(context, AppRoutes.supplierEdit),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.items.length,
        itemBuilder: (_, i) {
          final it = vm.items[i];
          final id = it['provider_id'] ?? it['id'];
          final name = (it['provider_name'] ?? '').toString();
          final last = (it['provider_last_name'] ?? '').toString();
          final mail = (it['provider_mail'] ?? '').toString();
          final state = (it['provider_state'] ?? 'Activo').toString();
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.local_shipping_outlined),
              ),
              title: Text('$name $last'),
              subtitle: Text('$mail  •  $state'),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.supplierDetail,
                arguments: it,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.supplierEdit,
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
                          content: Text('¿Eliminar "$name $last"?'),
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
                      if (ok == true && id != null && mounted) {
                        await context.read<SuppliersProvider>().delete(id);
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
      appBar: AppBar(title: const Text('Proveedores')),
      drawer: const AppNavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.supplierEdit),
        child: const Icon(Icons.add),
      ),
      body: body,
    );
  }
}
