# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140508182203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "estados", force: true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.string   "lat",        limit: 20
    t.string   "long",       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paises", force: true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.string   "lat",        limit: 20
    t.string   "long",       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rh_departamentos", force: true do |t|
    t.string   "nombre",          null: false
    t.string   "descripcion",     null: false
    t.integer  "sede_id"
    t.integer  "empleado_id"
    t.integer  "departamento_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rh_empleados", force: true do |t|
    t.string   "nombre",           null: false
    t.string   "apellido_paterno", null: false
    t.string   "apellido_materno", null: false
    t.string   "email",            null: false
    t.string   "codigo"
    t.string   "puesto"
    t.integer  "sede_id"
    t.date     "fecha_nacimiento"
    t.integer  "pais_id"
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.string   "curp"
    t.string   "rfc"
    t.integer  "departamento_id"
    t.integer  "empleado_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rh_sedes", force: true do |t|
    t.string   "nombre",      null: false
    t.string   "descripcion", null: false
    t.integer  "empleado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_clientes", force: true do |t|
    t.string   "rfc"
    t.string   "razon_social"
    t.integer  "num_empleados"
    t.string   "calle_num"
    t.string   "colonia"
    t.string   "cp"
    t.string   "telefono"
    t.string   "fax"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tamano_empresa"
    t.integer  "sector"
  end

  create_table "vinculacion_contactos", force: true do |t|
    t.string   "nombre"
    t.string   "telefono"
    t.string   "email"
    t.string   "departamento"
    t.string   "puesto"
    t.string   "notas"
    t.integer  "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_costeos", force: true do |t|
    t.integer  "consecutivo"
    t.string   "codigo",          limit: 20
    t.integer  "servicio_id"
    t.integer  "usuario_id"
    t.integer  "status",                     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bitacora_id"
    t.string   "nombre_servicio"
    t.integer  "muestra_id"
  end

  create_table "vinculacion_costeos_detalle", force: true do |t|
    t.integer  "costeo_id"
    t.integer  "tipo"
    t.string   "descripcion"
    t.integer  "cantidad"
    t.decimal  "precio_unitario", precision: 10, scale: 2
    t.integer  "status",                                   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_cotizaciones", force: true do |t|
    t.string   "consecutivo"
    t.date     "fecha_notificacion"
    t.integer  "condicion"
    t.integer  "idioma"
    t.integer  "divisa"
    t.text     "comentarios"
    t.text     "observaciones"
    t.text     "notas"
    t.decimal  "subtotal",             precision: 10, scale: 2, default: 0.0
    t.decimal  "precio_venta",         precision: 10, scale: 2, default: 0.0
    t.decimal  "precio_unitario",      precision: 10, scale: 2, default: 0.0
    t.decimal  "descuento_porcentaje", precision: 5,  scale: 2, default: 0.0
    t.integer  "status",                                        default: 0
    t.integer  "solicitud_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "msg_notificacion"
    t.text     "motivo_status"
    t.integer  "duracion"
    t.decimal  "iva",                  precision: 10, scale: 2, default: 15.0
    t.text     "motivo_descuento"
  end

  create_table "vinculacion_cotizaciones_detalle", force: true do |t|
    t.integer  "cantidad",                                 default: 1
    t.string   "concepto"
    t.decimal  "precio_unitario", precision: 10, scale: 2, default: 0.0
    t.integer  "status",                                   default: 0
    t.integer  "cotizacion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_muestras", force: true do |t|
    t.integer  "solicitud_id"
    t.integer  "consecutivo"
    t.string   "codigo",         limit: 20
    t.string   "identificacion"
    t.text     "descripcion"
    t.integer  "cantidad"
    t.integer  "usuario_id"
    t.string   "status",                    default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_proyectos", force: true do |t|
    t.string   "codigo",             limit: 20,               null: false
    t.string   "descripcion"
    t.text     "obj_proyecto"
    t.text     "impacto"
    t.text     "resultado_esperado"
    t.text     "obj_estrategico"
    t.string   "anio",               limit: 4
    t.string   "status",                        default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre"
    t.date     "fecha_inicio"
    t.date     "fecha_termino"
  end

  create_table "vinculacion_sectores_industrial", force: true do |t|
    t.string   "codigo",      limit: 20
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_servicios", force: true do |t|
    t.integer  "solicitud_id"
    t.integer  "consecutivo"
    t.string   "codigo",       limit: 20
    t.string   "nombre"
    t.text     "descripcion"
    t.integer  "empleado_id"
    t.string   "status",                  default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_servicios_muestras", id: false, force: true do |t|
    t.integer  "servicio_id"
    t.integer  "muestra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_solicitudes", force: true do |t|
    t.integer  "consecutivo"
    t.string   "codigo",            limit: 20
    t.integer  "proyecto_id"
    t.integer  "sede_id"
    t.integer  "prioridad"
    t.integer  "cliente_id"
    t.integer  "contacto_id"
    t.integer  "usuario_id"
    t.string   "status",                       default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descripcion"
    t.text     "motivo_status"
    t.string   "razon_cancelacion",            default: "1"
  end

  create_table "vinculacion_tamanos_empresa", force: true do |t|
    t.string   "codigo",      limit: 20
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
