-- ============================================================================
-- SCHEMA DE BASE DE DATOS - MÓDULO ACADEMIA (PostgreSQL)
-- ============================================================================
-- Descripción : Definición de tablas para el Centro de Conocimiento (Academia)
-- Proyecto    : Gestión RRHH
-- Requerimiento: 677705
-- Base de Datos: academia
-- ============================================================================
--
-- NOTAS DE MIGRACIÓN (MySQL -> PostgreSQL):
--
-- 1) PostgreSQL no soporta "CREATE DATABASE IF NOT EXISTS" ni puede crear una
--    base de datos dentro de la misma transacción/script que luego la usa.
--    Debes crear la base de datos primero (una sola vez, conectado a otra BD,
--    p.ej. "postgres"), y luego conectarte a ella para correr el resto del
--    script. Por eso el CREATE DATABASE queda comentado más abajo.
--
-- 2) "USE academia;" (MySQL) se reemplaza por el meta-comando de psql
--    "\c academia" para cambiar de base de datos.
--
-- 3) "INT AUTO_INCREMENT" se reemplaza por "INT GENERATED ALWAYS AS IDENTITY"
--    (equivalente moderno recomendado por PostgreSQL, en vez de SERIAL).
--
-- 4) "DATETIME" se reemplaza por "TIMESTAMP".
--
-- 5) PostgreSQL no soporta "ON UPDATE CURRENT_TIMESTAMP" en la definición de
--    columna. Se replica ese comportamiento con una función de trigger
--    (set_fecha_modificacion) aplicada a las tablas que tienen la columna
--    fecha_modificacion (categoria y articulo).
--
-- El resto de la estructura (tablas, columnas, constraints, índices,
-- relaciones) se mantiene igual.
-- ============================================================================

-- CREATE DATABASE academia;
-- \c academia

-- ============================================================================
-- FUNCIÓN Y TRIGGERS: actualización automática de fecha_modificacion
-- Equivalente a "ON UPDATE CURRENT_TIMESTAMP" de MySQL.
-- ============================================================================

CREATE OR REPLACE FUNCTION set_fecha_modificacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_modificacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TABLA: categoria
-- Descripción: Almacena las categorías y subcategorías del módulo Academia.
-- ============================================================================

CREATE TABLE IF NOT EXISTS categoria (

    id_categoria INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(255) NOT NULL,

    descripcion VARCHAR(255),

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    categoria_padre INT NULL,

    id_usuario_creador VARCHAR(255),

    id_usuario_modificador VARCHAR(255),

    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_categoria_padre
        FOREIGN KEY (categoria_padre)
        REFERENCES categoria(id_categoria),

    CONSTRAINT categoria_nombre_check
        CHECK (nombre <> ''),

    CONSTRAINT categoria_nombre_unique
        UNIQUE(nombre),

    CONSTRAINT categoria_padre_check
        CHECK (categoria_padre IS NULL OR categoria_padre <> id_categoria)

);

CREATE TRIGGER trg_categoria_fecha_modificacion
BEFORE UPDATE ON categoria
FOR EACH ROW
EXECUTE FUNCTION set_fecha_modificacion();

CREATE INDEX idx_categoria_nombre
ON categoria(nombre);

CREATE INDEX idx_categoria_activo
ON categoria(activo);

CREATE INDEX idx_categoria_padre
ON categoria(categoria_padre);

CREATE INDEX idx_categoria_usuario_creador
ON categoria(id_usuario_creador);

CREATE INDEX idx_categoria_usuario_modificador
ON categoria(id_usuario_modificador);

CREATE INDEX idx_categoria_fecha_creacion
ON categoria(fecha_creacion);

CREATE INDEX idx_categoria_fecha_modificacion
ON categoria(fecha_modificacion);

-- ============================================================================
-- TABLA: estado
-- Descripción: Catálogo de estados funcionales del artículo.
-- ============================================================================

CREATE TABLE IF NOT EXISTS estado (

    id_estado INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(255) NOT NULL,

    CONSTRAINT estado_nombre_check
        CHECK(nombre <> ''),

    CONSTRAINT estado_nombre_unique
        UNIQUE(nombre)

);

