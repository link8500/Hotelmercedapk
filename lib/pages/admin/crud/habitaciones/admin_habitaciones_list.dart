import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/habitaciones_service.dart';
import 'package:hotel_real_merced/pages/admin/crud/habitaciones/admin_habitacion_form.dart';

class AdminHabitacionesList extends StatefulWidget {
  const AdminHabitacionesList({super.key});

  @override
  State<AdminHabitacionesList> createState() => _AdminHabitacionesListState();
}

class _AdminHabitacionesListState extends State<AdminHabitacionesList> {
  final HabitacionesService _service = HabitacionesService();
  List<Map<String, dynamic>> _habitaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabitaciones();
  }

  Future<void> _loadHabitaciones() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final habitaciones = await _service.getAllHabitaciones();
      setState(() {
        _habitaciones = habitaciones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar habitaciones: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteHabitacion(String numeroHabitacion) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Habitación', style: GoogleFonts.poppins()),
        content: Text('¿Estás seguro de que deseas eliminar la habitación $numeroHabitacion?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteHabitacion(numeroHabitacion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Habitación eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _loadHabitaciones();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar habitación: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return 'green';
      case 'ocupada':
        return 'red';
      case 'mantenimiento':
        return 'orange';
      case 'limpieza':
        return 'blue';
      default:
        return 'grey';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF16213E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Habitaciones',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminHabitacionForm(),
                      ),
                    );
                    if (result == true) {
                      _loadHabitaciones();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: Text('Nueva Habitación', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                  ),
                ),
              ],
            ),
          ),

          // Lista
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _habitaciones.isEmpty
                    ? Center(
                        child: Text(
                          'No hay habitaciones registradas',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadHabitaciones,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _habitaciones.length,
                          itemBuilder: (context, index) {
                            final habitacion = _habitaciones[index];
                            final tipoHabitacion = habitacion['tipo_habitacion'] as Map<String, dynamic>?;
                            final estado = habitacion['estado'] as String? ?? 'desconocido';
                            final estadoColor = _getEstadoColor(estado);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: const Color(0xFF16213E),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: _getEstadoColorValue(estadoColor),
                                  child: Text(
                                    habitacion['numero_habitacion']?[0] ?? 'H',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Habitación ${habitacion['numero_habitacion']}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tipo: ${tipoHabitacion?['nombre'] ?? 'N/A'}',
                                      style: GoogleFonts.poppins(color: Colors.grey[400]),
                                    ),
                                    Text(
                                      'Estado: ${estado.toUpperCase()}',
                                      style: GoogleFonts.poppins(
                                        color: _getEstadoColorValue(estadoColor),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Máx. Huéspedes: ${habitacion['max_huespedes'] ?? 'N/A'}',
                                      style: GoogleFonts.poppins(color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF667eea)),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AdminHabitacionForm(
                                              habitacion: habitacion,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadHabitaciones();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteHabitacion(habitacion['numero_habitacion']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Color _getEstadoColorValue(String color) {
    switch (color) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

