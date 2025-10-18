import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/form_text_field.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _image = TextEditingController();
  String _state = 'Activo'; // para editar

  Map<String, dynamic>? _original;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && _original == null && args is Map<String, dynamic>) {
      _original = args;
      _name.text = (args['product_name'] ?? '').toString();
      _price.text = (args['product_price'] ?? '').toString();
      _image.text = (args['product_image'] ?? '').toString();
      _state = (args['product_state'] ?? 'Activo').toString();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _image.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final vm = context.read<ProductsProvider>();
    try {
      if (_original == null) {
        await vm.add(
          _name.text.trim(),
          num.parse(_price.text),
          _image.text.trim(),
        );
      } else {
        final id = _original!['product_id'] ?? _original!['id'];
        await vm.edit(
          id,
          _name.text.trim(),
          num.parse(_price.text),
          _image.text.trim(),
          _state,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo guardar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _original != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  FormTextField(
                    controller: _name,
                    label: 'Nombre',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                  const SizedBox(height: 12),
                  FormTextField(
                    controller: _price,
                    label: 'Precio',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      final n = num.tryParse(v);
                      if (n == null) return 'Número inválido';
                      if (n < 0) return 'No negativo';
                      return null;
                    },
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  const SizedBox(height: 12),
                  FormTextField(
                    controller: _image,
                    label: 'URL de imagen',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    prefixIcon: const Icon(Icons.link),
                  ),
                  if (isEdit) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _state,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Activo',
                          child: Text('Activo'),
                        ),
                        DropdownMenuItem(
                          value: 'Inactivo',
                          child: Text('Inactivo'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _state = v ?? 'Activo'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
