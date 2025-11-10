import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_real_merced/core/services/admin_services/habitaciones_service.dart';
import 'package:hotel_real_merced/core/services/admin_services/tipo_habitacion_service.dart';

class AdminHabitacionForm extends StatefulWidget {
  final Map<String, dynamic>? habitacion;

  const AdminHabitacionForm({super.key, this.habitacion});

  @override
  State<AdminHabitacionForm> createState() => _AdminHabitacionFormState();
}

class _AdminHabitacionFormState extends State<AdminHabitacionForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = HabitacionesService();
  final _tipoHabitacionService = TipoHabitacionService();
  
  final _numeroController = TextEditingController();
  final _pisoController = TextEditingController();
  final _maxHuespedesController = TextEditingController();
  final _maxNochesController = TextEditingController();
  final _descripcionController = TextEditingController();
  
  String _estado = 'disponible';
  int? _selectedTipoHabitacionId;
  List<Map<String, dynamic>> _tiposHabitacion = [];
  bool _isLoading = false;
  bool _isLoadingTipos = true;

  @override
  void initState() {
    super.initState();
    _loadTiposHabitacion();
    if (widget.habitacion != null) {
      _loadHabitacionData();
    }
  }

  void _loadHabitacionData() {
    final habitacion = widget.habitacion!;
    _numeroController.text = habitacion['numero_habitacion'] ?? '';
    _pisoController.text = habitacion['piso']?.toString() ?? '';
    _maxHuespedesController.text = habitacion['max_huespedes']?.toString() ?? '';
    _maxNochesController.text = habitacion['max_noches']?.toString() ?? '';
    _descripcionController.text = habitacion['descripcion'] ?? '';
    _estado = habitacion['estado'] ?? 'disponible';
    
    final tipoHabitacion = habitacion['tipo_habitacion'] as Map<String, dynamic>?;
    if (tipoHabitacion != null) {
      _selectedTipoHabitacionId = tipoHabitacion['tipo_habitacion_id'];
    }
  }

  Future<void> _loadTiposHabitacion() async {
    try {
      final tipos = await _tipoHabitacionService.getAllTiposHabitacion();
      setState(() {
        _tiposHabitacion = tipos;
        _isLoadingTipos = false;
        
        // Si estamos editando y no hay tipo seleccionado, seleccionar el primero
        if (_selectedTipoHabitacionId == null && tipos.isNotEmpty) {
          _selectedTipoHabitacionId = tipos.first['tipo_habitacion_id'];
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingTipos = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar tipos de habitación: $e')),
        );
      }
    }
  }

  Future<void> _saveHabitacion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTipoHabitacionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un tipo de habitación')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final habitacionData = {
        'numero_habitacion': _numeroController.text.trim(),
        'tipo_habitacion_id': _selectedTipoHabitacionId,
        'estado': _estado,
        'piso': _pisoController.text.isEmpty ? null : int.tryParse(_pisoController.text),
        'max_huespedes': int.parse(_maxHuespedesController.text),
        'max_noches': int.parse(_maxNochesController.text),
        'descripcion': _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim(),
      };

      if (widget.habitacion == null) {
        await _service.createHabitacion(habitacionData);
      } else {
        await _service.updateHabitacion(_numeroController.text.trim(), habitacionData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.habitacion == null 
                ? 'Habitación creada exitosamente' 
                : 'Habitación actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar habitación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _pisoController.dispose();
    _maxHuespedesController.dispose();
    _maxNochesController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(
          widget.habitacion == null ? 'Nueva Habitación' : 'Editar Habitación',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: _isLoadingTipos
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Número de habitación
                    TextFormField(
                      controller: _numeroController,
                      decoration: InputDecoration(
                        labelText: 'Número de Habitación *',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                      enabled: widget.habitacion == null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tipo de habitación
                    DropdownButtonFormField<int>(
                      value: _selectedTipoHabitacionId,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Habitación *',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: Colors.grey[900],
                      style: GoogleFonts.poppins(color: Colors.white),
                      items: _tiposHabitacion.map((tipo) {
                        return DropdownMenuItem<int>(
                          value: tipo['tipo_habitacion_id'],
                          child: Text(tipo['nombre'] ?? 'N/A'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTipoHabitacionId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un tipo de habitación';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Estado
                    DropdownButtonFormField<String>(
                      value: _estado,
                      decoration: InputDecoration(
                        labelText: 'Estado *',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: Colors.grey[900],
                      style: GoogleFonts.poppins(color: Colors.white),
                      items: ['disponible', 'ocupada', 'mantenimiento', 'limpieza']
                          .map((estado) => DropdownMenuItem<String>(
                                value: estado,
                                child: Text(estado.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _estado = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Piso
                    TextFormField(
                      controller: _pisoController,
                      decoration: InputDecoration(
                        labelText: 'Piso',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Máximo de huéspedes
                    TextFormField(
                      controller: _maxHuespedesController,
                      decoration: InputDecoration(
                        labelText: 'Máximo de Huéspedes *',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Máximo de noches
                    TextFormField(
                      controller: _maxNochesController,
                      decoration: InputDecoration(
                        labelText: 'Máximo de Noches *',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    TextFormField(
                      controller: _descripcionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Botón de guardar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveHabitacion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Guardar',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

