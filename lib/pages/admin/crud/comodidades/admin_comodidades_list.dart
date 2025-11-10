import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/comodidades_service.dart';
import 'package:hotel_real_merced/pages/admin/crud/comodidades/admin_comodidad_form.dart';

class AdminComodidadesList extends StatefulWidget {
  const AdminComodidadesList({super.key});

  @override
  State<AdminComodidadesList> createState() => _AdminComodidadesListState();
}

class _AdminComodidadesListState extends State<AdminComodidadesList> {
  final ComodidadesService _service = ComodidadesService();
  List<Map<String, dynamic>> _comodidades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComodidades();
  }

  Future<void> _loadComodidades() async {
    setState(() => _isLoading = true);
    try {
      final comodidades = await _service.getAllComodidades();
      setState(() {
        _comodidades = comodidades;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _deleteComodidad(int id, String nombre) async {
    final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: Text('Eliminar', style: GoogleFonts.poppins()), content: Text('¿Eliminar "$nombre"?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')), TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar', style: TextStyle(color: Colors.red)))],));
    if (confirm == true) {
      try {
        await _service.deleteComodidad(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado'), backgroundColor: Colors.green));
          _loadComodidades();
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          Container(padding: const EdgeInsets.all(24), color: const Color(0xFF16213E), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Comodidades', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), ElevatedButton.icon(onPressed: () async { final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminComodidadForm())); if (result == true) _loadComodidades(); }, icon: const Icon(Icons.add), label: Text('Nueva', style: GoogleFonts.poppins()), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF667eea)))])),
          Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : _comodidades.isEmpty ? Center(child: Text('No hay comodidades', style: GoogleFonts.poppins(color: Colors.grey))) : RefreshIndicator(onRefresh: _loadComodidades, child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _comodidades.length, itemBuilder: (context, index) {
            final comodidad = _comodidades[index];
            return Card(margin: const EdgeInsets.only(bottom: 12), color: const Color(0xFF16213E), child: ListTile(contentPadding: const EdgeInsets.all(16), title: Text(comodidad['nombre'] ?? 'N/A', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)), subtitle: comodidad['descripcion'] != null ? Text(comodidad['descripcion'], style: GoogleFonts.poppins(color: Colors.grey[400])) : null, trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.edit, color: Color(0xFF667eea)), onPressed: () async { final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminComodidadForm(comodidad: comodidad))); if (result == true) _loadComodidades(); }), IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteComodidad(comodidad['comodidad_id'], comodidad['nombre']))])));}))),
        ],
      ),
    );
  }
}

