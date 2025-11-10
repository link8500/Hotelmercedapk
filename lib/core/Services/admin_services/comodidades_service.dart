import 'package:hotel_real_merced/core/services/supabase_service.dart';

class ComodidadesService {
  // Obtener todas las comodidades
  Future<List<Map<String, dynamic>>> getAllComodidades() async {
    try {
      final response = await SupabaseService.client
          .from('comodidades')
          .select()
          .order('nombre');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener comodidades: $e');
    }
  }

  // Obtener una comodidad por ID
  Future<Map<String, dynamic>?> getComodidadById(int id) async {
    try {
      final response = await SupabaseService.client
          .from('comodidades')
          .select()
          .eq('comodidad_id', id)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error al obtener comodidad: $e');
    }
  }

  // Crear una nueva comodidad
  Future<void> createComodidad(Map<String, dynamic> comodidad) async {
    try {
      await SupabaseService.client
          .from('comodidades')
          .insert(comodidad);
    } catch (e) {
      throw Exception('Error al crear comodidad: $e');
    }
  }

  // Actualizar una comodidad
  Future<void> updateComodidad(int id, Map<String, dynamic> comodidad) async {
    try {
      await SupabaseService.client
          .from('comodidades')
          .update(comodidad)
          .eq('comodidad_id', id);
    } catch (e) {
      throw Exception('Error al actualizar comodidad: $e');
    }
  }

  // Eliminar una comodidad
  Future<void> deleteComodidad(int id) async {
    try {
      await SupabaseService.client
          .from('comodidades')
          .delete()
          .eq('comodidad_id', id);
    } catch (e) {
      throw Exception('Error al eliminar comodidad: $e');
    }
  }
}

