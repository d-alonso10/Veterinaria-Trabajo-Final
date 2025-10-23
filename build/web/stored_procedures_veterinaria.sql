-- ============================================================
-- STORED PROCEDURES VETERINARIA TERÁN VET
-- Compatibilidad: MySQL 8.x / Java 8 (1.8.0_202) / NetBeans 8.2
-- Autor: Análisis y mejora del sistema existente
-- ============================================================

USE vet_teran;

-- ============================================================
-- 1. STORED PROCEDURES PARA ATENCIONES
-- ============================================================

DELIMITER //

-- Crear atención walk-in (sin cita previa)
DROP PROCEDURE IF EXISTS sp_CrearAtencionWalkIn//
CREATE PROCEDURE sp_CrearAtencionWalkIn(
    IN p_id_mascota INT,
    IN p_id_cliente INT,
    IN p_id_groomer INT,
    IN p_id_sucursal INT,
    IN p_turno_num INT,
    IN p_tiempo_estimado_inicio DATETIME,
    IN p_tiempo_estimado_fin DATETIME,
    IN p_prioridad TINYINT,
    IN p_observaciones TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO atencion (
        id_mascota, 
        id_cliente, 
        id_groomer, 
        id_sucursal, 
        estado, 
        turno_num, 
        tiempo_estimado_inicio,
        tiempo_estimado_fin, 
        prioridad, 
        observaciones
    ) VALUES (
        p_id_mascota, 
        p_id_cliente, 
        p_id_groomer, 
        NULLIF(p_id_sucursal, 0), 
        'en_espera', 
        NULLIF(p_turno_num, 0),
        p_tiempo_estimado_inicio, 
        p_tiempo_estimado_fin, 
        NULLIF(p_prioridad, 0), 
        p_observaciones
    );
    
    COMMIT;
END//

-- Actualizar estado de atención
DROP PROCEDURE IF EXISTS sp_ActualizarEstadoAtencion//
CREATE PROCEDURE sp_ActualizarEstadoAtencion(
    IN p_id_atencion INT,
    IN p_nuevo_estado ENUM('en_espera','en_servicio','pausado','terminado')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE atencion 
    SET estado = p_nuevo_estado,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_atencion = p_id_atencion;
    
    -- Si cambia a 'en_servicio', establecer tiempo_real_inicio
    IF p_nuevo_estado = 'en_servicio' THEN
        UPDATE atencion 
        SET tiempo_real_inicio = CURRENT_TIMESTAMP
        WHERE id_atencion = p_id_atencion AND tiempo_real_inicio IS NULL;
    END IF;
    
    -- Si cambia a 'terminado', establecer tiempo_real_fin
    IF p_nuevo_estado = 'terminado' THEN
        UPDATE atencion 
        SET tiempo_real_fin = CURRENT_TIMESTAMP
        WHERE id_atencion = p_id_atencion AND tiempo_real_fin IS NULL;
    END IF;
    
    COMMIT;
END//

-- Obtener cola actual de atenciones
DROP PROCEDURE IF EXISTS sp_ObtenerColaActual//
CREATE PROCEDURE sp_ObtenerColaActual(
    IN p_id_sucursal INT
)
BEGIN
    SELECT 
        a.id_atencion,
        COALESCE(m.nombre, 'Sin nombre') as mascota,
        CONCAT(COALESCE(c.nombre, ''), ' ', COALESCE(c.apellido, '')) as cliente,
        COALESCE(g.nombre, 'No asignado') as groomer,
        a.estado,
        COALESCE(a.turno_num, 0) as turno_num,
        a.tiempo_estimado_inicio,
        a.tiempo_estimado_fin,
        a.tiempo_real_inicio,
        a.tiempo_real_fin,
        a.prioridad,
        a.observaciones
    FROM atencion a
    LEFT JOIN mascota m ON a.id_mascota = m.id_mascota
    LEFT JOIN cliente c ON a.id_cliente = c.id_cliente
    LEFT JOIN groomer g ON a.id_groomer = g.id_groomer
    WHERE (p_id_sucursal IS NULL OR a.id_sucursal = p_id_sucursal)
      AND a.estado IN ('en_espera', 'en_servicio', 'pausado')
    ORDER BY 
        a.prioridad DESC,
        a.turno_num ASC,
        a.created_at ASC;
END//

-- ============================================================
-- 2. STORED PROCEDURES PARA CITAS
-- ============================================================

-- Crear nueva cita
DROP PROCEDURE IF EXISTS sp_CrearCita//
CREATE PROCEDURE sp_CrearCita(
    IN p_id_mascota INT,
    IN p_id_cliente INT,
    IN p_id_sucursal INT,
    IN p_id_servicio INT,
    IN p_fecha_programada DATETIME,
    IN p_modalidad ENUM('presencial','virtual'),
    IN p_notas TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO cita (
        id_mascota, 
        id_cliente, 
        id_sucursal, 
        id_servicio, 
        fecha_programada, 
        modalidad, 
        estado, 
        notas
    ) VALUES (
        p_id_mascota, 
        p_id_cliente, 
        NULLIF(p_id_sucursal, 0), 
        NULLIF(p_id_servicio, 0), 
        p_fecha_programada, 
        COALESCE(p_modalidad, 'presencial'), 
        'reservada', 
        p_notas
    );
    
    COMMIT;
END//

-- Reprogramar cita existente
DROP PROCEDURE IF EXISTS sp_ReprogramarCita//
CREATE PROCEDURE sp_ReprogramarCita(
    IN p_id_cita INT,
    IN p_nueva_fecha DATETIME
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE cita 
    SET fecha_programada = p_nueva_fecha,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_cita = p_id_cita;
    
    COMMIT;
END//

-- Cancelar cita
DROP PROCEDURE IF EXISTS sp_CancelarCita//
CREATE PROCEDURE sp_CancelarCita(
    IN p_id_cita INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE cita 
    SET estado = 'cancelada',
        updated_at = CURRENT_TIMESTAMP
    WHERE id_cita = p_id_cita;
    
    COMMIT;
END//

-- Confirmar asistencia a cita
DROP PROCEDURE IF EXISTS sp_ConfirmarAsistenciaCita//
CREATE PROCEDURE sp_ConfirmarAsistenciaCita(
    IN p_id_cita INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE cita 
    SET estado = 'asistio',
        updated_at = CURRENT_TIMESTAMP
    WHERE id_cita = p_id_cita;
    
    COMMIT;
END//

-- Obtener próximas citas de un cliente específico
DROP PROCEDURE IF EXISTS sp_ObtenerProximasCitas//
CREATE PROCEDURE sp_ObtenerProximasCitas(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        c.id_cita,
        c.fecha_programada,
        COALESCE(m.nombre, 'Sin mascota') as mascota,
        COALESCE(s.nombre, 'Sin servicio') as servicio,
        c.estado,
        c.modalidad,
        c.notas
    FROM cita c
    LEFT JOIN mascota m ON c.id_mascota = m.id_mascota
    LEFT JOIN servicio s ON c.id_servicio = s.id_servicio
    WHERE c.id_cliente = p_id_cliente
      AND c.estado IN ('reservada', 'confirmada')
      AND c.fecha_programada >= CURDATE()
    ORDER BY c.fecha_programada ASC;
END//

-- Crear atención desde cita existente
DROP PROCEDURE IF EXISTS sp_CrearAtencionDesdeCita//
CREATE PROCEDURE sp_CrearAtencionDesdeCita(
    IN p_id_cita INT,
    IN p_id_groomer INT,
    IN p_id_sucursal INT,
    IN p_turno_num INT,
    IN p_tiempo_estimado_inicio DATETIME,
    IN p_tiempo_estimado_fin DATETIME,
    IN p_prioridad TINYINT
)
BEGIN
    DECLARE v_id_mascota INT;
    DECLARE v_id_cliente INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Obtener datos de la cita
    SELECT id_mascota, id_cliente 
    INTO v_id_mascota, v_id_cliente
    FROM cita 
    WHERE id_cita = p_id_cita;
    
    -- Crear la atención
    INSERT INTO atencion (
        id_cita,
        id_mascota, 
        id_cliente, 
        id_groomer, 
        id_sucursal, 
        estado, 
        turno_num, 
        tiempo_estimado_inicio,
        tiempo_estimado_fin, 
        prioridad
    ) VALUES (
        p_id_cita,
        v_id_mascota, 
        v_id_cliente, 
        p_id_groomer, 
        NULLIF(p_id_sucursal, 0), 
        'en_espera', 
        NULLIF(p_turno_num, 0),
        p_tiempo_estimado_inicio, 
        p_tiempo_estimado_fin, 
        NULLIF(p_prioridad, 0)
    );
    
    -- Actualizar estado de la cita
    UPDATE cita 
    SET estado = 'confirmada'
    WHERE id_cita = p_id_cita;
    
    COMMIT;
END//

-- ============================================================
-- 3. STORED PROCEDURES PARA CLIENTES
-- ============================================================

-- Insertar nuevo cliente
DROP PROCEDURE IF EXISTS sp_InsertarCliente//
CREATE PROCEDURE sp_InsertarCliente(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_dni_ruc VARCHAR(20),
    IN p_email VARCHAR(120),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(200),
    IN p_preferencias JSON
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO cliente (
        nombre, apellido, dni_ruc, email, telefono, direccion, preferencias
    ) VALUES (
        p_nombre, p_apellido, p_dni_ruc, p_email, p_telefono, p_direccion, p_preferencias
    );
    
    COMMIT;
END//

-- Actualizar cliente existente
DROP PROCEDURE IF EXISTS sp_ActualizarCliente//
CREATE PROCEDURE sp_ActualizarCliente(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_dni_ruc VARCHAR(20),
    IN p_email VARCHAR(120),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(200),
    IN p_preferencias JSON
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE cliente 
    SET nombre = p_nombre,
        apellido = p_apellido,
        dni_ruc = p_dni_ruc,
        email = p_email,
        telefono = p_telefono,
        direccion = p_direccion,
        preferencias = p_preferencias,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_cliente = p_id_cliente;
    
    COMMIT;
END//

-- Obtener clientes frecuentes
DROP PROCEDURE IF EXISTS sp_ObtenerClientesFrecuentes//
CREATE PROCEDURE sp_ObtenerClientesFrecuentes(
    IN p_limite INT
)
BEGIN
    SELECT 
        c.id_cliente,
        c.nombre,
        c.apellido,
        c.email,
        c.telefono,
        COUNT(cita.id_cita) as total_citas,
        MAX(cita.fecha_programada) as ultima_cita
    FROM cliente c
    LEFT JOIN cita ON c.id_cliente = cita.id_cliente
    GROUP BY c.id_cliente, c.nombre, c.apellido, c.email, c.telefono
    HAVING total_citas > 0
    ORDER BY total_citas DESC, ultima_cita DESC
    LIMIT COALESCE(p_limite, 50);
END//

-- ============================================================
-- 4. STORED PROCEDURES PARA MASCOTAS
-- ============================================================

-- Insertar nueva mascota
DROP PROCEDURE IF EXISTS sp_InsertarMascota//
CREATE PROCEDURE sp_InsertarMascota(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(100),
    IN p_especie ENUM('perro','gato','otro'),
    IN p_raza VARCHAR(100),
    IN p_sexo ENUM('macho','hembra','otro'),
    IN p_fecha_nacimiento DATE,
    IN p_microchip VARCHAR(50),
    IN p_observaciones TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO mascota (
        id_cliente, nombre, especie, raza, sexo, fecha_nacimiento, microchip, observaciones
    ) VALUES (
        p_id_cliente, p_nombre, p_especie, p_raza, p_sexo, p_fecha_nacimiento, p_microchip, p_observaciones
    );
    
    COMMIT;
END//

-- Obtener mascotas por cliente
DROP PROCEDURE IF EXISTS sp_ObtenerMascotasPorCliente//
CREATE PROCEDURE sp_ObtenerMascotasPorCliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        m.id_mascota,
        m.nombre,
        m.especie,
        m.raza,
        m.sexo,
        m.fecha_nacimiento,
        m.microchip,
        m.observaciones,
        CONCAT(c.nombre, ' ', c.apellido) as propietario
    FROM mascota m
    INNER JOIN cliente c ON m.id_cliente = c.id_cliente
    WHERE m.id_cliente = p_id_cliente
    ORDER BY m.nombre ASC;
END//

-- Obtener historial médico de mascota
DROP PROCEDURE IF EXISTS sp_ObtenerHistorialMascota//
CREATE PROCEDURE sp_ObtenerHistorialMascota(
    IN p_id_mascota INT
)
BEGIN
    SELECT 
        a.id_atencion,
        a.estado,
        a.tiempo_real_inicio,
        a.tiempo_real_fin,
        a.observaciones,
        COALESCE(g.nombre, 'No asignado') as groomer,
        GROUP_CONCAT(s.nombre SEPARATOR ', ') as servicios
    FROM atencion a
    LEFT JOIN groomer g ON a.id_groomer = g.id_groomer
    LEFT JOIN detalle_servicio ds ON a.id_atencion = ds.id_atencion
    LEFT JOIN servicio s ON ds.id_servicio = s.id_servicio
    WHERE a.id_mascota = p_id_mascota
    GROUP BY a.id_atencion, a.estado, a.tiempo_real_inicio, a.tiempo_real_fin, a.observaciones, g.nombre
    ORDER BY a.created_at DESC;
END//

-- ============================================================
-- 5. STORED PROCEDURES PARA SERVICIOS
-- ============================================================

-- Insertar nuevo servicio
DROP PROCEDURE IF EXISTS sp_InsertarServicio//
CREATE PROCEDURE sp_InsertarServicio(
    IN p_codigo VARCHAR(20),
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_duracion_estimada_min INT,
    IN p_precio_base DECIMAL(10,2),
    IN p_categoria ENUM('baño','corte','dental','paquete','otro')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO servicio (
        codigo, nombre, descripcion, duracion_estimada_min, precio_base, categoria
    ) VALUES (
        p_codigo, p_nombre, p_descripcion, p_duracion_estimada_min, p_precio_base, p_categoria
    );
    
    COMMIT;
END//

-- Obtener servicios más solicitados
DROP PROCEDURE IF EXISTS sp_ObtenerServiciosMasSolicitados//
CREATE PROCEDURE sp_ObtenerServiciosMasSolicitados(
    IN p_limite INT
)
BEGIN
    SELECT 
        s.id_servicio,
        s.codigo,
        s.nombre,
        s.categoria,
        s.precio_base,
        COUNT(ds.id_detalle) as total_solicitado
    FROM servicio s
    LEFT JOIN detalle_servicio ds ON s.id_servicio = ds.id_servicio
    GROUP BY s.id_servicio, s.codigo, s.nombre, s.categoria, s.precio_base
    HAVING total_solicitado > 0
    ORDER BY total_solicitado DESC
    LIMIT COALESCE(p_limite, 10);
END//

-- Obtener servicios por categoría
DROP PROCEDURE IF EXISTS sp_ObtenerServiciosPorCategoria//
CREATE PROCEDURE sp_ObtenerServiciosPorCategoria(
    IN p_categoria ENUM('baño','corte','dental','paquete','otro')
)
BEGIN
    SELECT 
        s.id_servicio,
        s.codigo,
        s.nombre,
        s.descripcion,
        s.duracion_estimada_min,
        s.precio_base,
        s.categoria
    FROM servicio s
    WHERE (p_categoria IS NULL OR s.categoria = p_categoria)
    ORDER BY s.categoria ASC, s.nombre ASC;
END//

DELIMITER ;

-- Buscar clientes por término
DROP PROCEDURE IF EXISTS sp_BuscarClientes//
CREATE PROCEDURE sp_BuscarClientes(
    IN p_termino VARCHAR(255)
)
BEGIN
    SET p_termino = COALESCE(p_termino, '');
    
    SELECT 
        id_cliente,
        nombre,
        apellido,
        dni_ruc,
        email,
        telefono,
        direccion
    FROM cliente
    WHERE (p_termino = '' OR p_termino = '%')
       OR nombre LIKE CONCAT('%', p_termino, '%')
       OR apellido LIKE CONCAT('%', p_termino, '%')
       OR dni_ruc LIKE CONCAT('%', p_termino, '%')
       OR email LIKE CONCAT('%', p_termino, '%')
       OR telefono LIKE CONCAT('%', p_termino, '%')
    ORDER BY nombre ASC, apellido ASC;
END//

-- Obtener clientes frecuentes con estadísticas
DROP PROCEDURE IF EXISTS sp_ClientesFrecuentes//
CREATE PROCEDURE sp_ClientesFrecuentes()
BEGIN
    SELECT 
        c.id_cliente,
        c.nombre,
        c.apellido,
        c.email,
        c.telefono,
        COUNT(DISTINCT a.id_atencion) as total_atenciones,
        COUNT(DISTINCT m.id_mascota) as total_mascotas,
        COALESCE(SUM(f.total), 0) as total_gastado
    FROM cliente c
    LEFT JOIN mascota m ON c.id_cliente = m.id_cliente
    LEFT JOIN atencion a ON c.id_cliente = a.id_cliente
    LEFT JOIN factura f ON a.id_atencion = f.id_atencion AND f.estado = 'emitida'
    GROUP BY c.id_cliente, c.nombre, c.apellido, c.email, c.telefono
    HAVING total_atenciones > 0
    ORDER BY total_atenciones DESC, total_gastado DESC
    LIMIT 20;
END//

-- ============================================================
-- 6. STORED PROCEDURES PARA GROOMERS
-- ============================================================

-- Insertar nuevo groomer
DROP PROCEDURE IF EXISTS sp_InsertarGroomer//
CREATE PROCEDURE sp_InsertarGroomer(
    IN p_nombre VARCHAR(100),
    IN p_especialidades JSON,
    IN p_disponibilidad JSON
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO groomer (nombre, especialidades, disponibilidad) 
    VALUES (p_nombre, p_especialidades, p_disponibilidad);
    
    COMMIT;
END//

-- Obtener disponibilidad de groomers
DROP PROCEDURE IF EXISTS sp_ObtenerDisponibilidadGroomers//
CREATE PROCEDURE sp_ObtenerDisponibilidadGroomers()
BEGIN
    SELECT 
        g.id_groomer,
        g.nombre,
        g.especialidades,
        g.disponibilidad,
        COUNT(a.id_atencion) as atenciones_activas
    FROM groomer g
    LEFT JOIN atencion a ON g.id_groomer = a.id_groomer 
        AND a.estado IN ('en_espera', 'en_servicio')
    GROUP BY g.id_groomer, g.nombre, g.especialidades, g.disponibilidad
    ORDER BY atenciones_activas ASC, g.nombre ASC;
END//

-- Obtener ocupación actual de groomers
DROP PROCEDURE IF EXISTS sp_ObtenerOcupacionGroomers//
CREATE PROCEDURE sp_ObtenerOcupacionGroomers()
BEGIN
    SELECT 
        g.id_groomer,
        g.nombre,
        COUNT(CASE WHEN a.estado = 'en_servicio' THEN 1 END) as en_servicio,
        COUNT(CASE WHEN a.estado = 'en_espera' THEN 1 END) as en_espera,
        COUNT(a.id_atencion) as total_activas,
        CASE 
            WHEN COUNT(CASE WHEN a.estado = 'en_servicio' THEN 1 END) = 0 THEN 'Disponible'
            WHEN COUNT(CASE WHEN a.estado = 'en_servicio' THEN 1 END) = 1 THEN 'Ocupado'
            ELSE 'Muy Ocupado'
        END as estado_ocupacion
    FROM groomer g
    LEFT JOIN atencion a ON g.id_groomer = a.id_groomer 
        AND a.estado IN ('en_espera', 'en_servicio')
    GROUP BY g.id_groomer, g.nombre
    ORDER BY total_activas ASC, g.nombre ASC;
END//

-- Obtener tiempos promedio de groomers
DROP PROCEDURE IF EXISTS sp_ObtenerTiemposPromedioGroomers//
CREATE PROCEDURE sp_ObtenerTiemposPromedioGroomers()
BEGIN
    SELECT 
        g.id_groomer,
        g.nombre,
        COUNT(a.id_atencion) as total_atenciones,
        AVG(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_promedio_min,
        MIN(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_minimo_min,
        MAX(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_maximo_min
    FROM groomer g
    LEFT JOIN atencion a ON g.id_groomer = a.id_groomer 
        AND a.estado = 'terminado'
        AND a.tiempo_real_inicio IS NOT NULL 
        AND a.tiempo_real_fin IS NOT NULL
    GROUP BY g.id_groomer, g.nombre
    HAVING total_atenciones > 0
    ORDER BY tiempo_promedio_min ASC, g.nombre ASC;
END//

-- Tiempos promedio por rango de fechas
DROP PROCEDURE IF EXISTS sp_TiemposPromedioGroomer//
CREATE PROCEDURE sp_TiemposPromedioGroomer(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
        g.nombre,
        COUNT(DISTINCT a.id_atencion) as total_atenciones,
        AVG(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_promedio_minutos,
        MIN(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_minimo,
        MAX(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_maximo
    FROM groomer g
    LEFT JOIN atencion a ON g.id_groomer = a.id_groomer 
        AND a.estado = 'terminado'
        AND a.tiempo_real_inicio IS NOT NULL 
        AND a.tiempo_real_fin IS NOT NULL
        AND DATE(a.created_at) BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY g.id_groomer, g.nombre
    HAVING total_atenciones > 0
    ORDER BY tiempo_promedio_minutos ASC;
END//

-- Ocupación de groomer por fecha específica
DROP PROCEDURE IF EXISTS sp_OcupacionGroomer//
CREATE PROCEDURE sp_OcupacionGroomer(
    IN p_fecha DATE
)
BEGIN
    SELECT 
        g.nombre,
        COUNT(DISTINCT a.id_atencion) as atenciones_realizadas,
        SUM(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as minutos_trabajados,
        ROUND((SUM(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) / 480) * 100, 2) as porcentaje_ocupacion
    FROM groomer g
    LEFT JOIN atencion a ON g.id_groomer = a.id_groomer 
        AND a.estado = 'terminado'
        AND DATE(a.created_at) = p_fecha
        AND a.tiempo_real_inicio IS NOT NULL 
        AND a.tiempo_real_fin IS NOT NULL
    GROUP BY g.id_groomer, g.nombre
    ORDER BY porcentaje_ocupacion DESC;
END//

-- Actualizar groomer existente
DROP PROCEDURE IF EXISTS sp_ActualizarGroomer//
CREATE PROCEDURE sp_ActualizarGroomer(
    IN p_id_groomer INT,
    IN p_nombre VARCHAR(100),
    IN p_especialidades JSON,
    IN p_disponibilidad JSON
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE groomer 
    SET nombre = p_nombre,
        especialidades = p_especialidades,
        disponibilidad = p_disponibilidad,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_groomer = p_id_groomer;
    
    COMMIT;
END//

-- Obtener todos los groomers
DROP PROCEDURE IF EXISTS sp_ObtenerGroomers//
CREATE PROCEDURE sp_ObtenerGroomers()
BEGIN
    SELECT 
        id_groomer,
        nombre,
        especialidades,
        disponibilidad,
        created_at,
        updated_at
    FROM groomer
    ORDER BY nombre ASC;
END//

-- ============================================================
-- 7. STORED PROCEDURES PARA FACTURAS Y PAGOS
-- ============================================================

-- Crear factura
DROP PROCEDURE IF EXISTS sp_CrearFactura//
CREATE PROCEDURE sp_CrearFactura(
    IN p_serie VARCHAR(10),
    IN p_numero VARCHAR(20),
    IN p_id_cliente INT,
    IN p_id_atencion INT,
    IN p_subtotal DECIMAL(10,2),
    IN p_impuesto DECIMAL(10,2),
    IN p_descuento_total DECIMAL(10,2),
    IN p_total DECIMAL(10,2),
    IN p_metodo_pago_sugerido ENUM('efectivo','tarjeta','transfer','otro')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO factura (
        serie, numero, id_cliente, id_atencion, subtotal, impuesto, 
        descuento_total, total, metodo_pago_sugerido
    ) VALUES (
        p_serie, p_numero, p_id_cliente, p_id_atencion, p_subtotal, 
        p_impuesto, p_descuento_total, p_total, p_metodo_pago_sugerido
    );
    
    COMMIT;
END//

-- Buscar facturas
DROP PROCEDURE IF EXISTS sp_BuscarFacturas//
CREATE PROCEDURE sp_BuscarFacturas(
    IN p_termino VARCHAR(255)
)
BEGIN
    SELECT 
        f.id_factura,
        CONCAT(COALESCE(f.serie, ''), '-', COALESCE(f.numero, '')) as numero_factura,
        CONCAT(c.nombre, ' ', c.apellido) as cliente,
        f.fecha_emision,
        f.total,
        f.estado,
        f.metodo_pago_sugerido
    FROM factura f
    INNER JOIN cliente c ON f.id_cliente = c.id_cliente
    WHERE (p_termino IS NULL OR p_termino = '')
       OR f.serie LIKE CONCAT('%', p_termino, '%')
       OR f.numero LIKE CONCAT('%', p_termino, '%')
       OR c.nombre LIKE CONCAT('%', p_termino, '%')
       OR c.apellido LIKE CONCAT('%', p_termino, '%')
       OR c.dni_ruc LIKE CONCAT('%', p_termino, '%')
    ORDER BY f.fecha_emision DESC;
END//

-- Obtener facturas por cliente
DROP PROCEDURE IF EXISTS sp_ObtenerFacturasPorCliente//
CREATE PROCEDURE sp_ObtenerFacturasPorCliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        f.id_factura,
        CONCAT(COALESCE(f.serie, ''), '-', COALESCE(f.numero, '')) as numero_factura,
        f.fecha_emision,
        f.subtotal,
        f.impuesto,
        f.descuento_total,
        f.total,
        f.estado,
        f.metodo_pago_sugerido,
        COALESCE(SUM(p.monto), 0) as total_pagado,
        (f.total - COALESCE(SUM(p.monto), 0)) as saldo_pendiente
    FROM factura f
    LEFT JOIN pago p ON f.id_factura = p.id_factura AND p.estado = 'confirmado'
    WHERE f.id_cliente = p_id_cliente
    GROUP BY f.id_factura, f.serie, f.numero, f.fecha_emision, f.subtotal, 
             f.impuesto, f.descuento_total, f.total, f.estado, f.metodo_pago_sugerido
    ORDER BY f.fecha_emision DESC;
END//

-- Registrar pago
DROP PROCEDURE IF EXISTS sp_RegistrarPago//
CREATE PROCEDURE sp_RegistrarPago(
    IN p_id_factura INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo ENUM('efectivo','tarjeta','transfer','otro'),
    IN p_referencia VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO pago (id_factura, monto, metodo, referencia, estado) 
    VALUES (p_id_factura, p_monto, p_metodo, p_referencia, 'confirmado');
    
    COMMIT;
END//

-- ============================================================
-- 8. STORED PROCEDURES PARA DETALLES DE SERVICIO
-- ============================================================

-- Crear detalle de servicio
DROP PROCEDURE IF EXISTS sp_CrearDetalleServicio//
CREATE PROCEDURE sp_CrearDetalleServicio(
    IN p_id_atencion INT,
    IN p_id_servicio INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_descuento_id INT,
    IN p_observaciones TEXT
)
BEGIN
    DECLARE v_subtotal DECIMAL(10,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Calcular subtotal
    SET v_subtotal = p_cantidad * p_precio_unitario;
    
    INSERT INTO detalle_servicio (
        id_atencion, id_servicio, cantidad, precio_unitario, 
        descuento_id, subtotal, observaciones
    ) VALUES (
        p_id_atencion, p_id_servicio, p_cantidad, p_precio_unitario,
        NULLIF(p_descuento_id, 0), v_subtotal, p_observaciones
    );
    
    COMMIT;
END//

-- Obtener detalles de servicios por atención
DROP PROCEDURE IF EXISTS sp_ObtenerDetallesServiciosPorAtencion//
CREATE PROCEDURE sp_ObtenerDetallesServiciosPorAtencion(
    IN p_id_atencion INT
)
BEGIN
    SELECT 
        ds.id_detalle,
        ds.id_atencion,
        s.codigo as codigo_servicio,
        s.nombre as nombre_servicio,
        ds.cantidad,
        ds.precio_unitario,
        ds.subtotal,
        ds.observaciones
    FROM detalle_servicio ds
    INNER JOIN servicio s ON ds.id_servicio = s.id_servicio
    WHERE ds.id_atencion = p_id_atencion
    ORDER BY ds.id_detalle ASC;
END//

-- ============================================================
-- 9. STORED PROCEDURES PARA REPORTES Y DASHBOARD
-- ============================================================

-- Obtener estadísticas mensuales
DROP PROCEDURE IF EXISTS sp_ObtenerEstadisticasMensuales//
CREATE PROCEDURE sp_ObtenerEstadisticasMensuales(
    IN p_año INT,
    IN p_mes INT
)
BEGIN
    SELECT 
        COUNT(DISTINCT a.id_atencion) as total_atenciones,
        COUNT(DISTINCT c.id_cita) as total_citas,
        COUNT(DISTINCT f.id_factura) as total_facturas,
        COALESCE(SUM(f.total), 0) as ingresos_totales,
        COUNT(DISTINCT cl.id_cliente) as clientes_atendidos,
        AVG(TIMESTAMPDIFF(MINUTE, a.tiempo_real_inicio, a.tiempo_real_fin)) as tiempo_promedio_atencion
    FROM atencion a
    LEFT JOIN cita c ON a.id_cita = c.id_cita
    LEFT JOIN factura f ON a.id_atencion = f.id_atencion AND f.estado = 'emitida'
    LEFT JOIN cliente cl ON a.id_cliente = cl.id_cliente
    WHERE YEAR(a.created_at) = p_año 
      AND MONTH(a.created_at) = p_mes;
END//

-- Obtener reporte de ingresos
DROP PROCEDURE IF EXISTS sp_ObtenerReporteIngresos//
CREATE PROCEDURE sp_ObtenerReporteIngresos(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
        DATE(f.fecha_emision) as fecha,
        COUNT(f.id_factura) as total_facturas,
        SUM(f.subtotal) as subtotal,
        SUM(f.impuesto) as impuesto,
        SUM(f.descuento_total) as descuentos,
        SUM(f.total) as total_bruto,
        SUM(COALESCE(p.monto, 0)) as total_cobrado,
        (SUM(f.total) - SUM(COALESCE(p.monto, 0))) as pendiente_cobro
    FROM factura f
    LEFT JOIN pago p ON f.id_factura = p.id_factura AND p.estado = 'confirmado'
    WHERE DATE(f.fecha_emision) BETWEEN p_fecha_inicio AND p_fecha_fin
      AND f.estado = 'emitida'
    GROUP BY DATE(f.fecha_emision)
    ORDER BY DATE(f.fecha_emision) DESC;
END//

-- ============================================================
-- 10. DATOS DE PRUEBA INICIALES
-- ============================================================

-- Insertar datos de prueba solo si las tablas están vacías
INSERT IGNORE INTO cliente (id_cliente, nombre, apellido, dni_ruc, email, telefono, direccion) VALUES
(1, 'Juan', 'Pérez', '12345678', 'juan.perez@email.com', '555-0001', 'Av. Principal 123'),
(2, 'María', 'González', '87654321', 'maria.gonzalez@email.com', '555-0002', 'Calle Secundaria 456'),
(3, 'Carlos', 'López', '11223344', 'carlos.lopez@email.com', '555-0003', 'Jr. Tercera 789');

INSERT IGNORE INTO mascota (id_mascota, id_cliente, nombre, especie, raza, sexo, fecha_nacimiento) VALUES
(1, 1, 'Max', 'perro', 'Golden Retriever', 'macho', '2020-05-15'),
(2, 1, 'Luna', 'gato', 'Persa', 'hembra', '2021-03-10'),
(3, 2, 'Rocky', 'perro', 'Bulldog', 'macho', '2019-08-20'),
(4, 3, 'Mimi', 'gato', 'Siamés', 'hembra', '2022-01-05');

INSERT IGNORE INTO groomer (id_groomer, nombre, especialidades, disponibilidad) VALUES
(1, 'Ana Martínez', '["corte", "baño", "dental"]', '{"lunes": true, "martes": true, "miercoles": true, "jueves": true, "viernes": true}'),
(2, 'Luis García', '["baño", "paquete"]', '{"lunes": true, "martes": false, "miercoles": true, "jueves": true, "viernes": true}'),
(3, 'Carmen Rodríguez', '["corte", "dental"]', '{"lunes": false, "martes": true, "miercoles": true, "jueves": false, "viernes": true}');

INSERT IGNORE INTO servicio (id_servicio, codigo, nombre, descripcion, duracion_estimada_min, precio_base, categoria) VALUES
(1, 'BAÑO001', 'Baño Completo', 'Baño con champú especial y secado', 60, 25.00, 'baño'),
(2, 'CORTE001', 'Corte Estético', 'Corte de pelo según raza', 45, 30.00, 'corte'),
(3, 'DENTAL001', 'Limpieza Dental', 'Limpieza dental básica', 30, 40.00, 'dental'),
(4, 'PAQ001', 'Paquete Completo', 'Baño + Corte + Limpieza dental', 120, 80.00, 'paquete');

INSERT IGNORE INTO sucursal (id_sucursal, nombre, direccion, telefono) VALUES
(1, 'Sucursal Centro', 'Av. Central 100', '555-1000'),
(2, 'Sucursal Norte', 'Av. Norte 200', '555-2000'),
(3, 'Sucursal Sur', 'Av. Sur 300', '555-3000');

-- ============================================================
-- 7. MENSAJE DE CONFIRMACIÓN
-- ============================================================

SELECT 'Stored Procedures creados exitosamente para Veterinaria Terán Vet' as Mensaje;
SELECT 'Sistema compatible con Java 8 (1.8.0_202) y NetBeans 8.2' as Compatibilidad;
SELECT 'Usar com.mysql.jdbc.Driver para conexiones' as Driver_Recomendado;