import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_auth_service.dart';
import 'package:hotel_real_merced/pages/admin/crud/habitaciones/admin_habitaciones_list.dart';
import 'package:hotel_real_merced/pages/admin/crud/tipo_habitacion/admin_tipo_habitacion_list.dart';
import 'package:hotel_real_merced/pages/admin/crud/comodidades/admin_comodidades_list.dart';
import 'package:hotel_real_merced/pages/admin/crud/clientes/admin_clientes_list.dart';
import 'package:hotel_real_merced/pages/admin/crud/reservaciones/admin_reservaciones_list.dart';
import 'package:hotel_real_merced/pages/admin/crud/facturas/admin_facturas_list.dart';
import 'package:hotel_real_merced/pages/admin/auth/admin_login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminAuthService _authService = AdminAuthService();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DashboardHome(),
    const AdminHabitacionesList(),
    const AdminTipoHabitacionList(),
    const AdminComodidadesList(),
    const AdminClientesList(),
    const AdminReservacionesList(),
    const AdminFacturasList(),
  ];

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión', style: GoogleFonts.poppins()),
        content: Text('¿Estás seguro de que deseas cerrar sesión?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Cerrar Sesión', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminLoginPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(
          'Panel de Administración',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF16213E),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF667eea),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    'Administrador',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _authService.getAdminUsername(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
            const Divider(color: Colors.grey),
            _buildDrawerItem(Icons.bed, 'Habitaciones', 1),
            _buildDrawerItem(Icons.hotel, 'Tipos de Habitación', 2),
            _buildDrawerItem(Icons.room_service, 'Comodidades', 3),
            const Divider(color: Colors.grey),
            _buildDrawerItem(Icons.people, 'Clientes', 4),
            _buildDrawerItem(Icons.calendar_today, 'Reservaciones', 5),
            _buildDrawerItem(Icons.receipt, 'Facturas', 6),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF667eea) : Colors.grey[400],
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.grey[400],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.grey[900],
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}

// Widget para la página de inicio del dashboard
class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido al Dashboard',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gestiona todas las operaciones del hotel',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 32),
          
          // Tarjetas de estadísticas rápidas
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                context,
                'Habitaciones',
                Icons.bed,
                const Color(0xFF667eea),
                'Gestionar habitaciones',
                () {
                  // Esta navegación se maneja desde el drawer
                },
              ),
              _buildStatCard(
                context,
                'Reservaciones',
                Icons.calendar_today,
                const Color(0xFF48bb78),
                'Ver reservaciones',
                () {
                  // Esta navegación se maneja desde el drawer
                },
              ),
              _buildStatCard(
                context,
                'Clientes',
                Icons.people,
                const Color(0xFFed8936),
                'Gestionar clientes',
                () {
                  // Esta navegación se maneja desde el drawer
                },
              ),
              _buildStatCard(
                context,
                'Facturas',
                Icons.receipt,
                const Color(0xFFf56565),
                'Ver facturas',
                () {
                  // Esta navegación se maneja desde el drawer
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      color: const Color(0xFF16213E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

