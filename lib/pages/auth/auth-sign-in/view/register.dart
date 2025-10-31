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
        child: SafeArea(child:Column(
          children: [
            // Header con imagen de fondo
            Imagenauth(textoinicio: "Crea tu cuenta para comenzar",),
            const SizedBox(height: 40),
            
            // Formulario de registro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del formulario
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
                    
                    const SizedBox(height: 30),
                    
                    // Campo de nombre completo
                    Text(
                      "Nombre completo",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                        controller: _nameController,
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
                    ),
                    
                    const SizedBox(height: 20),
                    
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
                    
                    // Campo de teléfono
                    Text(
                      "Número de teléfono",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                        controller: _phoneController,
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
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo de confirmar contraseña
                    Text(
                      "Confirmar contraseña",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF667eea),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
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
                        validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Checkbox de términos y condiciones
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
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
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Botón de registro
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
                            
                            // TODO: Implementar lógica de registro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Registro exitoso',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: const Color(0xFF667eea),
                              ),
                            );
                            
                            // Redirigir a login después del registro exitoso
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        },
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
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Enlace a login
                    Center(
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
                    ),
                    
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
