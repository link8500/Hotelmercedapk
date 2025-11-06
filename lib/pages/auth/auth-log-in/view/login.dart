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
import 'dart:async';
import '../../../../core/utils/security_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final SecurityManager _securityManager = SecurityManager();
  Timer? _lockoutTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Verificar si el email está bloqueado
    if (_securityManager.isEmailBlocked(email)) {
      final remainingTime = _securityManager.getRemainingLockoutTime(email);
      if (remainingTime != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cuenta bloqueada temporalmente. Intenta de nuevo en ${_securityManager.formatRemainingTime(remainingTime)}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }
    }

    // Simular verificación de credenciales (aquí iría la lógica real)
    bool loginSuccessful = _simulateLogin(email, password);

    if (loginSuccessful) {
      // Limpiar intentos fallidos en caso de login exitoso
      _securityManager.clearFailedAttempts(email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login exitoso', style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF667eea),
        ),
      );
      Navigator.pop(context);
    } else {
      // Registrar intento fallido
      _securityManager.recordFailedAttempt(email);

      final remainingAttempts = _securityManager.getRemainingAttempts(email);

      if (remainingAttempts <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Demasiados intentos fallidos. Cuenta bloqueada por 15 minutos.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Credenciales incorrectas. Te quedan $remainingAttempts intentos.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Simular verificación de login (reemplazar con lógica real)
  bool _simulateLogin(String email, String password) {
    // Para propósitos de demostración, solo aceptar credenciales específicas
    return email == 'demo@gmail.com' && password == 'Demo123!';
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
                      const SizedBox(height: 30),
                      Loginbutton(onPressed: _handleLogin,text: "Iniciar Sesión",),
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