CREATE INDEX idx_estado_nombre
ON estado(nombre);

-- ============================================================================
-- DATOS INICIALES TABLA ESTADO
-- ============================================================================

INSERT INTO estado(nombre)
VALUES
('Borrador'),
('En revisión'),
('Programado'),
('Publicado');

-- ============================================================================
-- TABLA: articulo
-- Descripción: Almacena la información principal de los artículos.
-- ============================================================================

CREATE TABLE IF NOT EXISTS articulo (

    id_articulo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    titulo VARCHAR(255) NOT NULL,

    resumen VARCHAR(255),

    contenido TEXT,

    id_estado INT NOT NULL,

    habilitado BOOLEAN NOT NULL DEFAULT TRUE,

    destacado BOOLEAN NOT NULL DEFAULT FALSE,

    id_categoria INT NOT NULL,

    id_usuario_creador VARCHAR(255),

    id_usuario_modificador VARCHAR(255),

    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_articulo_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    CONSTRAINT fk_articulo_estado
        FOREIGN KEY (id_estado)
        REFERENCES estado(id_estado),

    CONSTRAINT articulo_titulo_check
        CHECK (titulo <> '')

);

CREATE TRIGGER trg_articulo_fecha_modificacion
BEFORE UPDATE ON articulo
FOR EACH ROW
EXECUTE FUNCTION set_fecha_modificacion();

CREATE INDEX idx_articulo_titulo
ON articulo(titulo);

CREATE INDEX idx_articulo_categoria
ON articulo(id_categoria);

CREATE INDEX idx_articulo_estado
ON articulo(id_estado);

CREATE INDEX idx_articulo_habilitado
ON articulo(habilitado);

CREATE INDEX idx_articulo_destacado
ON articulo(destacado);

CREATE INDEX idx_articulo_usuario_creador
ON articulo(id_usuario_creador);

CREATE INDEX idx_articulo_usuario_modificador
ON articulo(id_usuario_modificador);

CREATE INDEX idx_articulo_fecha_creacion
ON articulo(fecha_creacion);

CREATE INDEX idx_articulo_fecha_modificacion
ON articulo(fecha_modificacion);

-- ============================================================================
-- TABLA: etiqueta
-- Descripción: Almacena las etiquetas asociadas a los artículos.
-- ============================================================================

CREATE TABLE IF NOT EXISTS etiqueta (

    id_etiqueta INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(255) NOT NULL,

    descripcion VARCHAR(255),

    CONSTRAINT etiqueta_nombre_check
        CHECK(nombre <> ''),

    CONSTRAINT etiqueta_nombre_unique
        UNIQUE(nombre)

);

CREATE INDEX idx_etiqueta_nombre
ON etiqueta(nombre);

-- ============================================================================
-- TABLA: articulo_etiqueta
-- Descripción: Relación muchos a muchos entre artículos y etiquetas.
-- ============================================================================

CREATE TABLE IF NOT EXISTS articulo_etiqueta (

    id_articulo INT NOT NULL,

    id_etiqueta INT NOT NULL,

    PRIMARY KEY (id_articulo, id_etiqueta),

    CONSTRAINT fk_articulo_etiqueta_articulo
        FOREIGN KEY (id_articulo)
        REFERENCES articulo(id_articulo)
        ON DELETE CASCADE,

    CONSTRAINT fk_articulo_etiqueta_etiqueta
        FOREIGN KEY (id_etiqueta)
        REFERENCES etiqueta(id_etiqueta)
        ON DELETE CASCADE

);

CREATE INDEX idx_articulo_etiqueta_articulo
ON articulo_etiqueta(id_articulo);

CREATE INDEX idx_articulo_etiqueta_etiqueta
ON articulo_etiqueta(id_etiqueta);

-- ============================================================================
-- TABLA: historial_version
-- Descripción: Registra el historial de versiones de cada artículo.
-- ============================================================================

