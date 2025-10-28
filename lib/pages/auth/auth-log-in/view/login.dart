import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/pages/auth/widget/textformfieldauth.dart';
import 'package:hotel_real_merced/shared/widget/imagenauth.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';
import 'dart:async';
import '../../auth-sign-in/view/register.dart';
import '../../../../core/utils/validation_utils.dart';
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
              // Header con imagen de fondo
              Imagenauth(textoinicio: "Inicia sesión para continuar"),
              const SizedBox(height: 40),
              // Formulario de login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título del formulario
                      Textutils(
                        fontSize: 28,
                        selectcolor: const Color(0xFF2D3748),
                        texto: "Iniciar Sesión",
                      ),
                      const SizedBox(height: 8),
                      Textutils(
                        fontSize: 16,
                        selectcolor: const Color.fromARGB(255, 117, 117, 117),
                        texto: "Ingresa tus credenciales para acceder",
                      ),
                      const SizedBox(height: 30),
                      // Campo de email
                      Textutils(
                        fontSize: 16,
                        selectcolor: const Color(0xff2D3749),
                        texto: "Correo electrónico",
                      ),
                      const SizedBox(height: 8),
                      Textutils(
                        fontSize: 12,
                        selectcolor: const Color.fromARGB(255, 158, 158, 158),
                        texto:
                            "Solo se permiten: gmail.com, yahoo.com, hotmail.com, outlook.com, zohomail.com",
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Textformfieldauth(
                          controlador: _emailController,
                          prefixicon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF667eea),
                          ),
                          hintText: "tu@email.com",
                          colorhint: const Color.fromARGB(255, 189, 189, 189),
                          keyboardType: TextInputType.emailAddress,
                          validator: ValidationUtils.validateEmail,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Campo de contraseña
                      Textutils(
                        fontSize: 16,
                        selectcolor: const Color(0xFF2D3748),
                        texto: "Contraseña",
                      ),
                      const SizedBox(height: 8),
                      Textutils(
                        fontSize: 12,
                        selectcolor: const Color.fromARGB(255, 158, 158, 158),
                        texto:
                            "Debe tener mínimo 6 caracteres, 1 mayúscula, 1 número y 1 carácter especial",
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Textformfieldauth(
                          obscureText: _obscurePassword,
                          controlador: _passwordController,
                          prefixicon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF667eea),
                          ),
                          hintText: "Tu contraseña",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[400],
                            ),
                          ),
                          colorhint: const Color.fromARGB(255, 189, 189, 189),
                          validator: ValidationUtils.validatePassword,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Recordarme y olvidé contraseña
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF667eea),
                              ),
                              Textutils(
                                fontSize: 14,
                                selectcolor: const Color.fromARGB(
                                  255,
                                  117,
                                  117,
                                  117,
                                ),
                                texto: "Recordarme",
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implementar recuperación de contraseña
                            },
                            child: Textutils(
                              fontSize: 14,
                              selectcolor: const Color(0xFF667eea),
                              texto: "¿Olvidaste tu contraseña?",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Botón de login
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667eea).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _handleLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Textutils(
                            fontSize: 18,
                            selectcolor: Colors.white,
                            texto: "Iniciar Sesión",
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Textutils(
                              fontSize: 14,
                              selectcolor: const Color.fromARGB(
                                255,
                                158,
                                158,
                                158,
                              ),
                              texto: "O continúa con",
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Botones de redes sociales
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey[300]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implementar login con Google
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.g_mobiledata,
                                  color: Color(0xFFDB4437),
                                  size: 24,
                                ),
                                label: Textutils(
                                  fontSize: 16,
                                  selectcolor: const Color(0xFF2D3748),
                                  texto: "Google",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey[300]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implementar login con Facebook
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Color(0xFF1877F2),
                                  size: 24,
                                ),
                                label: Textutils(
                                  fontSize: 16,
                                  selectcolor: const Color(0xFF2D3748),
                                  texto: "Facebook",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Enlace a registro
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Textutils(
                              fontSize: 16,
                              selectcolor: const Color.fromARGB(
                                255,
                                117,
                                117,
                                117,
                              ),
                              texto: "¿No tienes cuenta? ",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: Textutils(
                                fontSize: 16,
                                selectcolor: const Color(0xFF667eea),
                                texto: "Regístrate aquí",
                              ),
                            ),
                          ],
                        ),
                      ),
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
