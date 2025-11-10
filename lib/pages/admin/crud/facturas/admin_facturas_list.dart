import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/facturas_service.dart';

class AdminFacturasList extends StatefulWidget {
  const AdminFacturasList({super.key});

  @override
  State<AdminFacturasList> createState() => _AdminFacturasListState();
}

class _AdminFacturasListState extends State<AdminFacturasList> {
  final FacturasService _service = FacturasService();
  List<Map<String, dynamic>> _facturas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacturas();
  }

  Future<void> _loadFacturas() async {
    setState(() => _isLoading = true);
    try {
      final facturas = await _service.getAllFacturas();
      setState(() {
        _facturas = facturas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          Container(padding: const EdgeInsets.all(24), color: const Color(0xFF16213E), child: Row(children: [Text('Facturas', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), const Spacer(), IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadFacturas)])),
          Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : _facturas.isEmpty ? Center(child: Text('No hay facturas', style: GoogleFonts.poppins(color: Colors.grey))) : RefreshIndicator(onRefresh: _loadFacturas, child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _facturas.length, itemBuilder: (context, index) {
            final factura = _facturas[index];
            final cliente = factura['clientes'] as Map<String, dynamic>?;
            final persona = cliente?['personas'] as Map<String, dynamic>?;
            final nombre = '${persona?['nombre'] ?? ''} ${persona?['apellido'] ?? ''}'.trim();
            return Card(margin: const EdgeInsets.only(bottom: 12), color: const Color(0xFF16213E), child: ListTile(contentPadding: const EdgeInsets.all(16), leading: CircleAvatar(backgroundColor: const Color(0xFF667eea), child: Text('F${factura['factura_id']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12))), title: Text('Factura #${factura['factura_id']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)), subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Cliente: ${nombre.isEmpty ? "N/A" : nombre}', style: GoogleFonts.poppins(color: Colors.grey[400])), Text('Fecha: ${factura['fecha']}', style: GoogleFonts.poppins(color: Colors.grey[400])), Text('Total: \$${factura['total'] ?? 0} ${factura['moneda'] ?? "NIO"}', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold))]), trailing: IconButton(icon: const Icon(Icons.visibility, color: Color(0xFF667eea)), onPressed: () async {
              final detalles = await _service.getFacturaById(factura['factura_id']);
              if (detalles != null && mounted) {
                showDialog(context: context, builder: (context) => AlertDialog(title: Text('Detalles Factura #${factura['factura_id']}', style: GoogleFonts.poppins()), content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Cliente: $nombre', style: GoogleFonts.poppins()), Text('Fecha: ${factura['fecha']}', style: GoogleFonts.poppins()), Text('Total: \$${factura['total']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), const Divider(), if (detalles['detalle_factura'] != null) ...((detalles['detalle_factura'] as List).map((d) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('Habitación: ${d['numero_habitacion']} - Cant: ${d['cant_habitaciones']} - Subtotal: \$${d['subtotal']}', style: GoogleFonts.poppins()))))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))]));
              }
            })));}))),
        ],
      ),
    );
  }
}

