-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

-- ============================================
-- CLASIFICACIÓN DE TABLAS POR TIPO DE USUARIO
-- ============================================

-- ============================================
-- TABLAS DE CRUD SOLO PARA ADMINISTRADOR
-- ============================================
-- Estas tablas solo pueden ser modificadas (CREATE, UPDATE, DELETE) por administradores
-- Los usuarios pueden leer (SELECT) algunas de estas tablas para consultar información
--
-- Tablas: clientes, comodidades, comodidades_habitacion, detalle_factura, 
--         facturas, habitaciones, imagenes_habitacion, tipo_habitacion

-- ============================================
-- TABLAS DE CRUD PARA USUARIOS
-- ============================================
-- Estas tablas pueden ser modificadas por los usuarios autenticados
-- Los usuarios solo pueden modificar sus propios registros
--
-- Tablas: personas, usuarios, reservaciones, edad_ninos, habitaciones_reservadas

-- ============================================
-- DEFINICIÓN DE TABLAS
-- ============================================

-- ============================================
-- TABLA: clientes
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de clientes del hotel
-- Usuario: Solo lectura de su propio registro
-- ============================================
CREATE TABLE public.clientes (
  cliente_id bigint NOT NULL DEFAULT nextval('clientes_cliente_id_seq'::regclass),
  persona_id bigint NOT NULL,
  fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  tipo_cliente text DEFAULT 'Regular'::text,
  CONSTRAINT clientes_pkey PRIMARY KEY (cliente_id),
  CONSTRAINT clientes_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(persona_id)
);
CREATE TABLE public.comodidades (
   comodidad_id bigint NOT NULL DEFAULT nextval('comodidades_comodidad_id_seq'::regclass),
   nombre text NOT NULL,
   descripcion text,
   CONSTRAINT comodidades_pkey PRIMARY KEY (comodidad_id)
 );

-- ============================================
-- TABLA: comodidades
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de comodidades disponibles en el hotel
-- Usuario: Solo lectura
-- ============================================

-- ============================================
-- TABLA: comodidades_habitacion
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Relación entre habitaciones y comodidades
-- Usuario: Solo lectura
-- ============================================
CREATE TABLE public.comodidades_habitacion (
  numero_habitacion text NOT NULL,
  comodidad_id bigint NOT NULL,
  CONSTRAINT comodidades_habitacion_pkey PRIMARY KEY (numero_habitacion, comodidad_id),
  CONSTRAINT comodidades_habitacion_numero_habitacion_fkey FOREIGN KEY (numero_habitacion) REFERENCES public.habitaciones(numero_habitacion),
  CONSTRAINT comodidades_habitacion_comodidad_id_fkey FOREIGN KEY (comodidad_id) REFERENCES public.comodidades(comodidad_id)
);
CREATE TABLE public.detalle_factura (
   detalle_id bigint NOT NULL DEFAULT nextval('detalle_factura_detalle_id_seq'::regclass),
   factura_id bigint NOT NULL,
   numero_habitacion text NOT NULL,
   cant_habitaciones integer NOT NULL,
   precio_unitario numeric NOT NULL,
   subtotal numeric DEFAULT ((cant_habitaciones)::numeric * precio_unitario),
   CONSTRAINT detalle_factura_pkey PRIMARY KEY (detalle_id),
   CONSTRAINT detalle_factura_factura_id_fkey FOREIGN KEY (factura_id) REFERENCES public.facturas(factura_id),
   CONSTRAINT detalle_factura_numero_habitacion_fkey FOREIGN KEY (numero_habitacion) REFERENCES public.habitaciones(numero_habitacion)
 );

-- ============================================
-- TABLA: detalle_factura
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Detalles de facturas del hotel
-- Usuario: Solo lectura de sus propias facturas
-- ============================================

-- ============================================
-- TABLA: edad_ninos
-- Tipo: USUARIO (CREATE solo al crear reserva)
-- Descripción: Edades de niños en las reservaciones
-- Usuario: Puede crear al hacer reserva, leer y actualizar sus propias reservas
-- ============================================
CREATE TABLE public.edad_ninos (
  id bigint NOT NULL DEFAULT nextval('edad_ninos_id_seq'::regclass),
  reserva_id uuid NOT NULL,
  edad integer NOT NULL,
  CONSTRAINT edad_ninos_pkey PRIMARY KEY (id),
  CONSTRAINT edad_ninos_reserva_id_fkey FOREIGN KEY (reserva_id) REFERENCES public.reservaciones(reservacion_id)
);
CREATE TABLE public.facturas (
   factura_id bigint NOT NULL DEFAULT nextval('facturas_factura_id_seq'::regclass),
   fecha date NOT NULL,
   cliente_id bigint NOT NULL,
   total numeric NOT NULL,
   moneda character varying DEFAULT 'NIO'::character varying,
   impuesto numeric DEFAULT 0,
   CONSTRAINT facturas_pkey PRIMARY KEY (factura_id),
   CONSTRAINT facturas_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id)
 );

