class SecurityManager {
  static final SecurityManager _instance = SecurityManager._internal();
  factory SecurityManager() => _instance;
  SecurityManager._internal();

  // Almacenar intentos fallidos por email
  final Map<String, List<DateTime>> _failedAttempts = {};
  
  // Configuración de seguridad
  static const int maxAttempts = 3;
  static const Duration lockoutDuration = Duration(minutes: 15);

  // Registrar intento fallido
  void recordFailedAttempt(String email) {
    final now = DateTime.now();
    
    if (!_failedAttempts.containsKey(email)) {
      _failedAttempts[email] = [];
    }
    
    _failedAttempts[email]!.add(now);
    
    // Limpiar intentos antiguos (más de 15 minutos)
    _failedAttempts[email]!.removeWhere(
      (attempt) => now.difference(attempt) > lockoutDuration
    );
  }

  // Verificar si el email está bloqueado
  bool isEmailBlocked(String email) {
    if (!_failedAttempts.containsKey(email)) {
      return false;
    }

    final now = DateTime.now();
    final recentAttempts = _failedAttempts[email]!.where(
      (attempt) => now.difference(attempt) <= lockoutDuration
    ).length;

    return recentAttempts >= maxAttempts;
  }

  // Obtener tiempo restante del bloqueo
  Duration? getRemainingLockoutTime(String email) {
    if (!isEmailBlocked(email)) {
      return null;
    }

    final attempts = _failedAttempts[email]!;
    if (attempts.isEmpty) {
      return null;
    }

    // Ordenar intentos por fecha (más reciente primero)
    attempts.sort((a, b) => b.compareTo(a));
    
    final oldestRelevantAttempt = attempts[maxAttempts - 1];
    final unlockTime = oldestRelevantAttempt.add(lockoutDuration);
    final now = DateTime.now();

    if (unlockTime.isAfter(now)) {
      return unlockTime.difference(now);
    }

    return null;
  }

  // Limpiar intentos fallidos (para cuando el login es exitoso)
  void clearFailedAttempts(String email) {
    _failedAttempts.remove(email);
  }

  // Obtener número de intentos restantes
  int getRemainingAttempts(String email) {
    if (!_failedAttempts.containsKey(email)) {
      return maxAttempts;
    }

    final now = DateTime.now();
    final recentAttempts = _failedAttempts[email]!.where(
      (attempt) => now.difference(attempt) <= lockoutDuration
    ).length;

    return maxAttempts - recentAttempts;
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
}
