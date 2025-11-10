import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/pages/auth/auth-sign-in/view/register.dart';
import 'package:hotel_real_merced/pages/auth/models/emailfield.dart';
import 'package:hotel_real_merced/pages/auth/models/loginheader.dart';
import 'package:hotel_real_merced/pages/auth/models/passwordfield.dart';
import 'package:hotel_real_merced/pages/auth/widget/loginbutton.dart';
import 'package:hotel_real_merced/pages/auth/widget/ordivider.dart';
import 'package:hotel_real_merced/pages/auth/widget/registerlink.dart';
import 'package:hotel_real_merced/pages/auth/widget/rememberandforgotrow.dart';
import 'package:hotel_real_merced/pages/auth/widget/socialbuttonsrow.dart';
import 'package:hotel_real_merced/shared/widget/imagenauth.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';
import 'package:hotel_real_merced/core/services/supabase_service.dart';
import 'package:hotel_real_merced/core/utils/security_manager.dart';
import 'package:hotel_real_merced/pages/auth/auth-log-in/view/lockout_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SecurityManager _securityManager = SecurityManager();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  int _remainingAttempts = 3;

  @override
  void initState() {
    super.initState();
    _checkLockoutStatus();
    _loadRemainingAttempts();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLockoutStatus() async {
    final isLocked = await _securityManager.isAppLocked();
    if (isLocked && mounted) {
      // Navegar a la pantalla de bloqueo (usar push para poder volver)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LockoutScreen(),
        ),
      ).then((_) {
        // Cuando se regrese de la pantalla de bloqueo, recargar intentos
        _loadRemainingAttempts();
      });
    }
  }

  Future<void> _loadRemainingAttempts() async {
    final attempts = await _securityManager.getRemainingAttempts();
    if (mounted) {
      setState(() {
        _remainingAttempts = attempts;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Verificar si la aplicación está bloqueada antes de intentar login
    final isLocked = await _securityManager.isAppLocked();
    if (isLocked) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LockoutScreen(),
          ),
        ).then((_) {
          // Cuando se regrese de la pantalla de bloqueo, recargar intentos
          if (mounted) {
            _loadRemainingAttempts();
          }
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Autenticar con Supabase
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Login exitoso - limpiar intentos fallidos
        await _securityManager.clearFailedAttempts();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login exitoso',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: const Color(0xFF667eea),
            ),
          );
          Navigator.pop(context);
        }
      }
    } on AuthException catch (e) {
      // Registrar intento fallido
      await _securityManager.recordFailedAttempt();
      
      // Actualizar intentos restantes
      await _loadRemainingAttempts();
      
      // Verificar si la app debe bloquearse
      final isLocked = await _securityManager.isAppLocked();
      if (isLocked && mounted) {
        // Navegar a la pantalla de bloqueo (usar push para poder volver)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LockoutScreen(),
          ),
        ).then((_) {
          // Cuando se regrese de la pantalla de bloqueo, recargar intentos
          if (mounted) {
            _loadRemainingAttempts();
          }
        });
        return;
      }

      if (mounted) {
        String errorMessage = 'Error al iniciar sesión';
        String attemptsMessage = '';
        
        // Manejar diferentes tipos de errores de Supabase
        if (e.message.toLowerCase().contains('invalid login credentials') || 
            e.message.toLowerCase().contains('invalid credentials')) {
          errorMessage = 'Credenciales incorrectas. Por favor verifica tu email y contraseña.';
          
          // Mostrar mensaje de intentos restantes
          if (_remainingAttempts > 0) {
            attemptsMessage = '\nTe quedan $_remainingAttempts intentos.';
          } else {
            attemptsMessage = '\nHas alcanzado el límite de intentos.';
          }
        } else if (e.message.toLowerCase().contains('email not confirmed')) {
          errorMessage = 'Por favor verifica tu email antes de iniciar sesión.';
        } else if (e.message.toLowerCase().contains('too many requests')) {
          errorMessage = 'Demasiados intentos. Por favor intenta más tarde.';
        } else {
          errorMessage = 'Error al iniciar sesión: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$errorMessage$attemptsMessage',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: _remainingAttempts <= 1 ? Colors.orange : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      // Registrar intento fallido para errores inesperados también
      await _securityManager.recordFailedAttempt();
      await _loadRemainingAttempts();
      
      // Verificar si la app debe bloquearse
      final isLocked = await _securityManager.isAppLocked();
      if (isLocked && mounted) {
        // Navegar a la pantalla de bloqueo (usar push para poder volver)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LockoutScreen(),
          ),
        ).then((_) {
          // Cuando se regrese de la pantalla de bloqueo, recargar intentos
          if (mounted) {
            _loadRemainingAttempts();
          }
        });
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error inesperado al iniciar sesión',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Imagenauth(textoinicio: "Inicia sesión para continuar"),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Loginheader(texto1: "Iniciar Sesión",texto2: "Ingresa tus credenciales para acceder"),
                      const SizedBox(height: 30),
                      const Textutils(
      fontSize: 16,
      selectcolor: Color(0xff2D3749),
      texto: "Correo electrónico",
    ),
                      const SizedBox(height: 8),
                      const Textutils(
      fontSize: 12,
      selectcolor: Color.fromARGB(255, 158, 158, 158),
      texto:
          "Solo se permiten: gmail.com, yahoo.com, hotmail.com, outlook.com, zohomail.com",
    ),
                      const SizedBox(height: 8),
                      Emailfield(controller: _emailController),
                      const SizedBox(height: 20),
                      const Textutils(
      fontSize: 16,
      selectcolor: Color(0xFF2D3748),
      texto: "Contraseña",
    ),
                      const SizedBox(height: 8),
                     const Textutils(
      fontSize: 12,
      selectcolor: Color.fromARGB(255, 158, 158, 158),
      texto:
          "Debe tener mínimo 6 caracteres, 1 mayúscula, 1 número y 1 carácter especial",
    ),
                      const SizedBox(height: 8),
                      Passwordfield(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        onToggleObscure: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                        texto: "Tu contraseña",
                      ),
                      const SizedBox(height: 15),
                      Rememberandforgotrow(
                        rememberMe: _rememberMe,
                        onChanged: (v) => setState(() {
                          _rememberMe = v ?? false;
                        }),
                      ),
                      // Mostrar intentos restantes si hay menos de 3
                      if (_remainingAttempts < 3 && _remainingAttempts > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _remainingAttempts <= 1
                                  ? Colors.orange.withOpacity(0.1)
                                  : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _remainingAttempts <= 1
                                    ? Colors.orange
                                    : Colors.blue,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _remainingAttempts <= 1
                                      ? Icons.warning_amber_rounded
                                      : Icons.info_outline,
                                  color: _remainingAttempts <= 1
                                      ? Colors.orange
                                      : Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Te quedan $_remainingAttempts intentos antes del bloqueo',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: _remainingAttempts <= 1
                                          ? Colors.orange.shade900
                                          : Colors.blue.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      Loginbutton(
                        onPressed: _isLoading ? null : _handleLogin,
                        text: _isLoading ? "Iniciando sesión..." : "Iniciar Sesión",
                      ),
                      const SizedBox(height: 25),
                      const Ordivider(),
                      const SizedBox(height: 25),
                      const Socialbuttonsrow(),
                      const SizedBox(height: 30),
                       Registerlink(builder1: (context) => const RegisterPage(),text1: "¿No tienes cuenta? ",text2: "Regístrate aquí",),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