-- ============================================
-- TABLA: facturas
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de facturas del hotel
-- Usuario: Solo lectura de sus propias facturas
-- ============================================

-- ============================================
-- TABLA: habitaciones
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de habitaciones del hotel
-- Usuario: Solo lectura (para ver disponibilidad)
-- ============================================
CREATE TABLE public.habitaciones (
  numero_habitacion text NOT NULL,
  tipo_habitacion_id bigint NOT NULL,
  estado text NOT NULL CHECK (estado = ANY (ARRAY['disponible'::text, 'ocupada'::text, 'mantenimiento'::text, 'limpieza'::text])),
  piso integer,
  max_huespedes integer NOT NULL,
  max_noches integer NOT NULL,
  ultimo_mantenimiento date,
  descripcion text,
  CONSTRAINT habitaciones_pkey PRIMARY KEY (numero_habitacion),
  CONSTRAINT habitaciones_tipo_habitacion_id_fkey FOREIGN KEY (tipo_habitacion_id) REFERENCES public.tipo_habitacion(tipo_habitacion_id)
);
CREATE TABLE public.habitaciones_reservadas (
   reservacion_id uuid NOT NULL,
   numero_habitacion text NOT NULL,
   precio_reserva numeric NOT NULL,
   CONSTRAINT habitaciones_reservadas_pkey PRIMARY KEY (reservacion_id, numero_habitacion),
   CONSTRAINT habitaciones_reservadas_reservacion_id_fkey FOREIGN KEY (reservacion_id) REFERENCES public.reservaciones(reservacion_id),
   CONSTRAINT habitaciones_reservadas_numero_habitacion_fkey FOREIGN KEY (numero_habitacion) REFERENCES public.habitaciones(numero_habitacion)
 );

-- ============================================
-- TABLA: habitaciones_reservadas
-- Tipo: ADMINISTRADOR (UPDATE, DELETE) / USUARIO (CREATE, READ)
-- Descripción: Relación entre reservaciones y habitaciones
-- Usuario: Puede crear al hacer reserva, leer y cancelar sus propias reservas
-- Administrador: Puede modificar y gestionar todas las reservas
-- ============================================

-- ============================================
-- TABLA: imagenes_habitacion
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de imágenes de habitaciones
-- Usuario: Solo lectura
-- ============================================
CREATE TABLE public.imagenes_habitacion (
  imagen_id bigint NOT NULL DEFAULT nextval('imagenes_habitacion_imagen_id_seq'::regclass),
  numero_habitacion text NOT NULL,
  url_imagen text NOT NULL,
  descripcion text,
  fecha_subida timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT imagenes_habitacion_pkey PRIMARY KEY (imagen_id),
  CONSTRAINT imagenes_habitacion_numero_habitacion_fkey FOREIGN KEY (numero_habitacion) REFERENCES public.habitaciones(numero_habitacion)
);
CREATE TABLE public.personas (
   persona_id bigint NOT NULL DEFAULT nextval('personas_persona_id_seq'::regclass),
   nombre text NOT NULL,
   apellido text NOT NULL,
   telefono text,
   CONSTRAINT personas_pkey PRIMARY KEY (persona_id)
 );

-- ============================================
-- TABLA: personas
-- Tipo: USUARIO (CRUD de su propio registro)
-- Descripción: Información personal de usuarios y clientes
-- Usuario: Puede crear, leer, actualizar y eliminar su propia información
-- Administrador: Puede gestionar todas las personas
-- ============================================

-- ============================================
-- TABLA: reservaciones
-- Tipo: USUARIO (CREATE, READ, UPDATE de sus propias reservas) / ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de reservaciones del hotel
-- Usuario: Puede crear reservas, leer y actualizar/cancelar sus propias reservas
-- Administrador: Puede gestionar todas las reservaciones
-- ============================================
CREATE TABLE public.reservaciones (
  reservacion_id uuid NOT NULL DEFAULT gen_random_uuid(),
  cliente_id bigint NOT NULL,
  check_in_date date NOT NULL,
  check_out_date date NOT NULL,
  booking_date date DEFAULT CURRENT_DATE,
  cant_habitaciones integer DEFAULT 1,
  num_noches integer,
  num_adultos integer NOT NULL,
  num_ninos integer NOT NULL,
  total_price numeric NOT NULL,
  status text NOT NULL CHECK (status = ANY (ARRAY['pendiente'::text, 'confirmada'::text, 'cancelada'::text, 'check-in'::text, 'check-out'::text])),
  special_requests text,
  CONSTRAINT reservaciones_pkey PRIMARY KEY (reservacion_id),
  CONSTRAINT reservaciones_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id)
);
CREATE TABLE public.tipo_habitacion (
   tipo_habitacion_id bigint NOT NULL DEFAULT nextval('tipo_habitacion_tipo_habitacion_id_seq'::regclass),
   nombre text NOT NULL,
   descripcion text,
   precio numeric NOT NULL,
   capacidad integer NOT NULL,
   CONSTRAINT tipo_habitacion_pkey PRIMARY KEY (tipo_habitacion_id)
 );

