class ValidationUtils {
  // Dominios de email permitidos
  static const List<String> allowedEmailDomains = [
    'yahoo.com',
    'gmail.com',
    'zohomail.com',
    'hotmail.com',
    'outlook.com',
  ];

  // Validar contraseña con requisitos específicos
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }

    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    // Verificar mayúscula
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una letra mayúscula';
    }

    // Verificar número
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }

    // Verificar carácter especial
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial (!@#\$%^&*(),.?":{}|<>)';
    }

    return null;
  }

  // Validar email con dominios permitidos
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Por favor ingresa tu email';
    }

    // Verificar formato básico de email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Por favor ingresa un email válido';
    }

    // Extraer dominio del email
    String domain = email.split('@')[1].toLowerCase();
    
    // Verificar si el dominio está permitido
    if (!allowedEmailDomains.contains(domain)) {
      return 'Solo se permiten emails de: ${allowedEmailDomains.join(', ')}';
    }

    return null;
  }

  // Validar confirmación de contraseña
  static String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }

    if (confirmPassword != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }
}

