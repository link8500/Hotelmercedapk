import 'package:shared_preferences/shared_preferences.dart';

class SecurityManager {
  static final SecurityManager _instance = SecurityManager._internal();
  factory SecurityManager() => _instance;
  SecurityManager._internal();

  // Configuración de seguridad
  static const int maxAttempts = 3;
  static const Duration lockoutDuration = Duration(minutes: 5);
  static const String _lockoutKey = 'app_lockout_until';
  static const String _attemptsKey = 'failed_login_attempts';
  static const String _lastAttemptKey = 'last_failed_attempt';

  // Verificar si la aplicación está bloqueada
  Future<bool> isAppLocked() async {
    final prefs = await SharedPreferences.getInstance();
    final lockoutUntilString = prefs.getString(_lockoutKey);
    
    if (lockoutUntilString == null) {
      return false;
    }

    try {
      final lockoutUntil = DateTime.parse(lockoutUntilString);
      final now = DateTime.now();
      
      if (now.isAfter(lockoutUntil)) {
        // El bloqueo ha expirado, limpiar
        await clearLockout();
        return false;
      }
      
      return true;
    } catch (e) {
      // Si hay error al parsear, limpiar y permitir acceso
      await clearLockout();
      return false;
    }
  }

  // Obtener tiempo restante del bloqueo
  Future<Duration?> getRemainingLockoutTime() async {
    if (!await isAppLocked()) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final lockoutUntilString = prefs.getString(_lockoutKey);
    
    if (lockoutUntilString == null) {
      return null;
    }

    try {
      final lockoutUntil = DateTime.parse(lockoutUntilString);
      final now = DateTime.now();
      
      if (lockoutUntil.isAfter(now)) {
        return lockoutUntil.difference(now);
      }
    } catch (e) {
      // Error al parsear
    }
    
    return null;
  }

  // Registrar intento fallido
  Future<void> recordFailedAttempt() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    
    // Obtener intentos actuales
    int attempts = prefs.getInt(_attemptsKey) ?? 0;
    final lastAttemptString = prefs.getString(_lastAttemptKey);
    
    // Si han pasado más de 5 minutos desde el último intento, resetear contador
    if (lastAttemptString != null) {
      try {
        final lastAttempt = DateTime.parse(lastAttemptString);
        if (now.difference(lastAttempt) > lockoutDuration) {
          attempts = 0;
        }
      } catch (e) {
        // Error al parsear, resetear
        attempts = 0;
      }
    }
    
    // Incrementar intentos
    attempts++;
    
    // Guardar intentos y última fecha
    await prefs.setInt(_attemptsKey, attempts);
    await prefs.setString(_lastAttemptKey, now.toIso8601String());
    
    // Si se alcanzaron 3 intentos, bloquear la aplicación
    if (attempts >= maxAttempts) {
      final lockoutUntil = now.add(lockoutDuration);
      await prefs.setString(_lockoutKey, lockoutUntil.toIso8601String());
    }
  }

  // Obtener número de intentos restantes
  Future<int> getRemainingAttempts() async {
    if (await isAppLocked()) {
      return 0;
    }

    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getInt(_attemptsKey) ?? 0;
    final lastAttemptString = prefs.getString(_lastAttemptKey);
    
    // Si han pasado más de 5 minutos desde el último intento, resetear
    if (lastAttemptString != null) {
      try {
        final lastAttempt = DateTime.parse(lastAttemptString);
        final now = DateTime.now();
        if (now.difference(lastAttempt) > lockoutDuration) {
          return maxAttempts;
        }
      } catch (e) {
        return maxAttempts;
      }
    }
    
    return maxAttempts - attempts;
  }

  // Obtener número de intentos fallidos actuales
  Future<int> getFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getInt(_attemptsKey) ?? 0;
    final lastAttemptString = prefs.getString(_lastAttemptKey);
    
    // Si han pasado más de 5 minutos desde el último intento, resetear
    if (lastAttemptString != null) {
      try {
        final lastAttempt = DateTime.parse(lastAttemptString);
        final now = DateTime.now();
        if (now.difference(lastAttempt) > lockoutDuration) {
          return 0;
        }
      } catch (e) {
        return 0;
      }
    }
    
    return attempts;
  }

  // Limpiar bloqueo e intentos (cuando el login es exitoso)
  Future<void> clearFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_attemptsKey);
    await prefs.remove(_lastAttemptKey);
    await prefs.remove(_lockoutKey);
  }

  // Limpiar solo el bloqueo
  Future<void> clearLockout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lockoutKey);
    await prefs.remove(_attemptsKey);
    await prefs.remove(_lastAttemptKey);
  }

  // Formatear tiempo restante para mostrar al usuario
  String formatRemainingTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Formatear tiempo restante en formato MM:SS
  String formatRemainingTimeMMSS(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
