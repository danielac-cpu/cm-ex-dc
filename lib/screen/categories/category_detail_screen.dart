import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final it =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (it == null) {
      return const Scaffold(body: Center(child: Text('Sin datos')));
    }

    final name = (it['category_name'] ?? '').toString();
    final state = (it['category_state'] ?? 'Activa').toString();

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Estado: $state', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