CREATE TABLE IF NOT EXISTS historial_version (

    id_version INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_articulo INT NOT NULL,

    numero_version INT NOT NULL,

    id_usuario VARCHAR(255),

    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    descripcion_cambio VARCHAR(255),

    CONSTRAINT fk_historial_version_articulo
        FOREIGN KEY (id_articulo)
        REFERENCES articulo(id_articulo)
        ON DELETE CASCADE,

    CONSTRAINT historial_numero_version_check
        CHECK(numero_version > 0),

    CONSTRAINT historial_version_unique
        UNIQUE(id_articulo, numero_version)

);

CREATE INDEX idx_historial_version_articulo
ON historial_version(id_articulo);

CREATE INDEX idx_historial_version_usuario
ON historial_version(id_usuario);

CREATE INDEX idx_historial_version_fecha
ON historial_version(fecha_modificacion);

CREATE INDEX idx_historial_version_numero
ON historial_version(numero_version);

CREATE INDEX idx_historial_version_articulo_fecha
ON historial_version(id_articulo, fecha_modificacion);

-- ============================================================================
-- TABLA: comentario
-- Descripción: Almacena los comentarios realizados por los usuarios sobre los
--              artículos del módulo Academia.
-- ============================================================================

CREATE TABLE IF NOT EXISTS comentario (

    id_comentario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_articulo INT NOT NULL,

    id_usuario VARCHAR(255),

    comentario TEXT NOT NULL,

    fecha_comentario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_comentario_articulo
        FOREIGN KEY (id_articulo)
        REFERENCES articulo(id_articulo)
        ON DELETE CASCADE,

    CONSTRAINT comentario_texto_check
        CHECK(comentario <> '')

);

CREATE INDEX idx_comentario_articulo
ON comentario(id_articulo);

CREATE INDEX idx_comentario_usuario
ON comentario(id_usuario);

CREATE INDEX idx_comentario_fecha
ON comentario(fecha_comentario);

CREATE INDEX idx_comentario_activo
ON comentario(activo);

CREATE INDEX idx_comentario_usuario_fecha
ON comentario(id_usuario, fecha_comentario);

-- ============================================================================
-- RELACIONES DEL MODELO
-- ============================================================================
--
-- categoria (1) ------------ (N) articulo
--
-- categoria (1) ------------ (N) categoria
--           (Categoría Padre -> Subcategoría)
--
-- estado (1) --------------- (N) articulo
--
-- articulo (N) ------------ (N) etiqueta
--                 |
--                 |
--         articulo_etiqueta
--
-- articulo (1) ------------ (N) historial_version
--
-- articulo (1) ------------ (N) comentario
--
-- ============================================================================

-- ============================================================================
-- OBSERVACIONES
-- ============================================================================
--
-- • El sistema obtiene el id_usuario desde el servicio de autenticación
--   (OAuth / Identity Provider), por lo tanto no existe una tabla usuario
--   dentro de esta base de datos.
--
-- • La tabla estado almacena el flujo funcional del artículo:
--      - Borrador
--      - En revisión
--      - Programado
--      - Publicado
--
-- • El campo habilitado controla únicamente si el artículo puede visualizarse
--   en el módulo Academia (Activo / Inactivo).
--
-- • El campo destacado permite marcar artículos importantes para que puedan
--   mostrarse como contenido recomendado o destacado en la página principal.
--
-- • Cada modificación realizada sobre un artículo genera un nuevo registro
--   en historial_version, conservando la trazabilidad de los cambios.
--
-- • La combinación (id_articulo, numero_version) es única para garantizar
--   que un artículo no tenga dos versiones con el mismo número.
--
-- • Un artículo puede tener múltiples etiquetas y una etiqueta puede estar
--   asociada a múltiples artículos mediante la tabla articulo_etiqueta.
--
-- • Los comentarios pueden activarse o desactivarse sin eliminar su
--   información, conservando el historial de participación de los usuarios.
--
-- • Las subcategorías se administran mediante la relación recursiva de la
--   tabla categoria utilizando el campo categoria_padre.
--
-- • La actualización automática de fecha_modificacion (equivalente a
--   ON UPDATE CURRENT_TIMESTAMP en MySQL) se implementa mediante la función
--   set_fecha_modificacion() y triggers BEFORE UPDATE en categoria y
--   articulo.
--
-- ============================================================================

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================