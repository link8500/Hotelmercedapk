import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../../core/utils/security_manager.dart';

class LockoutScreen extends StatefulWidget {
  const LockoutScreen({super.key});

  @override
  State<LockoutScreen> createState() => _LockoutScreenState();
}

class _LockoutScreenState extends State<LockoutScreen> {
  final SecurityManager _securityManager = SecurityManager();
  Timer? _timer;
  Duration? _remainingTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  Future<void> _updateRemainingTime() async {
    final remaining = await _securityManager.getRemainingLockoutTime();
    
    if (mounted) {
      setState(() {
        _remainingTime = remaining;
        _isLoading = false;
      });

      // Si el tiempo ha expirado, limpiar bloqueo y volver al login
      if (remaining == null || remaining.inSeconds <= 0) {
        _timer?.cancel();
        await _securityManager.clearLockout();
        if (mounted) {
          // Volver a la pantalla anterior (login)
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevenir que el usuario cierre la pantalla presionando el botón de retroceso
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono de bloqueo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Título
                  Text(
                    'Aplicación Bloqueada',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Mensaje
                  Text(
                    'Has excedido el número máximo de intentos de inicio de sesión.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFF4A5568),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Contador
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_remainingTime != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Tiempo restante',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF4A5568),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _securityManager.formatRemainingTimeMMSS(_remainingTime!),
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF667eea),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  
                  // Mensaje adicional
                  Text(
                    'Por favor espera antes de intentar nuevamente.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Por seguridad, la aplicación permanecerá bloqueada temporalmente.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFFA0AEC0),
                    ),
                    textAlign: TextAlign.center,
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

