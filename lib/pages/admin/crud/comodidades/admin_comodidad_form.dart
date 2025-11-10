import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/comodidades_service.dart';

class AdminComodidadForm extends StatefulWidget {
  final Map<String, dynamic>? comodidad;
  const AdminComodidadForm({super.key, this.comodidad});

  @override
  State<AdminComodidadForm> createState() => _AdminComodidadFormState();
}

class _AdminComodidadFormState extends State<AdminComodidadForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = ComodidadesService();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.comodidad != null) {
      _nombreController.text = widget.comodidad!['nombre'] ?? '';
      _descripcionController.text = widget.comodidad!['descripcion'] ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final data = {'nombre': _nombreController.text.trim(), 'descripcion': _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim()};
      if (widget.comodidad == null) {
        await _service.createComodidad(data);
      } else {
        await _service.updateComodidad(widget.comodidad!['comodidad_id'], data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.comodidad == null ? 'Creado' : 'Actualizado'), backgroundColor: Colors.green));
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
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF1A1A2E), appBar: AppBar(title: Text(widget.comodidad == null ? 'Nueva Comodidad' : 'Editar Comodidad', style: GoogleFonts.poppins()), backgroundColor: const Color(0xFF16213E)), body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(children: [TextFormField(controller: _nombreController, decoration: InputDecoration(labelText: 'Nombre *', labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white), validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null), const SizedBox(height: 16), TextFormField(controller: _descripcionController, maxLines: 3, decoration: InputDecoration(labelText: 'Descripción', labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)), const SizedBox(height: 32), ElevatedButton(onPressed: _isLoading ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF667eea), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('Guardar', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)))]))));
  }
}

