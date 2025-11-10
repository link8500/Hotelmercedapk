import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/reservaciones_service.dart';

class AdminReservacionesList extends StatefulWidget {
  const AdminReservacionesList({super.key});

  @override
  State<AdminReservacionesList> createState() => _AdminReservacionesListState();
}

class _AdminReservacionesListState extends State<AdminReservacionesList> {
  final ReservacionesService _service = ReservacionesService();
  List<Map<String, dynamic>> _reservaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservaciones();
  }

  Future<void> _loadReservaciones() async {
    setState(() => _isLoading = true);
    try {
      final reservaciones = await _service.getAllReservaciones();
      setState(() {
        _reservaciones = reservaciones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      await _service.updateReservacionStatus(id, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estado actualizado'), backgroundColor: Colors.green));
        _loadReservaciones();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'cancelada':
        return Colors.red;
      case 'check-in':
        return Colors.blue;
      case 'check-out':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          Container(padding: const EdgeInsets.all(24), color: const Color(0xFF16213E), child: Row(children: [Text('Reservaciones', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), const Spacer(), IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadReservaciones)])),
          Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : _reservaciones.isEmpty ? Center(child: Text('No hay reservaciones', style: GoogleFonts.poppins(color: Colors.grey))) : RefreshIndicator(onRefresh: _loadReservaciones, child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _reservaciones.length, itemBuilder: (context, index) {
            final reserva = _reservaciones[index];
            final cliente = reserva['clientes'] as Map<String, dynamic>?;
            final persona = cliente?['personas'] as Map<String, dynamic>?;
            final nombre = '${persona?['nombre'] ?? ''} ${persona?['apellido'] ?? ''}'.trim();
            final status = reserva['status'] ?? 'pendiente';
            final statusColor = _getStatusColor(status);
            return Card(margin: const EdgeInsets.only(bottom: 12), color: const Color(0xFF16213E), child: ExpansionTile(title: Text('Reserva ${reserva['reservacion_id'].toString().substring(0, 8)}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)), subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Cliente: ${nombre.isEmpty ? "N/A" : nombre}', style: GoogleFonts.poppins(color: Colors.grey[400])), Text('Estado: ${status.toUpperCase()}', style: GoogleFonts.poppins(color: statusColor, fontWeight: FontWeight.w500))]), leading: Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor)), children: [
              Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Check-in: ${reserva['check_in_date']}', style: GoogleFonts.poppins(color: Colors.grey[400])),
                Text('Check-out: ${reserva['check_out_date']}', style: GoogleFonts.poppins(color: Colors.grey[400])),
                Text('Habitaciones: ${reserva['cant_habitaciones'] ?? 1}', style: GoogleFonts.poppins(color: Colors.grey[400])),
                Text('Huéspedes: ${reserva['num_adultos'] ?? 0} adultos, ${reserva['num_ninos'] ?? 0} niños', style: GoogleFonts.poppins(color: Colors.grey[400])),
                Text('Total: \$${reserva['total_price'] ?? 0}', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(spacing: 8, runSpacing: 8, children: ['pendiente', 'confirmada', 'check-in', 'check-out', 'cancelada'].map((s) => ElevatedButton(onPressed: () => _updateStatus(reserva['reservacion_id'], s), style: ElevatedButton.styleFrom(backgroundColor: s == status ? statusColor : Colors.grey[800]!, foregroundColor: Colors.white), child: Text(s.toUpperCase(), style: GoogleFonts.poppins(fontSize: 12)))).toList())
              ]))
            ]));}))),
        ],
      ),
    );
  }
}

