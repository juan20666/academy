-- ============================================================================
-- SCHEMAS DE BASE DE DATOS - CANDIDATE SERVICE
-- ============================================================================
-- Descripción: Definición de todas las tablas necesarias para el microservicio
--              de gestión de candidatos y procesos de contratación
-- Fecha: 2026-05-20
-- Base de datos: ms_candidate
-- Schema: public
-- ============================================================================
 
SET SCHEMA 'public';
 
-- ============================================================================
-- TABLA: phase_type (Catálogo de Tipos de Fases)
-- ============================================================================
CREATE TABLE IF NOT EXISTS phase_type (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT phase_type_code_check CHECK (code != ''),
    CONSTRAINT phase_type_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_phase_type_code ON phase_type(code);
CREATE INDEX IF NOT EXISTS idx_phase_type_active ON phase_type(is_active);
 
-- ============================================================================
-- TABLA: phase_evaluation_mode (Catálogo de Modos de Evaluación)
-- ============================================================================
CREATE TABLE IF NOT EXISTS phase_evaluation_mode (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT phase_evaluation_mode_code_check CHECK (code != ''),
    CONSTRAINT phase_evaluation_mode_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_phase_evaluation_mode_code ON phase_evaluation_mode(code);
CREATE INDEX IF NOT EXISTS idx_phase_evaluation_mode_active ON phase_evaluation_mode(is_active);
 
-- ============================================================================
-- TABLA: phase_status (Catálogo de Estados de Fases)
-- ============================================================================
CREATE TABLE IF NOT EXISTS phase_status (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    color VARCHAR,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT phase_status_code_check CHECK (code != ''),
    CONSTRAINT phase_status_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_phase_status_code ON phase_status(code);
CREATE INDEX IF NOT EXISTS idx_phase_status_active ON phase_status(is_active);
 
-- ============================================================================
-- TABLA: candidate_status (Catálogo de Estados de Candidatos)
-- ============================================================================
CREATE TABLE IF NOT EXISTS candidate_status (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    color VARCHAR,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT candidate_status_code_check CHECK (code != ''),
    CONSTRAINT candidate_status_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_candidate_status_code ON candidate_status(code);
CREATE INDEX IF NOT EXISTS idx_candidate_status_active ON candidate_status(is_active);
 
-- ============================================================================
-- TABLA: evaluation_status (Catálogo de Estados de Evaluación)
-- ============================================================================
CREATE TABLE IF NOT EXISTS evaluation_status (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    color VARCHAR,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT evaluation_status_code_check CHECK (code != ''),
    CONSTRAINT evaluation_status_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_evaluation_status_code ON evaluation_status(code);
CREATE INDEX IF NOT EXISTS idx_evaluation_status_active ON evaluation_status(is_active);
 
-- ============================================================================
-- TABLA: assignment_source (Catálogo de Fuentes de Asignación)
-- ============================================================================
CREATE TABLE IF NOT EXISTS assignment_source (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT assignment_source_code_check CHECK (code != ''),
    CONSTRAINT assignment_source_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_assignment_source_code ON assignment_source(code);
CREATE INDEX IF NOT EXISTS idx_assignment_source_active ON assignment_source(is_active);
 
-- ============================================================================
-- TABLA: evaluation_decision (Catálogo de Decisiones de Evaluación)
-- ============================================================================
CREATE TABLE IF NOT EXISTS evaluation_decision (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT evaluation_decision_code_check CHECK (code != ''),
    CONSTRAINT evaluation_decision_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_evaluation_decision_code ON evaluation_decision(code);
CREATE INDEX IF NOT EXISTS idx_evaluation_decision_active ON evaluation_decision(is_active);
 
-- ============================================================================
-- TABLA: assignee_type (Catálogo de Tipos de Asignado)
-- ============================================================================
CREATE TABLE IF NOT EXISTS assignee_type (
    id UUID PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT assignee_type_code_check CHECK (code != ''),
    CONSTRAINT assignee_type_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_assignee_type_code ON assignee_type(code);
CREATE INDEX IF NOT EXISTS idx_assignee_type_active ON assignee_type(is_active);
 
-- ============================================================================
-- TABLA: hiring_phase (Plantillas de Fases de Contratación)
-- ============================================================================
CREATE TABLE IF NOT EXISTS hiring_phase (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    is_initial_phase BOOLEAN NOT NULL DEFAULT false,
    is_final_phase BOOLEAN NOT NULL DEFAULT false,
    phase_evaluation_mode_id UUID NOT NULL,
    work_schedule_id UUID NOT NULL,
    company_calendar_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    duration_days INTEGER NOT NULL,
    default_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT hiring_phase_name_check CHECK (name != ''),
    CONSTRAINT hiring_phase_phase_type_check CHECK (NOT (is_initial_phase AND is_final_phase))
);
 
CREATE INDEX IF NOT EXISTS idx_hiring_phase_company_id ON hiring_phase(company_id);
CREATE INDEX IF NOT EXISTS idx_hiring_phase_is_initial_phase ON hiring_phase(is_initial_phase);
CREATE INDEX IF NOT EXISTS idx_hiring_phase_is_final_phase ON hiring_phase(is_final_phase);
CREATE INDEX IF NOT EXISTS idx_hiring_phase_phase_evaluation_mode_id ON hiring_phase(phase_evaluation_mode_id);
CREATE INDEX IF NOT EXISTS idx_hiring_phase_active ON hiring_phase(is_active);
 
-- ============================================================================
-- TABLA: position_hiring_phase (Fases de Contratación por Posición)
-- ============================================================================
CREATE TABLE IF NOT EXISTS position_hiring_phase (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    position_id UUID NOT NULL,
    hiring_phase_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT position_hiring_phase_unique_sequence UNIQUE (position_id, hiring_phase_id)
);
 
CREATE INDEX IF NOT EXISTS idx_position_hiring_phase_company_id ON position_hiring_phase(company_id);
CREATE INDEX IF NOT EXISTS idx_position_hiring_phase_position_id ON position_hiring_phase(position_id);
CREATE INDEX IF NOT EXISTS idx_position_hiring_phase_hiring_phase_id ON position_hiring_phase(hiring_phase_id);
 
-- ============================================================================
-- TABLA: evaluator_group_node (Nodos de Grupos de Evaluadores - Estructura Jerárquica)
-- ============================================================================
CREATE TABLE IF NOT EXISTS evaluator_group_node (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    parent_id UUID,
    name VARCHAR(255) NOT NULL,
    path TEXT NOT NULL,
    depth INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT evaluator_group_node_parent_fk FOREIGN KEY (parent_id)
        REFERENCES evaluator_group_node(id) ON DELETE CASCADE,
    CONSTRAINT evaluator_group_node_name_check CHECK (name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_evaluator_group_node_company_id ON evaluator_group_node(company_id);
CREATE INDEX IF NOT EXISTS idx_evaluator_group_node_parent_id ON evaluator_group_node(parent_id);
CREATE INDEX IF NOT EXISTS idx_evaluator_group_node_active ON evaluator_group_node(is_active);
CREATE INDEX IF NOT EXISTS idx_evaluator_group_node_depth ON evaluator_group_node(depth);
CREATE INDEX IF NOT EXISTS idx_evaluator_group_node_path ON evaluator_group_node USING GIST (path gist_trgm_ops);
 
-- ============================================================================
-- TABLA: evaluator_group_member (Miembros de Grupos de Evaluadores)
-- ============================================================================
CREATE TABLE IF NOT EXISTS evaluator_group_member (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    evaluator_group_node_id UUID NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT evaluator_group_member_node_fk FOREIGN KEY (evaluator_group_node_id)
        REFERENCES evaluator_group_node(id) ON DELETE CASCADE,
    CONSTRAINT evaluator_group_member_unique_group_user UNIQUE (evaluator_group_node_id, user_id)
);
 
CREATE INDEX IF NOT EXISTS idx_evaluator_group_member_company_id ON evaluator_group_member(company_id);
CREATE INDEX IF NOT EXISTS idx_evaluator_group_member_node_id ON evaluator_group_member(evaluator_group_node_id);
CREATE INDEX IF NOT EXISTS idx_evaluator_group_member_user_id ON evaluator_group_member(user_id);
 
-- ============================================================================
-- TABLA: phase_group_assignment (Asignación de Fases a Grupos de Evaluadores)
-- ============================================================================
CREATE TABLE IF NOT EXISTS phase_group_assignment (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    hiring_phase_id UUID NOT NULL,
    evaluator_group_node_id UUID NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT true,
    priority_order INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT phase_group_assignment_unique_phase_group UNIQUE (hiring_phase_id, evaluator_group_node_id)
);
 
CREATE INDEX IF NOT EXISTS idx_phase_group_assignment_company_id ON phase_group_assignment(company_id);
CREATE INDEX IF NOT EXISTS idx_phase_group_assignment_hiring_phase_id ON phase_group_assignment(hiring_phase_id);
CREATE INDEX IF NOT EXISTS idx_phase_group_assignment_group_node_id ON phase_group_assignment(evaluator_group_node_id);
 
-- ============================================================================
-- TABLA: candidate (Candidatos)
-- ============================================================================
CREATE TABLE IF NOT EXISTS candidate (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    position_id UUID NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    last_name VARCHAR(255) NOT NULL,
    second_last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    candidate_status_id UUID NOT NULL,
    candidate_can_view BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT candidate_unique_email_company UNIQUE (email, company_id),
    CONSTRAINT candidate_email_check CHECK (email != ''),
    CONSTRAINT candidate_first_name_check CHECK (first_name != ''),
    CONSTRAINT candidate_last_name_check CHECK (last_name != '')
);
 
CREATE INDEX IF NOT EXISTS idx_candidate_company_id ON candidate(company_id);
CREATE INDEX IF NOT EXISTS idx_candidate_position_id ON candidate(position_id);
CREATE INDEX IF NOT EXISTS idx_candidate_candidate_status_id ON candidate(candidate_status_id);
CREATE INDEX IF NOT EXISTS idx_candidate_email ON candidate(email);
CREATE INDEX IF NOT EXISTS idx_candidate_created_at ON candidate(created_at);
 
-- ============================================================================
-- TABLA: candidate_hiring_phase (Fases de Contratación del Candidato)
-- ============================================================================
CREATE TABLE IF NOT EXISTS candidate_hiring_phase (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    candidate_id UUID NOT NULL,
    hiring_phase_id UUID,
    sequence_order INTEGER NOT NULL,
    phase_name_snapshot VARCHAR(255) NOT NULL,
    phase_type_snapshot VARCHAR(50) NOT NULL,
    phase_evaluation_mode_snapshot VARCHAR(50) NOT NULL,
    duration_days_snapshot INTEGER NOT NULL,
    start_date DATE NOT NULL,
    due_date DATE NOT NULL,
    phase_status_id UUID NOT NULL,
    completed_at TIMESTAMP,
    notified_before_due BOOLEAN NOT NULL DEFAULT false,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT candidate_hiring_phase_unique_sequence UNIQUE (candidate_id, sequence_order)
);
 
CREATE INDEX IF NOT EXISTS idx_candidate_hiring_phase_company_id ON candidate_hiring_phase(company_id);
CREATE INDEX IF NOT EXISTS idx_candidate_hiring_phase_candidate_id ON candidate_hiring_phase(candidate_id);
CREATE INDEX IF NOT EXISTS idx_candidate_hiring_phase_hiring_phase_id ON candidate_hiring_phase(hiring_phase_id);
CREATE INDEX IF NOT EXISTS idx_candidate_hiring_phase_phase_status_id ON candidate_hiring_phase(phase_status_id);
CREATE INDEX IF NOT EXISTS idx_candidate_hiring_phase_due_date ON candidate_hiring_phase(due_date);
 
-- ============================================================================
-- TABLA: candidate_phase_evaluator (Evaluadores Asignados a Fases del Candidato)
-- ============================================================================
CREATE TABLE IF NOT EXISTS candidate_phase_evaluator (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    candidate_hiring_phase_id UUID NOT NULL,
    assignee_type_id UUID NOT NULL,
    assignment_source_id UUID NOT NULL,
    assignee_user_id UUID,
    evaluator_group_node_id UUID,
    taken_by_user_id UUID,
    taken_at TIMESTAMP,
    evaluation_status_id UUID NOT NULL,
    evaluation_decision_id UUID,
    comments TEXT,
    reassigned_by UUID,
    reassignment_reason TEXT,
    assigned_at TIMESTAMP NOT NULL,
    responded_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_company_id ON candidate_phase_evaluator(company_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_candidate_hiring_phase_id ON candidate_phase_evaluator(candidate_hiring_phase_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_assignee_type_id ON candidate_phase_evaluator(assignee_type_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_assignment_source_id ON candidate_phase_evaluator(assignment_source_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_assignee_user_id ON candidate_phase_evaluator(assignee_user_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_evaluator_group_node_id ON candidate_phase_evaluator(evaluator_group_node_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_evaluation_status_id ON candidate_phase_evaluator(evaluation_status_id);
CREATE INDEX IF NOT EXISTS idx_candidate_phase_evaluator_evaluation_decision_id ON candidate_phase_evaluator(evaluation_decision_id);
 
-- ============================================================================
-- TABLA: candidate_position_hiring_phase (Relación entre Candidatos y Fases por Posición)
-- ============================================================================
CREATE TABLE IF NOT EXISTS candidate_position_hiring_phase (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    candidate_id UUID NOT NULL,
    position_hiring_phase_id UUID NOT NULL,
    start_date DATE NOT NULL,
    due_date DATE NOT NULL,
    evaluation_status_id UUID,
    document_data BYTEA,
    document_file_name VARCHAR(255),
    document_file_type VARCHAR(100),
    document_file_size BIGINT,
    candidate_can_view_document BOOLEAN NOT NULL DEFAULT false,
    is_current BOOLEAN NOT NULL DEFAULT true,
    previous_register_id UUID,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT candidate_position_hiring_phase_candidate_fk FOREIGN KEY (candidate_id)
        REFERENCES candidate(id) ON DELETE SET NULL,
    CONSTRAINT candidate_position_hiring_phase_position_hiring_phase_fk FOREIGN KEY (position_hiring_phase_id)
        REFERENCES position_hiring_phase(id) ON DELETE SET NULL,
    CONSTRAINT candidate_position_hiring_phase_evaluation_status_fk FOREIGN KEY (evaluation_status_id)
        REFERENCES entity_status(id) ON DELETE SET NULL
);
 
CREATE INDEX IF NOT EXISTS idx_candidate_position_hiring_phase_company_id ON candidate_position_hiring_phase(company_id);
CREATE INDEX IF NOT EXISTS idx_candidate_position_hiring_phase_candidate_id ON candidate_position_hiring_phase(candidate_id);
CREATE INDEX IF NOT EXISTS idx_candidate_position_hiring_phase_position_hiring_phase_id ON candidate_position_hiring_phase(position_hiring_phase_id);
CREATE INDEX IF NOT EXISTS idx_candidate_position_hiring_phase_is_current ON candidate_position_hiring_phase(is_current);
CREATE INDEX IF NOT EXISTS idx_candidate_position_hiring_phase_created_at ON candidate_position_hiring_phase(created_at);
CREATE UNIQUE INDEX IF NOT EXISTS idx_candidate_position_hiring_phase_current ON candidate_position_hiring_phase(candidate_id, position_hiring_phase_id) WHERE is_current = true;
 
-- ============================================================================
-- FIN DEL SCRIPT DE SCHEMAS
-- ============================================================================
 
 
-- ============================================================================
-- MIGRATION: Módulos y Submódulos para Gestor de Hojas de Vida y Candidatos
-- ============================================================================
-- Descripción: Script de migración para actualizar y crear módulos relacionados
--              con la gestión de candidatos, hojas de vida y procesos de contratación
-- Fecha: 2026-05-14
-- ============================================================================
 
-- MÓDULO 1: Actualizar a SUPER_ADMIN
UPDATE public.modulos m
SET name = 'Catálogo de Super Admin',
    description = 'Módulo de administración y catálogo de la plataforma del super admin',
    main_function = 'Administración central del sistema',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;
 
-- MÓDULO 2: Actualizar a PARAMETRIZACIÓN
UPDATE public.modulos m
SET name = 'Parametrización',
    description = 'Configuración y parametrización general del sistema',
    main_function = 'Gestión de parámetros y configuración de seguridad',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 2;
 
-- MÓDULO 3: Crear GESTOR DE HOJAS DE VIDA
INSERT INTO public.modulos (id, name, description, active, main_function, created_at, updated_at)
VALUES (
    3,
    'Gestor de Hojas de Vida',
    'Administración de hojas de vida, candidatos y funcionarios',
    true,
    'Gestión integral de candidatos, empleados y hojas de vida',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (id) DO NOTHING;
 
-- MÓDULO 4: Crear GESTOR DE PROYECTOS
INSERT INTO public.modulos (id, name, description, active, main_function, created_at, updated_at)
VALUES (
    4,
    'Gestor de Proyectos',
    'Administración de proyectos y asignaciones',
    true,
    'Gestión integral de proyectos y recursos',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (id) DO NOTHING;
 
-- ============================================================================
-- ASIGNACIÓN DE SUBMÓDULOS A MÓDULOS
-- ============================================================================
 
-- Migrar Submódulos a Módulo 2 (Parametrización)
UPDATE public.submodules s
SET module_id = 2, updated_at = CURRENT_TIMESTAMP
WHERE id IN (14, 15);
 
-- Migrar Submódulos a Módulo 3 (Gestor de Hojas de Vida)
UPDATE public.submodules s
SET module_id = 3, updated_at = CURRENT_TIMESTAMP
WHERE id IN (9, 10, 11, 12, 13);
 
-- Migrar Submódulo a Módulo 4 (Gestor de Proyectos)
UPDATE public.submodules s
SET module_id = 4, updated_at = CURRENT_TIMESTAMP
WHERE id IN (16);
 
-- ============================================================================
-- ACTUALIZACIÓN DE RUTAS DE SUBMÓDULOS
-- ============================================================================
 
-- Actualizar ruta submódulo "Mi Organización"
UPDATE public.submodules s
SET route = 'parametrizacion/main/mi-organizacion', updated_at = CURRENT_TIMESTAMP
WHERE id = 14;
 
-- Actualizar ruta submódulo "Seguridad"
UPDATE public.submodules s
SET route = 'parametrizacion/main/seguridad', updated_at = CURRENT_TIMESTAMP
WHERE id = 15;
 
-- ============================================================================
-- ASIGNACIÓN DE MÓDULOS A PLANES
-- ============================================================================
 
-- Eliminar Módulo 1 del plan 100
DELETE FROM public.plan_modulos p
WHERE plan_id = 100 AND modulo_id = 1;
 
-- Agregar Módulo 3 (Gestor de Hojas de Vida) al plan 100
INSERT INTO public.plan_modulos (plan_id, modulo_id)
VALUES (100, 3)
ON CONFLICT (plan_id, modulo_id) DO NOTHING;
 
-- Agregar Módulo 4 (Gestor de Proyectos) al plan 100
INSERT INTO public.plan_modulos (plan_id, modulo_id)
VALUES (100, 4)
ON CONFLICT (plan_id, modulo_id) DO NOTHING;
 
-- ============================================================================
-- CREACIÓN DE SUBMÓDULOS NUEVOS
-- ============================================================================
 
-- Crear Submódulo "Fases de Contratación" para Módulo 3
INSERT INTO public.submodules (id, module_id, name, description, active, icon, route, created_at, updated_at)
VALUES (
    17,
    3,
    'Fases de Contratación',
    'Gestión de fases del proceso de contratación',
    true,
    'fa-solid fa-briefcase',
    'grh/main/fases-de-contratacion',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (id) DO NOTHING;
 
-- ============================================================================
-- FIN DEL SCRIPT DE MIGRACIÓN
-- ============================================================================
 
 
 