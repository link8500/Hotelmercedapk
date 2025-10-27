import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../register/view/register.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/utils/security_manager.dart';

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
          content: Text(
            'Login exitoso',
            style: GoogleFonts.poppins(),
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con imagen de fondo
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Stack(
                  children: [
                    // Imagen de fondo
                    Image.asset(
                      'images/fondo.jpg',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Overlay oscuro
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Contenido del header
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          // Botón de regreso
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Ícono del hotel
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.hotel,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Hotel Real Merced",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Inicia sesión para continuar",
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
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
                    Text(
                      "Iniciar Sesión",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3748),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ingresa tus credenciales para acceder",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Campo de email
                    Text(
                      "Correo electrónico",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Solo se permiten: gmail.com, yahoo.com, hotmail.com, outlook.com, zohomail.com",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
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
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF667eea),
                          ),
                          hintText: "tu@email.com",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                        validator: ValidationUtils.validateEmail,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo de contraseña
                    Text(
                      "Contraseña",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Debe tener mínimo 6 caracteres, 1 mayúscula, 1 número y 1 carácter especial",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
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
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF667eea),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey[400],
                            ),
                          ),
                          hintText: "Tu contraseña",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
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
                            Text(
                              "Recordarme",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implementar recuperación de contraseña
                          },
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF667eea),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
                        child: Text(
                          "Iniciar Sesión",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                          child: Text(
                            "O continúa con",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
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
                              label: Text(
                                "Google",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF2D3748),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
                              label: Text(
                                "Facebook",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF2D3748),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
                          Text(
                            "¿No tienes cuenta? ",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
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
                            child: Text(
                              "Regístrate aquí",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF667eea),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
