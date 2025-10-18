import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final route = ModalRoute.of(context)?.settings.name;

    Widget item({
      required String title,
      required IconData icon,
      required String routeName,
    }) {
      final selected = route == routeName;
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        selected: selected,
        onTap: () {
          if (selected) {
            Navigator.pop(context); // cierra el drawer
            return;
          }
          Navigator.pushReplacementNamed(context, routeName);
        },
      );
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(''),
              accountEmail: Text(user?.email ?? 'Usuario'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            item(
              title: 'Productos',
              icon: Icons.store_outlined,
              routeName: AppRoutes.products,
            ),
            item(
              title: 'Categorías',
              icon: Icons.category_outlined,
              routeName: AppRoutes.categories,
            ),
            item(
              title: 'Proveedores',
              icon: Icons.local_shipping,
              routeName: AppRoutes.suppliers,
            ),
            const Spacer(),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await context.read<AuthProvider>().signOut();
                // Limpia la pila y vuelve al login
                // pop del drawer primero
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
