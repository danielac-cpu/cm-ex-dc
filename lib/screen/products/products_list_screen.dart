import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/empty_state.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});
  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<ProductsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductsProvider>();

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
                onPressed: () => context.read<ProductsProvider>().load(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else if (vm.items.isEmpty) {
      body = EmptyState(
        icon: Icons.store_outlined,
        title: 'Sin productos',
        message: 'Aún no has agregado productos. ¡Crea el primero!',
        cta: 'Nuevo producto',
        onAction: () => Navigator.pushNamed(context, AppRoutes.productEdit),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.items.length,
        itemBuilder: (_, i) {
          final it = vm.items[i];
          final id = it['product_id'] ?? it['id'];
          final name = (it['product_name'] ?? '').toString();
          final price = (it['product_price'] ?? '').toString();
          final img = (it['product_image'] ?? '').toString();
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: img.isNotEmpty ? NetworkImage(img) : null,
                child: img.isEmpty
                    ? const Icon(Icons.image_not_supported)
                    : null,
              ),
              title: Text(name),
              subtitle: Text('\$ $price'),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.productDetail,
                arguments: it,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.productEdit,
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
                      if (ok == true && id != null && mounted) {
                        await context.read<ProductsProvider>().delete(id);
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
      appBar: AppBar(title: const Text('Productos')),
      drawer: const AppNavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.productEdit),
        child: const Icon(Icons.add),
      ),
      body: body,
    );
  }
}
