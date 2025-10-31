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
              const Imagenauth(textoinicio: "Inicia sesión para continuar"),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _LoginHeader(),
                      const SizedBox(height: 30),
                      const _EmailLabel(),
                      const SizedBox(height: 8),
                      const _EmailHelpText(),
                      const SizedBox(height: 8),
                      _EmailField(controller: _emailController),
                      const SizedBox(height: 20),
                      const _PasswordLabel(),
                      const SizedBox(height: 8),
                      const _PasswordHelpText(),
                      const SizedBox(height: 8),
                      _PasswordField(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        onToggleObscure: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                      ),
                      const SizedBox(height: 15),
                      _RememberAndForgotRow(
                        rememberMe: _rememberMe,
                        onChanged: (v) => setState(() {
                          _rememberMe = v ?? false;
                        }),
                      ),
                      const SizedBox(height: 30),
                      _LoginButton(onPressed: _handleLogin),
                      const SizedBox(height: 25),
                      const _OrDivider(),
                      const SizedBox(height: 25),
                      const _SocialButtonsRow(),
                      const SizedBox(height: 30),
                      const _RegisterLink(),
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textutils(
          fontSize: 28,
          selectcolor: Color(0xFF2D3748),
          texto: "Iniciar Sesión",
        ),
        SizedBox(height: 8),
        Textutils(
          fontSize: 16,
          selectcolor: Color.fromARGB(255, 117, 117, 117),
          texto: "Ingresa tus credenciales para acceder",
        ),
      ],
    );
  }
}

class _EmailLabel extends StatelessWidget {
  const _EmailLabel();

  @override
  Widget build(BuildContext context) {
    return const Textutils(
      fontSize: 16,
      selectcolor: Color(0xff2D3749),
      texto: "Correo electrónico",
    );
  }
}

class _EmailHelpText extends StatelessWidget {
  const _EmailHelpText();

  @override
  Widget build(BuildContext context) {
    return const Textutils(
      fontSize: 12,
      selectcolor: Color.fromARGB(255, 158, 158, 158),
      texto:
          "Solo se permiten: gmail.com, yahoo.com, hotmail.com, outlook.com, zohomail.com",
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        controlador: controller,
        prefixicon: const Icon(
          Icons.email_outlined,
          color: Color(0xFF667eea),
        ),
        hintText: "tu@email.com",
        colorhint: const Color.fromARGB(255, 189, 189, 189),
        keyboardType: TextInputType.emailAddress,
        validator: ValidationUtils.validateEmail,
      ),
    );
  }
}

class _PasswordLabel extends StatelessWidget {
  const _PasswordLabel();

  @override
  Widget build(BuildContext context) {
    return const Textutils(
      fontSize: 16,
      selectcolor: Color(0xFF2D3748),
      texto: "Contraseña",
    );
  }
}

class _PasswordHelpText extends StatelessWidget {
  const _PasswordHelpText();

  @override
  Widget build(BuildContext context) {
    return const Textutils(
      fontSize: 12,
      selectcolor: Color.fromARGB(255, 158, 158, 158),
      texto:
          "Debe tener mínimo 6 caracteres, 1 mayúscula, 1 número y 1 carácter especial",
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        obscureText: obscure,
        controlador: controller,
        prefixicon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF667eea),
        ),
        hintText: "Tu contraseña",
        suffixIcon: IconButton(
          onPressed: onToggleObscure,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
          ),
        ),
        colorhint: const Color.fromARGB(255, 189, 189, 189),
        validator: ValidationUtils.validatePassword,
      ),
    );
  }
}

class _RememberAndForgotRow extends StatelessWidget {
  const _RememberAndForgotRow({
    required this.rememberMe,
    required this.onChanged,
  });

  final bool rememberMe;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: onChanged,
              activeColor: const Color(0xFF667eea),
            ),
            const Textutils(
              fontSize: 14,
              selectcolor: Color.fromARGB(255, 117, 117, 117),
              texto: "Recordarme",
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Textutils(
            fontSize: 14,
            selectcolor: Color(0xFF667eea),
            texto: "¿Olvidaste tu contraseña?",
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Textutils(
          fontSize: 18,
          selectcolor: Colors.white,
          texto: "Iniciar Sesión",
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Textutils(
            fontSize: 14,
            selectcolor: Color.fromARGB(255, 158, 158, 158),
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
    );
  }
}

class _SocialButtonsRow extends StatelessWidget {
  const _SocialButtonsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
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
              onPressed: () {},
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
              label: const Textutils(
                fontSize: 16,
                selectcolor: Color(0xFF2D3748),
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
              onPressed: () {},
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
              label: const Textutils(
                fontSize: 16,
                selectcolor: Color(0xFF2D3748),
                texto: "Facebook",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Textutils(
            fontSize: 16,
            selectcolor: Color.fromARGB(255, 117, 117, 117),
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
            child: const Textutils(
              fontSize: 16,
              selectcolor: Color(0xFF667eea),
              texto: "Regístrate aquí",
            ),
          ),
        ],
      ),
    );
  }
}
