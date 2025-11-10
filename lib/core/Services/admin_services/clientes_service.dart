import 'package:hotel_real_merced/core/services/supabase_service.dart';

class ClientesService {
  // Obtener todos los clientes
  Future<List<Map<String, dynamic>>> getAllClientes() async {
    try {
      final response = await SupabaseService.client
          .from('clientes')
          .select('*, personas(*)')
          .order('cliente_id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }

  // Obtener un cliente por ID
  Future<Map<String, dynamic>?> getClienteById(int id) async {
    try {
      final response = await SupabaseService.client
          .from('clientes')
          .select('*, personas(*)')
          .eq('cliente_id', id)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error al obtener cliente: $e');
    }
  }

  // Crear un nuevo cliente (primero crear persona, luego cliente)
  Future<void> createCliente(Map<String, dynamic> personaData, Map<String, dynamic> clienteData) async {
    try {
      // Crear persona primero
      final personaResponse = await SupabaseService.client
          .from('personas')
          .insert(personaData)
          .select()
          .single();

      // Crear cliente con la persona_id
      clienteData['persona_id'] = personaResponse['persona_id'];
      await SupabaseService.client
          .from('clientes')
          .insert(clienteData);
    } catch (e) {
      throw Exception('Error al crear cliente: $e');
    }
  }

  // Actualizar un cliente y su persona asociada
  Future<void> updateCliente(int clienteId, Map<String, dynamic> personaData, Map<String, dynamic> clienteData) async {
    try {
      // Obtener cliente para obtener persona_id
      final cliente = await getClienteById(clienteId);
      if (cliente == null) throw Exception('Cliente no encontrado');

      final personaId = cliente['persona_id'];

      // Actualizar persona
      await SupabaseService.client
          .from('personas')
          .update(personaData)
          .eq('persona_id', personaId);

      // Actualizar cliente
      await SupabaseService.client
          .from('clientes')
          .update(clienteData)
          .eq('cliente_id', clienteId);
    } catch (e) {
      throw Exception('Error al actualizar cliente: $e');
    }
  }

  // Eliminar un cliente
  Future<void> deleteCliente(int id) async {
    try {
      // Obtener cliente para obtener persona_id
      final cliente = await getClienteById(id);
      if (cliente == null) throw Exception('Cliente no encontrado');

      final personaId = cliente['persona_id'];

      // Eliminar cliente primero (por la foreign key)
      await SupabaseService.client
          .from('clientes')
          .delete()
          .eq('cliente_id', id);

      // Eliminar persona
      await SupabaseService.client
          .from('personas')
          .delete()
          .eq('persona_id', personaId);
    } catch (e) {
      throw Exception('Error al eliminar cliente: $e');
    }
  }
}

