import 'package:hotel_real_merced/core/services/supabase_service.dart';

class FacturasService {
  // Obtener todas las facturas
  Future<List<Map<String, dynamic>>> getAllFacturas() async {
    try {
      final response = await SupabaseService.client
          .from('facturas')
          .select('*, clientes(*, personas(*))')
          .order('fecha', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener facturas: $e');
    }
  }

  // Obtener una factura por ID
  Future<Map<String, dynamic>?> getFacturaById(int id) async {
    try {
      final response = await SupabaseService.client
          .from('facturas')
          .select('*, clientes(*, personas(*)), detalle_factura(*)')
          .eq('factura_id', id)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error al obtener factura: $e');
    }
  }

  // Crear una nueva factura con detalles
  Future<void> createFactura(Map<String, dynamic> factura, List<Map<String, dynamic>> detalles) async {
    try {
      // Crear factura
      final facturaResponse = await SupabaseService.client
          .from('facturas')
          .insert(factura)
          .select()
          .single();

      final facturaId = facturaResponse['factura_id'];

      // Crear detalles de factura
      if (detalles.isNotEmpty) {
        for (var detalle in detalles) {
          detalle['factura_id'] = facturaId;
        }
        await SupabaseService.client
            .from('detalle_factura')
            .insert(detalles);
      }
    } catch (e) {
      throw Exception('Error al crear factura: $e');
    }
  }

  // Actualizar una factura
  Future<void> updateFactura(int id, Map<String, dynamic> factura) async {
    try {
      await SupabaseService.client
          .from('facturas')
          .update(factura)
          .eq('factura_id', id);
    } catch (e) {
      throw Exception('Error al actualizar factura: $e');
    }
  }

  // Eliminar una factura
  Future<void> deleteFactura(int id) async {
    try {
      // Eliminar detalles primero
      await SupabaseService.client
          .from('detalle_factura')
          .delete()
          .eq('factura_id', id);

      // Eliminar factura
      await SupabaseService.client
          .from('facturas')
          .delete()
          .eq('factura_id', id);
    } catch (e) {
      throw Exception('Error al eliminar factura: $e');
    }
  }
}

