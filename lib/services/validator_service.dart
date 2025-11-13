class ValidatorService {
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Al menos 8 caracteres, una mayúscula, una minúscula y un número
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@\$!%*?&.]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  String? emailValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Correo obligatorio';
    if (!isValidEmail(value)) return 'Correo inválido';
    return null;
  }

  String? passwordValidator(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Contraseña obligatoria';
    if (!isValidPassword(value)) return 'La contraseña debe tener 8 caracteres, una mayúscula, una minúscula y un número';
    return null;
  }
  

}