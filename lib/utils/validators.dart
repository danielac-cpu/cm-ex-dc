class Validators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu email';
    if (!v.contains('@')) return 'Email inválido';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Requerido';
    return null;
  }
}
