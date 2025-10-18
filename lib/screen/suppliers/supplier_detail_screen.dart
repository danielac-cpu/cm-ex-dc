import 'package:flutter/material.dart';

class SupplierDetailScreen extends StatelessWidget {
  const SupplierDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final it =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (it == null) {
      return const Scaffold(body: Center(child: Text('Sin datos')));
    }

    final name = (it['provider_name'] ?? '').toString();
    final last = (it['provider_last_name'] ?? '').toString();
    final mail = (it['provider_mail'] ?? '').toString();
    final state = (it['provider_state'] ?? 'Activo').toString();

    return Scaffold(
      appBar: AppBar(title: Text('$name $last')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Correo: $mail', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Estado: $state'),
        ],
      ),
    );
  }
}
