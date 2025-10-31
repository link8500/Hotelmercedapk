import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/shared/widget/imagenauth.dart';
import '../../auth-log-in/view/login.dart';
import '../../../../core/utils/validation_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Imagenauth(textoinicio: "Crea tu cuenta para comenzar"),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _RegisterHeader(),
                      const SizedBox(height: 30),
                      const _FieldLabel(text: "Nombre completo"),
                      const SizedBox(height: 8),
                      _NameField(controller: _nameController),
                      const SizedBox(height: 20),
                      const _FieldLabel(text: "Correo electrónico"),
                      const SizedBox(height: 8),
                      const _EmailHelpText(),
                      const SizedBox(height: 8),
                      _EmailField(controller: _emailController),
                      const SizedBox(height: 20),
                      const _FieldLabel(text: "Número de teléfono"),
                      const SizedBox(height: 8),
                      _PhoneField(controller: _phoneController),
                      const SizedBox(height: 20),
                      const _FieldLabel(text: "Contraseña"),
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
                      const SizedBox(height: 20),
                      const _FieldLabel(text: "Confirmar contraseña"),
                      const SizedBox(height: 8),
                      _ConfirmPasswordField(
                        controller: _confirmPasswordController,
                        obscure: _obscureConfirmPassword,
                        onToggleObscure: () => setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }),
                        getPassword: () => _passwordController.text,
                      ),
                      const SizedBox(height: 20),
                      _TermsRow(
                        checked: _acceptTerms,
                        onChanged: (v) => setState(() {
                          _acceptTerms = v ?? false;
                        }),
                      ),
                      const SizedBox(height: 30),
                      _RegisterButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (!_acceptTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Debes aceptar los términos y condiciones',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Registro exitoso',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: const Color(0xFF667eea),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                      const _LoginLink(),
                      const SizedBox(height: 30),
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

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Crear Cuenta",
          style: GoogleFonts.poppins(
            color: const Color(0xFF2D3748),
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Completa la información para registrarte",
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: const Color(0xFF2D3748),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _EmailHelpText extends StatelessWidget {
  const _EmailHelpText();
  @override
  Widget build(BuildContext context) {
    return Text(
      "Solo se permiten: gmail.com, yahoo.com, hotmail.com, outlook.com, zohomail.com",
      style: GoogleFonts.poppins(
        color: Colors.grey[500],
        fontSize: 12,
      ),
    );
  }
}

class _PasswordHelpText extends StatelessWidget {
  const _PasswordHelpText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Debe tener mínimo 6 caracteres, 1 mayúscula, 1 número y 1 carácter especial",
      style: GoogleFonts.poppins(
        color: Colors.grey[500],
        fontSize: 12,
      ),
    );
  }
}

class _InputDecorator extends StatelessWidget {
  const _InputDecorator({required this.child});
  final Widget child;
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
      child: child,
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _InputDecorator(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Color(0xFF667eea),
          ),
          hintText: "Tu nombre completo",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu nombre';
          }
          if (value.length < 2) {
            return 'El nombre debe tener al menos 2 caracteres';
          }
          return null;
        },
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _InputDecorator(
      child: TextFormField(
        controller: controller,
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
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _InputDecorator(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: Color(0xFF667eea),
          ),
          hintText: "+505 1234 5678",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu número de teléfono';
          }
          if (value.length < 8) {
            return 'Por favor ingresa un número válido';
          }
          return null;
        },
      ),
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
    return _InputDecorator(
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF667eea),
          ),
          suffixIcon: IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[400],
            ),
          ),
          hintText: "Mínimo 6 caracteres",
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
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
    required this.getPassword,
  });
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String Function() getPassword;

  @override
  Widget build(BuildContext context) {
    return _InputDecorator(
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF667eea),
          ),
          suffixIcon: IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[400],
            ),
          ),
          hintText: "Repite tu contraseña",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        validator: (value) =>
            ValidationUtils.validateConfirmPassword(value, getPassword()),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.checked, required this.onChanged});
  final bool checked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: checked,
          onChanged: onChanged,
          activeColor: const Color(0xFF667eea),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                children: [
                  const TextSpan(text: "Acepto los "),
                  TextSpan(
                    text: "términos y condiciones",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF667eea),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: " y la "),
                  TextSpan(
                    text: "política de privacidad",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF667eea),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({required this.onPressed});
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
        child: Text(
          "Crear Cuenta",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¿Ya tienes cuenta? ",
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: Text(
              "Inicia sesión aquí",
              style: GoogleFonts.poppins(
                color: const Color(0xFF667eea),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
