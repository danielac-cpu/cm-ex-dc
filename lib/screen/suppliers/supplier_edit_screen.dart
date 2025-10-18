import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/suppliers_provider.dart';
import '../../widgets/form_text_field.dart';
import '../../utils/validators.dart';

class SupplierEditScreen extends StatefulWidget {
  const SupplierEditScreen({super.key});

  @override
  State<SupplierEditScreen> createState() => _SupplierEditScreenState();
}

class _SupplierEditScreenState extends State<SupplierEditScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _last = TextEditingController();
  final _mail = TextEditingController();
  String _state = 'Activo';
  Map<String, dynamic>? _original;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && _original == null && args is Map<String, dynamic>) {
      _original = args;
      _name.text = (args['provider_name'] ?? '').toString();
      _last.text = (args['provider_last_name'] ?? '').toString();
      _mail.text = (args['provider_mail'] ?? '').toString();
      _state = (args['provider_state'] ?? 'Activo').toString();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _last.dispose();
    _mail.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final vm = context.read<SuppliersProvider>();
    try {
      if (_original == null) {
        await vm.add(
          _name.text.trim(),
          _last.text.trim(),
          _mail.text.trim(),
          _state,
        );
      } else {
        final id = _original!['provider_id'] ?? _original!['id'];
        await vm.edit(
          id,
          _name.text.trim(),
          _last.text.trim(),
          _mail.text.trim(),
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
        title: Text(isEdit ? 'Editar proveedor' : 'Nuevo proveedor'),
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
                    validator: Validators.required,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 12),
                  FormTextField(
                    controller: _last,
                    label: 'Apellido',
                    validator: Validators.required,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  const SizedBox(height: 12),
                  FormTextField(
                    controller: _mail,
                    label: 'Correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _state,
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: const [
                      DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                      DropdownMenuItem(
                        value: 'Inactivo',
                        child: Text('Inactivo'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _state = v ?? 'Activo'),
                  ),
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