-- ============================================
-- TABLA: tipo_habitacion
-- Tipo: ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de tipos de habitaciones
-- Usuario: Solo lectura (para ver opciones disponibles)
-- ============================================

-- ============================================
-- TABLA: usuarios
-- Tipo: USUARIO (READ, UPDATE de su propio registro) / ADMINISTRADOR (CRUD completo)
-- Descripción: Gestión de usuarios del sistema
-- Usuario: Puede leer y actualizar su propio perfil de usuario
-- Administrador: Puede gestionar todos los usuarios
-- ============================================
CREATE TABLE public.usuarios (
  usuario_id bigint NOT NULL DEFAULT nextval('usuarios_usuario_id_seq'::regclass),
  persona_id bigint NOT NULL,
  email text NOT NULL UNIQUE,
  usuario_creado timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  supabase_user_id uuid UNIQUE,
  CONSTRAINT usuarios_pkey PRIMARY KEY (usuario_id),
  CONSTRAINT usuarios_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.personas(persona_id)
);

-- ============================================
-- RESUMEN DE CLASIFICACIÓN DE TABLAS
-- ============================================

-- ============================================
-- TABLAS EXCLUSIVAS DE ADMINISTRADOR (CRUD completo)
-- ============================================
-- 1. clientes - Gestión completa de clientes
-- 2. comodidades - Gestión de comodidades del hotel
-- 3. comodidades_habitacion - Relación habitaciones-comodidades
-- 4. detalle_factura - Detalles de facturas
-- 5. facturas - Gestión de facturas
-- 6. habitaciones - Gestión de habitaciones
-- 7. imagenes_habitacion - Gestión de imágenes de habitaciones
-- 8. tipo_habitacion - Gestión de tipos de habitaciones
--
-- Nota: Los usuarios solo tienen acceso de LECTURA (SELECT) a estas tablas
-- para consultar información (habitaciones disponibles, tipos, comodidades, etc.)

-- ============================================
-- TABLAS DE USUARIO (CRUD limitado a sus propios registros)
-- ============================================
-- 1. personas - CRUD de su propia información personal
-- 2. usuarios - READ y UPDATE de su propio perfil
-- 3. reservaciones - CREATE, READ, UPDATE de sus propias reservas
-- 4. edad_ninos - CREATE al hacer reserva, READ y UPDATE de sus reservas
-- 5. habitaciones_reservadas - CREATE al hacer reserva, READ de sus reservas
--
-- Nota: Los usuarios solo pueden modificar sus propios registros.
-- El administrador tiene CRUD completo en todas estas tablas.

-- ============================================
-- TABLAS COMPARTIDAS (Admin: CRUD completo / Usuario: CRUD limitado)
-- ============================================
-- 1. reservaciones - Admin: CRUD completo / Usuario: CREATE, READ, UPDATE propias
-- 2. habitaciones_reservadas - Admin: CRUD completo / Usuario: CREATE, READ propias
-- 3. usuarios - Admin: CRUD completo / Usuario: READ, UPDATE propio
-- 4. personas - Admin: CRUD completo / Usuario: CRUD propio

-- ============================================
-- PERMISOS RECOMENDADOS PARA RLS (Row Level Security)
-- ============================================

-- POLÍTICAS PARA ADMINISTRADORES:
-- - Todas las tablas: CREATE, SELECT, UPDATE, DELETE sin restricciones
-- - Verificar rol de administrador mediante función: auth.jwt() ->> 'role' = 'admin'

-- POLÍTICAS PARA USUARIOS:
-- - clientes: SELECT solo su propio registro (WHERE cliente_id = usuario.cliente_id)
-- - comodidades: SELECT todos (solo lectura)
-- - comodidades_habitacion: SELECT todos (solo lectura)
-- - detalle_factura: SELECT solo sus propias facturas
-- - facturas: SELECT solo sus propias facturas
-- - habitaciones: SELECT todas donde estado = 'disponible' (solo lectura)
-- - imagenes_habitacion: SELECT todas (solo lectura)
-- - tipo_habitacion: SELECT todas (solo lectura)
-- - personas: CRUD solo su propio registro
-- - reservaciones: CREATE, SELECT, UPDATE solo sus propias reservas
-- - edad_ninos: CREATE, SELECT, UPDATE solo relacionados con sus reservas
-- - habitaciones_reservadas: CREATE, SELECT solo relacionados con sus reservas
-- - usuarios: SELECT, UPDATE solo su propio registro

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================
-- 1. Los usuarios deben estar autenticados (auth.uid() no null)
-- 2. Los administradores deben tener un campo 'role' = 'admin' en su JWT
-- 3. Las políticas RLS deben implementarse en Supabase Dashboard
-- 4. Verificar siempre la relación usuario -> cliente -> persona para permisos
-- 5. Los usuarios solo pueden cancelar sus propias reservas (status = 'cancelada')
-- 6. Los administradores pueden cambiar cualquier estado de reserva