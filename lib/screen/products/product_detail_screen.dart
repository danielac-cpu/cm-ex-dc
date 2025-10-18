import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final it = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (it == null) {
      return const Scaffold(body: Center(child: Text('Sin datos')));
    }
    final name = (it['product_name'] ?? '').toString();
    final price = (it['product_price'] ?? '').toString();
    final img = (it['product_image'] ?? '').toString();
    final state = (it['product_state'] ?? 'Activo').toString();

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (img.isNotEmpty)
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.network(img, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          Text('Precio: \$ $price', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Estado: $state'),
        ],
      ),
    );
  }
}
