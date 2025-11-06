import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/auth/auth-log-in/view/login.dart';
import 'package:hotel_real_merced/pages/auth/auth-sign-in/view/register.dart';
import 'package:hotel_real_merced/pages/profile/widgets/ontlinebutton.dart';
import 'package:hotel_real_merced/pages/profile/widgets/primarybutton.dart';
import 'package:hotel_real_merced/pages/profile/widgets/profilestat.dart';
import 'package:hotel_real_merced/pages/profile/widgets/sectiontitle.dart';
import 'package:hotel_real_merced/pages/profile/widgets/settingstile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage('images/fondo.jpg'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Invitado',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Inicia sesión para sincronizar tus reservas',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              Row(
                children: const [
                  Expanded(child: Profilestat(label: 'Reservas', value: '0')),
                  SizedBox(width: 12),
                  Expanded(child: Profilestat(label: 'Favoritos', value: '0')),
                  SizedBox(width: 12),
                  Expanded(child: Profilestat(label: 'Puntos', value: '0')),
                ],
              ),

              const SizedBox(height: 24),
              const Sectiontitle(text: 'Acceso')
              ,
              const SizedBox(height: 12),
              Primarybutton(
                text: 'Iniciar sesión',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
              ),
              const SizedBox(height: 12),
              Ontlinebutton(
                text: 'Crear cuenta',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                },
              ),

              const SizedBox(height: 32),
              const Sectiontitle(text: 'Preferencias')
              ,
              const SizedBox(height: 8),
              const Settingstile(icon: Icons.notifications_none, title: 'Notificaciones'),
              const Settingstile(icon: Icons.language, title: 'Idioma'),
              const Settingstile(icon: Icons.lock_outline, title: 'Privacidad'),
            ],
          ),
        ),
      ),
    );
  }
}