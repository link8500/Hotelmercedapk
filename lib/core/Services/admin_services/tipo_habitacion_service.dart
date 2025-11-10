import 'package:hotel_real_merced/core/services/supabase_service.dart';

class TipoHabitacionService {
  // Obtener todos los tipos de habitación
  Future<List<Map<String, dynamic>>> getAllTiposHabitacion() async {
    try {
      final response = await SupabaseService.client
          .from('tipo_habitacion')
          .select()
          .order('nombre');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener tipos de habitación: $e');
    }
  }

  // Obtener un tipo de habitación por ID
  Future<Map<String, dynamic>?> getTipoHabitacionById(int id) async {
    try {
      final response = await SupabaseService.client
          .from('tipo_habitacion')
          .select()
          .eq('tipo_habitacion_id', id)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error al obtener tipo de habitación: $e');
    }
  }

  // Crear un nuevo tipo de habitación
  Future<void> createTipoHabitacion(Map<String, dynamic> tipoHabitacion) async {
    try {
      await SupabaseService.client
          .from('tipo_habitacion')
          .insert(tipoHabitacion);
    } catch (e) {
      throw Exception('Error al crear tipo de habitación: $e');
    }
  }

  // Actualizar un tipo de habitación
  Future<void> updateTipoHabitacion(int id, Map<String, dynamic> tipoHabitacion) async {
    try {
      await SupabaseService.client
          .from('tipo_habitacion')
          .update(tipoHabitacion)
          .eq('tipo_habitacion_id', id);
    } catch (e) {
      throw Exception('Error al actualizar tipo de habitación: $e');
    }
  }

  // Eliminar un tipo de habitación
  Future<void> deleteTipoHabitacion(int id) async {
    try {
      await SupabaseService.client
          .from('tipo_habitacion')
          .delete()
          .eq('tipo_habitacion_id', id);
    } catch (e) {
      throw Exception('Error al eliminar tipo de habitación: $e');
    }
  }
}

