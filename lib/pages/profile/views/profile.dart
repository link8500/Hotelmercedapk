import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/auth/auth-log-in/view/login.dart';
import 'package:hotel_real_merced/pages/auth/auth-sign-in/view/register.dart';

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
                  Expanded(child: _ProfileStat(label: 'Reservas', value: '0')),
                  SizedBox(width: 12),
                  Expanded(child: _ProfileStat(label: 'Favoritos', value: '0')),
                  SizedBox(width: 12),
                  Expanded(child: _ProfileStat(label: 'Puntos', value: '0')),
                ],
              ),

              const SizedBox(height: 24),
              const _SectionTitle('Acceso')
              ,
              const SizedBox(height: 12),
              _PrimaryButton(
                text: 'Iniciar sesión',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
              ),
              const SizedBox(height: 12),
              _OutlinedButton(
                text: 'Crear cuenta',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                },
              ),

              const SizedBox(height: 32),
              const _SectionTitle('Preferencias')
              ,
              const SizedBox(height: 8),
              const _SettingsTile(icon: Icons.notifications_none, title: 'Notificaciones'),
              const _SettingsTile(icon: Icons.language, title: 'Idioma'),
              const _SettingsTile(icon: Icons.lock_outline, title: 'Privacidad'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}