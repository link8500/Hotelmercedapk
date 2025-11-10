import 'package:hotel_real_merced/core/services/supabase_service.dart';

class HabitacionesService {
  // Obtener todas las habitaciones
  Future<List<Map<String, dynamic>>> getAllHabitaciones() async {
    try {
      final response = await SupabaseService.client
          .from('habitaciones')
          .select('*, tipo_habitacion(*)')
          .order('numero_habitacion');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener habitaciones: $e');
    }
  }

  // Obtener una habitación por ID
  Future<Map<String, dynamic>?> getHabitacionById(String numeroHabitacion) async {
    try {
      final response = await SupabaseService.client
          .from('habitaciones')
          .select('*, tipo_habitacion(*)')
          .eq('numero_habitacion', numeroHabitacion)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error al obtener habitación: $e');
    }
  }

  // Crear una nueva habitación
  Future<void> createHabitacion(Map<String, dynamic> habitacion) async {
    try {
      await SupabaseService.client
          .from('habitaciones')
          .insert(habitacion);
    } catch (e) {
      throw Exception('Error al crear habitación: $e');
    }
  }

  // Actualizar una habitación
  Future<void> updateHabitacion(String numeroHabitacion, Map<String, dynamic> habitacion) async {
    try {
      await SupabaseService.client
          .from('habitaciones')
          .update(habitacion)
          .eq('numero_habitacion', numeroHabitacion);
    } catch (e) {
      throw Exception('Error al actualizar habitación: $e');
    }
  }

  // Eliminar una habitación
  Future<void> deleteHabitacion(String numeroHabitacion) async {
    try {
      await SupabaseService.client
          .from('habitaciones')
          .delete()
          .eq('numero_habitacion', numeroHabitacion);
    } catch (e) {
      throw Exception('Error al eliminar habitación: $e');
    }
  }
}

