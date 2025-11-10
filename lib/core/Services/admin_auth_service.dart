import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthService {
  static final AdminAuthService _instance = AdminAuthService._internal();
  factory AdminAuthService() => _instance;
  AdminAuthService._internal();

  // Credenciales hardcodeadas (temporal)
  static const String _adminUsername = 'admin';
  static const String _adminPassword = 'adminpass123';
  static const String _adminSessionKey = 'admin_session';

  // Verificar credenciales de administrador
  Future<bool> login(String username, String password) async {
    if (username == _adminUsername && password == _adminPassword) {
      // Guardar sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adminSessionKey, true);
      return true;
    }
    return false;
  }

  // Verificar si hay sesión activa de administrador
  Future<bool> isAdminLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminSessionKey) ?? false;
  }

  // Cerrar sesión de administrador
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminSessionKey);
  }

  // Obtener nombre de usuario del administrador
  String getAdminUsername() => _adminUsername;
}

