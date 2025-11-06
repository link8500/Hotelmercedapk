import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/pages/auth/models/confirmpasswordfield.dart';
import 'package:hotel_real_merced/pages/auth/models/emailfield.dart';
import 'package:hotel_real_merced/pages/auth/models/loginheader.dart';
import 'package:hotel_real_merced/pages/auth/models/passwordfield.dart';
import 'package:hotel_real_merced/pages/auth/widget/loginbutton.dart';
import 'package:hotel_real_merced/pages/auth/widget/namefield.dart';
import 'package:hotel_real_merced/pages/auth/widget/registerlink.dart';
import 'package:hotel_real_merced/pages/auth/widget/termsrow.dart';
import 'package:hotel_real_merced/shared/widget/imagenauth.dart';
import 'package:hotel_real_merced/shared/widget/text.dart';
import '../../auth-log-in/view/login.dart';

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
                      const Loginheader(
                        texto1: "Crear Cuenta",
                        texto2: "Completa la información para registrarte",
                      ),
                      const SizedBox(height: 30),
                      const Textutils(
                        fontSize: 16,
                        selectcolor: Color(0xFF2D3748),
                        texto: "Nombre completo",
                      ),
                      const SizedBox(height: 8),
                      Namefield(controller: _nameController,texto: "Tu nombre completo",texto2: 'Por favor ingresa tu nombre',texto3: 'El nombre debe tener al menos 2 caracteres'),
                      const SizedBox(height: 20),
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
                        selectcolor: Color(0xff2D3749),
                        texto: "Número de teléfono",
                      ),
                      const SizedBox(height: 8),
                      Namefield( controller: _phoneController,
                      texto:"+505 1234 5678",texto2:'Por favor ingresa tu número de teléfono',texto3: 'Por favor ingresa tu número de teléfono'),
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
                        texto: "Mínimo 6 caracteres",
                      ),
                      const SizedBox(height: 20),
                      const Textutils(
                        fontSize: 12,
                        selectcolor: Color.fromARGB(255, 158, 158, 158),
                        texto:"Confirmar contraseña"
                      ),
                      const SizedBox(height: 8),
                      Confirmpasswordfield(
                        controller: _confirmPasswordController,
                        obscure: _obscureConfirmPassword,
                        onToggleObscure: () => setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }),
                        getPassword: () => _passwordController.text,
                      ),
                      const SizedBox(height: 20),
                      Termsrow(
                        checked: _acceptTerms,
                        onChanged: (v) => setState(() {
                          _acceptTerms = v ?? false;
                        }),
                      ),
                      const SizedBox(height: 30),
                      Loginbutton(
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
                        text: "Crear Cuenta",
                      ),
                      const SizedBox(height: 25),
                      Registerlink(builder1: (context) => const LoginPage(), text1: "¿Ya tienes cuenta? ", text2: "Inicia sesión aquí"),
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
