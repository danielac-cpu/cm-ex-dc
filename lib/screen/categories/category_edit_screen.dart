import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/categories_provider.dart';
import '../../widgets/form_text_field.dart';

class CategoryEditScreen extends StatefulWidget {
  const CategoryEditScreen({super.key});

  @override
  State<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _state = 'Activa';
  Map<String, dynamic>? _original;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && _original == null && args is Map<String, dynamic>) {
      _original = args;
      _name.text = (args['category_name'] ?? '').toString();
      _state = (args['category_state'] ?? 'Activa').toString();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final vm = context.read<CategoriesProvider>();
    try {
      if (_original == null) {
        await vm.add(_name.text.trim());
      } else {
        final id = _original!['category_id'] ?? _original!['id'];
        await vm.edit(id, _name.text.trim(), _state);
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
        title: Text(isEdit ? 'Editar categoría' : 'Nueva categoría'),
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
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  if (isEdit) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _state,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Activa',
                          child: Text('Activa'),
                        ),
                        DropdownMenuItem(
                          value: 'Inactiva',
                          child: Text('Inactiva'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _state = v ?? 'Activa'),
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
