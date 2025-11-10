import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/clientes_service.dart';

class AdminClienteForm extends StatefulWidget {
  final Map<String, dynamic>? cliente;
  const AdminClienteForm({super.key, this.cliente});

  @override
  State<AdminClienteForm> createState() => _AdminClienteFormState();
}

class _AdminClienteFormState extends State<AdminClienteForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = ClientesService();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  String _tipoCliente = 'Regular';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      final persona = widget.cliente!['personas'] as Map<String, dynamic>?;
      _nombreController.text = persona?['nombre'] ?? '';
      _apellidoController.text = persona?['apellido'] ?? '';
      _telefonoController.text = persona?['telefono'] ?? '';
      _tipoCliente = widget.cliente!['tipo_cliente'] ?? 'Regular';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final personaData = {'nombre': _nombreController.text.trim(), 'apellido': _apellidoController.text.trim(), 'telefono': _telefonoController.text.trim().isEmpty ? null : _telefonoController.text.trim()};
      final clienteData = {'tipo_cliente': _tipoCliente};
      if (widget.cliente == null) {
        await _service.createCliente(personaData, clienteData);
      } else {
        await _service.updateCliente(widget.cliente!['cliente_id'], personaData, clienteData);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.cliente == null ? 'Creado' : 'Actualizado'), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF1A1A2E), appBar: AppBar(title: Text(widget.cliente == null ? 'Nuevo Cliente' : 'Editar Cliente', style: GoogleFonts.poppins()), backgroundColor: const Color(0xFF16213E)), body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(children: [TextFormField(controller: _nombreController, decoration: InputDecoration(labelText: 'Nombre *', labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white), validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null), const SizedBox(height: 16), TextFormField(controller: _apellidoController, decoration: InputDecoration(labelText: 'Apellido *', labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white), validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null), const SizedBox(height: 16), TextFormField(controller: _telefonoController, decoration: InputDecoration(labelText: 'Teléfono', labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white), keyboardType: TextInputType.phone), const SizedBox(height: 16), DropdownButtonFormField<String>(value: _tipoCliente, decoration: InputDecoration(labelText: 'Tipo de Cliente', labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), dropdownColor: Colors.grey[900], style: GoogleFonts.poppins(color: Colors.white), items: ['Regular', 'VIP', 'Premium'].map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(), onChanged: (v) => setState(() => _tipoCliente = v!)), const SizedBox(height: 32), ElevatedButton(onPressed: _isLoading ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF667eea), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('Guardar', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)))]))));
  }
}

