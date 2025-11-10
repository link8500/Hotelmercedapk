import 'package:hotel_real_merced/core/services/supabase_service.dart';

class ReservacionesService {
  // Obtener todas las reservaciones
  Future<List<Map<String, dynamic>>> getAllReservaciones() async {
    try {
      final response = await SupabaseService.client
          .from('reservaciones')
          .select('*, clientes(*, personas(*))')
          .order('booking_date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener reservaciones: $e');
    }
  }

  // Obtener una reservación por ID
  Future<Map<String, dynamic>?> getReservacionById(String id) async {
    try {
      final response = await SupabaseService.client
          .from('reservaciones')
          .select('*, clientes(*, personas(*)), habitaciones_reservadas(*)')
          .eq('reservacion_id', id)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error al obtener reservación: $e');
    }
  }

  // Crear una nueva reservación
  Future<void> createReservacion(Map<String, dynamic> reservacion) async {
    try {
      await SupabaseService.client
          .from('reservaciones')
          .insert(reservacion);
    } catch (e) {
      throw Exception('Error al crear reservación: $e');
    }
  }

  // Actualizar una reservación
  Future<void> updateReservacion(String id, Map<String, dynamic> reservacion) async {
    try {
      await SupabaseService.client
          .from('reservaciones')
          .update(reservacion)
          .eq('reservacion_id', id);
    } catch (e) {
      throw Exception('Error al actualizar reservación: $e');
    }
  }

  // Eliminar una reservación
  Future<void> deleteReservacion(String id) async {
    try {
      await SupabaseService.client
          .from('reservaciones')
          .delete()
          .eq('reservacion_id', id);
    } catch (e) {
      throw Exception('Error al eliminar reservación: $e');
    }
  }

  // Cambiar estado de reservación
  Future<void> updateReservacionStatus(String id, String status) async {
    try {
      await SupabaseService.client
          .from('reservaciones')
          .update({'status': status})
          .eq('reservacion_id', id);
    } catch (e) {
      throw Exception('Error al actualizar estado de reservación: $e');
    }
  }
}

