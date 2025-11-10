-- ============================================
-- Hotel Real Merced - Consultas SQL
-- ============================================
-- 
-- Este archivo contiene consultas SQL útiles
-- para el proyecto Hotel Real Merced
--
-- ============================================

-- ============================================
-- CONSULTAS DE USUARIOS
-- ============================================

-- Ver todos los usuarios
-- SELECT * FROM auth.users;

-- Ver perfiles de usuarios (si tienes una tabla de perfiles)
-- SELECT * FROM public.profiles;

-- ============================================
-- CONSULTAS DE RESERVAS
-- ============================================

-- Ver todas las reservas (ejemplo)
-- SELECT * FROM public.reservas;

-- Ver reservas por usuario
-- SELECT * FROM public.reservas WHERE user_id = 'user-uuid-here';

-- ============================================
-- CONSULTAS DE HABITACIONES
-- ============================================

-- Ver todas las habitaciones (ejemplo)
-- SELECT * FROM public.habitaciones;

-- Ver habitaciones disponibles
-- SELECT * FROM public.habitaciones WHERE disponible = true;

-- ============================================
-- CONSULTAS DE SERVICIOS
-- ============================================

-- Ver todos los servicios (ejemplo)
-- SELECT * FROM public.servicios;

-- ============================================
-- CONSULTAS DE ESTADÍSTICAS
-- ============================================

-- Contar usuarios registrados
-- SELECT COUNT(*) as total_usuarios FROM auth.users;

-- Contar reservas activas
-- SELECT COUNT(*) as reservas_activas FROM public.reservas WHERE estado = 'activa';

-- ============================================
-- NOTAS
-- ============================================

-- Agrega tus consultas SQL útiles aquí
-- Recuerda ajustar los nombres de tablas según tu esquema de Supabase

