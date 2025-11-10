import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/clientes_service.dart';
import 'package:hotel_real_merced/pages/admin/crud/clientes/admin_cliente_form.dart';

class AdminClientesList extends StatefulWidget {
  const AdminClientesList({super.key});

  @override
  State<AdminClientesList> createState() => _AdminClientesListState();
}

class _AdminClientesListState extends State<AdminClientesList> {
  final ClientesService _service = ClientesService();
  List<Map<String, dynamic>> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    setState(() => _isLoading = true);
    try {
      final clientes = await _service.getAllClientes();
      setState(() {
        _clientes = clientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _deleteCliente(int id, String nombre) async {
    final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: Text('Eliminar Cliente', style: GoogleFonts.poppins()), content: Text('¿Eliminar "$nombre"?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')), TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar', style: TextStyle(color: Colors.red)))]));
    if (confirm == true) {
      try {
        await _service.deleteCliente(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado'), backgroundColor: Colors.green));
          _loadClientes();
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
          Container(padding: const EdgeInsets.all(24), color: const Color(0xFF16213E), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Clientes', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), ElevatedButton.icon(onPressed: () async { final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminClienteForm())); if (result == true) _loadClientes(); }, icon: const Icon(Icons.add), label: Text('Nuevo Cliente', style: GoogleFonts.poppins()), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF667eea)))])),
          Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : _clientes.isEmpty ? Center(child: Text('No hay clientes', style: GoogleFonts.poppins(color: Colors.grey))) : RefreshIndicator(onRefresh: _loadClientes, child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _clientes.length, itemBuilder: (context, index) {
            final cliente = _clientes[index];
            final persona = cliente['personas'] as Map<String, dynamic>?;
            final nombre = '${persona?['nombre'] ?? ''} ${persona?['apellido'] ?? ''}'.trim();
            return Card(margin: const EdgeInsets.only(bottom: 12), color: const Color(0xFF16213E), child: ListTile(contentPadding: const EdgeInsets.all(16), leading: CircleAvatar(backgroundColor: const Color(0xFF667eea), child: Text(nombre.isNotEmpty ? nombre[0].toUpperCase() : 'C', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white))), title: Text(nombre.isEmpty ? 'Cliente #${cliente['cliente_id']}' : nombre, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)), subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Tel: ${persona?['telefono'] ?? 'N/A'}', style: GoogleFonts.poppins(color: Colors.grey[400])), Text('Tipo: ${cliente['tipo_cliente'] ?? 'Regular'}', style: GoogleFonts.poppins(color: Colors.grey[400]))]), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.edit, color: Color(0xFF667eea)), onPressed: () async { final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminClienteForm(cliente: cliente))); if (result == true) _loadClientes(); }), IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCliente(cliente['cliente_id'], nombre))])));}))),
        ],
      ),
    );
  }
}

