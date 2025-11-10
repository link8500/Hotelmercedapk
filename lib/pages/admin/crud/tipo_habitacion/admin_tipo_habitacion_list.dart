import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/tipo_habitacion_service.dart';
import 'package:hotel_real_merced/pages/admin/crud/tipo_habitacion/admin_tipo_habitacion_form.dart';

class AdminTipoHabitacionList extends StatefulWidget {
  const AdminTipoHabitacionList({super.key});

  @override
  State<AdminTipoHabitacionList> createState() => _AdminTipoHabitacionListState();
}

class _AdminTipoHabitacionListState extends State<AdminTipoHabitacionList> {
  final TipoHabitacionService _service = TipoHabitacionService();
  List<Map<String, dynamic>> _tipos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTipos();
  }

  Future<void> _loadTipos() async {
    setState(() => _isLoading = true);
    try {
      final tipos = await _service.getAllTiposHabitacion();
      setState(() {
        _tipos = tipos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteTipo(int id, String nombre) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Tipo', style: GoogleFonts.poppins()),
        content: Text('¿Eliminar "$nombre"?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteTipoHabitacion(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado'), backgroundColor: Colors.green));
          _loadTipos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF16213E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tipos de Habitación', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminTipoHabitacionForm()));
                    if (result == true) _loadTipos();
                  },
                  icon: const Icon(Icons.add),
                  label: Text('Nuevo Tipo', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF667eea)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tipos.isEmpty
                    ? Center(child: Text('No hay tipos registrados', style: GoogleFonts.poppins(color: Colors.grey)))
                    : RefreshIndicator(
                        onRefresh: _loadTipos,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _tipos.length,
                          itemBuilder: (context, index) {
                            final tipo = _tipos[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: const Color(0xFF16213E),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(tipo['nombre'] ?? 'N/A', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Precio: \$${tipo['precio'] ?? '0'}', style: GoogleFonts.poppins(color: Colors.grey[400])),
                                    Text('Capacidad: ${tipo['capacidad'] ?? '0'} personas', style: GoogleFonts.poppins(color: Colors.grey[400])),
                                    if (tipo['descripcion'] != null) Text(tipo['descripcion'], style: GoogleFonts.poppins(color: Colors.grey[400])),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(icon: const Icon(Icons.edit, color: Color(0xFF667eea)), onPressed: () async {
                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTipoHabitacionForm(tipoHabitacion: tipo)));
                                      if (result == true) _loadTipos();
                                    }),
                                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteTipo(tipo['tipo_habitacion_id'], tipo['nombre'])),
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
}

