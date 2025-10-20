-- ============================================================
-- BASE DE DATOS: Veterinaria Terán Vet - Gestión Grooming
-- Motor: MySQL 8.x
-- Autor: Diego, Juanpablo y Melanie
-- ============================================================

DROP DATABASE IF EXISTS vet_teran;
CREATE DATABASE vet_teran CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vet_teran;

-- =========================
-- 1. ENTIDADES PRINCIPALES
-- =========================

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni_ruc VARCHAR(20) UNIQUE,
    email VARCHAR(120),
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    preferencias JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE mascota (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    especie ENUM('perro','gato','otro') NOT NULL,
    raza VARCHAR(100),
    sexo ENUM('macho','hembra','otro'),
    fecha_nacimiento DATE,
    microchip VARCHAR(50) UNIQUE,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_mascota_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE groomer (
    id_groomer INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidades JSON,
    disponibilidad JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion_estimada_min INT NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    categoria ENUM('baño','corte','dental','paquete','otro') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE paquete_servicio (
    id_paquete INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE paquete_servicio_item (
    id_paquete INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_paquete, id_servicio),
    CONSTRAINT fk_item_paquete FOREIGN KEY (id_paquete) REFERENCES paquete_servicio(id_paquete),
    CONSTRAINT fk_item_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

-- =========================
-- 2. CITAS, ATENCIONES Y COLA
-- =========================

CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    id_cliente INT NOT NULL,
    id_sucursal INT NULL,
    id_servicio INT NULL,
    fecha_programada DATETIME NOT NULL,
    modalidad ENUM('presencial','virtual') DEFAULT 'presencial',
    estado ENUM('reservada','confirmada','cancelada','asistio','no_show') DEFAULT 'reservada',
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cita_mascota FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
    CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_cita_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

CREATE TABLE atencion (
    id_atencion INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT NULL,
    id_mascota INT NOT NULL,
    id_cliente INT NOT NULL,
    id_groomer INT NULL,
    id_sucursal INT NULL,
    estado ENUM('en_espera','en_servicio','pausado','terminado') DEFAULT 'en_espera',
    turno_num INT,
    tiempo_estimado_inicio DATETIME,
    tiempo_estimado_fin DATETIME,
    tiempo_real_inicio DATETIME,
    tiempo_real_fin DATETIME,
    prioridad TINYINT DEFAULT 0,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_atencion_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita),
    CONSTRAINT fk_atencion_mascota FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
    CONSTRAINT fk_atencion_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_atencion_groomer FOREIGN KEY (id_groomer) REFERENCES groomer(id_groomer)
);

CREATE TABLE detalle_servicio (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_atencion INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_id INT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_detalle_atencion FOREIGN KEY (id_atencion) REFERENCES atencion(id_atencion),
    CONSTRAINT fk_detalle_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

-- =========================
-- 3. FACTURACIÓN Y PAGOS
-- =========================

CREATE TABLE factura (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    serie VARCHAR(10),
    numero VARCHAR(20),
    id_cliente INT NOT NULL,
    id_atencion INT NOT NULL,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL,
    impuesto DECIMAL(10,2),
    descuento_total DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('emitida','anulada') DEFAULT 'emitida',
    metodo_pago_sugerido ENUM('efectivo','tarjeta','transfer','otro'),
    CONSTRAINT fk_factura_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_factura_atencion FOREIGN KEY (id_atencion) REFERENCES atencion(id_atencion)
);

CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto DECIMAL(10,2) NOT NULL,
    metodo ENUM('efectivo','tarjeta','transfer','otro'),
    referencia VARCHAR(100),
    estado ENUM('pendiente','confirmado','fallido') DEFAULT 'confirmado',
    CONSTRAINT fk_pago_factura FOREIGN KEY (id_factura) REFERENCES factura(id_factura)
);

-- =========================
-- 4. AUDITORÍA Y SOPORTE
-- =========================

CREATE TABLE usuario_sistema (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    rol ENUM('recepcionista','admin','groomer','contador','veterinario'),
    email VARCHAR(120) UNIQUE,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE audit_log (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    entidad VARCHAR(50),
    entidad_id INT,
    accion ENUM('INSERT','UPDATE','DELETE'),
    id_usuario INT,
    antes JSON,
    despues JSON,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_usuario FOREIGN KEY (id_usuario) REFERENCES usuario_sistema(id_usuario)
);

CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('sms','email','push'),
    destinatario_id INT NOT NULL,
    canal ENUM('cliente','usuario'),
    contenido TEXT,
    enviado_at DATETIME,
    estado ENUM('pendiente','enviado','fallido') DEFAULT 'pendiente',
    referencia_tipo VARCHAR(50),
    referencia_id INT
);

CREATE TABLE sucursal (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE promocion (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    tipo ENUM('porcentaje','monto'),
    valor DECIMAL(10,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado ENUM('activa','inactiva') DEFAULT 'activa'
);

-- =========================
-- 5. CONFIGURACIÓN ESTIMACIONES
-- =========================

CREATE TABLE configuracion_estimacion (
    id_config INT AUTO_INCREMENT PRIMARY KEY,
    id_servicio INT,
    id_groomer INT,
    tiempo_estimado_min INT,
    CONSTRAINT fk_conf_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio),
    CONSTRAINT fk_conf_groomer FOREIGN KEY (id_groomer) REFERENCES groomer(id_groomer)
);
