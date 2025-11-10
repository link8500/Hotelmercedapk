import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/tipo_habitacion_service.dart';

class AdminTipoHabitacionForm extends StatefulWidget {
  final Map<String, dynamic>? tipoHabitacion;
  const AdminTipoHabitacionForm({super.key, this.tipoHabitacion});

  @override
  State<AdminTipoHabitacionForm> createState() => _AdminTipoHabitacionFormState();
}

class _AdminTipoHabitacionFormState extends State<AdminTipoHabitacionForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = TipoHabitacionService();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _capacidadController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.tipoHabitacion != null) {
      _nombreController.text = widget.tipoHabitacion!['nombre'] ?? '';
      _descripcionController.text = widget.tipoHabitacion!['descripcion'] ?? '';
      _precioController.text = widget.tipoHabitacion!['precio']?.toString() ?? '';
      _capacidadController.text = widget.tipoHabitacion!['capacidad']?.toString() ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final data = {
        'nombre': _nombreController.text.trim(),
        'descripcion': _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim(),
        'precio': double.parse(_precioController.text),
        'capacidad': int.parse(_capacidadController.text),
      };

      if (widget.tipoHabitacion == null) {
        await _service.createTipoHabitacion(data);
      } else {
        await _service.updateTipoHabitacion(widget.tipoHabitacion!['tipo_habitacion_id'], data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.tipoHabitacion == null ? 'Creado' : 'Actualizado'), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _capacidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: Text(widget.tipoHabitacion == null ? 'Nuevo Tipo' : 'Editar Tipo', style: GoogleFonts.poppins()), backgroundColor: const Color(0xFF16213E)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nombreController, 'Nombre *', validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null),
              const SizedBox(height: 16),
              _buildTextField(_descripcionController, 'Descripción', maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_precioController, 'Precio *', keyboardType: TextInputType.number, validator: (v) {
                if (v?.isEmpty ?? true) return 'Requerido';
                if (double.tryParse(v!) == null) return 'Número inválido';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextField(_capacidadController, 'Capacidad *', keyboardType: TextInputType.number, validator: (v) {
                if (v?.isEmpty ?? true) return 'Requerido';
                if (int.tryParse(v!) == null) return 'Número inválido';
                return null;
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF667eea), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('Guardar', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType, String? Function(String?)? validator, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.poppins(color: Colors.grey[400]), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      style: GoogleFonts.poppins(color: Colors.white),
      validator: validator,
    );
  }
}

