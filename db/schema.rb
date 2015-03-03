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

ActiveRecord::Schema.define(version: 20150302223722) do

  create_table "estados", force: true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.string   "lat",        limit: 20
    t.string   "long",       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monedas", force: true do |t|
    t.string   "codigo"
    t.string   "nombre"
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

  create_table "proyectos_fondos", force: true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurso_id"
  end

  create_table "proyectos_proyectos", force: true do |t|
    t.string   "cuenta"
    t.string   "nombre"
    t.text     "descripcion"
    t.text     "impacto"
    t.text     "resultado_esperado"
    t.text     "objetivo_estrategico"
    t.text     "alcance"
    t.string   "referencia_externa"
    t.string   "convenio"
    t.string   "banco_cuenta"
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.integer  "anio",                                            default: 0
    t.decimal  "presupuesto_autorizado", precision: 10, scale: 2, default: 0.0
    t.integer  "fondo_id"
    t.integer  "recurso_id"
    t.integer  "tipo_id"
    t.integer  "departamento_id"
    t.integer  "sede_id"
    t.integer  "moneda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsable_id"
    t.integer  "proyecto_base_id"
  end

  create_table "proyectos_recursos", force: true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.integer  "tipo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proyectos_recursos", ["tipo_id"], name: "index_proyectos_recursos_on_tipo_id", using: :btree

  create_table "proyectos_tipos", force: true do |t|
    t.string   "nombre"
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

  create_table "usuarios", force: true do |t|
    t.string   "usuario",                 null: false
    t.string   "email",                   null: false
    t.string   "nombre",                  null: false
    t.string   "apellidos",               null: false
    t.string   "token"
    t.integer  "status",      default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "sede_id"
    t.integer  "proyecto_id"
  end

  add_index "usuarios", ["email"], name: "index_usuarios_on_email", using: :btree
  add_index "usuarios", ["usuario"], name: "index_usuarios_on_usuario", using: :btree

  create_table "vinculacion_cedulas", force: true do |t|
    t.integer  "solicitud_id"
    t.integer  "servicio_id"
    t.text     "codigo"
    t.integer  "status",       default: 1
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
    t.integer  "pais_id"
    t.integer  "estado_id"
    t.string   "ciudad"
    t.string   "clave"
    t.string   "nombre"
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

  create_table "vinculacion_costos_variables", force: true do |t|
    t.integer  "tipo"
    t.text     "descripcion"
    t.decimal  "costo",       precision: 10, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cedula_id"
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
    t.integer  "solicitud_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "msg_notificacion"
    t.text     "motivo_status"
    t.integer  "duracion"
    t.decimal  "iva",                  precision: 10, scale: 2, default: 15.0
    t.text     "motivo_descuento"
    t.integer  "status",                                        default: 1
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                    default: 1
  end

  create_table "vinculacion_remanentes", force: true do |t|
    t.integer  "empleado_id"
    t.decimal  "porcentaje_participacion", precision: 6,  scale: 2, default: 0.0
    t.decimal  "monto",                    precision: 10, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cedula_id"
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
    t.string   "codigo",               limit: 20
    t.string   "nombre"
    t.text     "descripcion"
    t.integer  "empleado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                          default: 1
    t.integer  "servicio_bitacora_id"
  end

  create_table "vinculacion_servicios_bitacora", force: true do |t|
    t.integer  "bitacora_id"
    t.string   "nombre"
    t.string   "descripcion"
    t.decimal  "precio_venta",  precision: 10, scale: 2, default: 0.0
    t.integer  "status",                                 default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "costo_interno", precision: 10, scale: 2, default: 0.0
    t.integer  "empleado_id"
  end

  create_table "vinculacion_servicios_muestras", id: false, force: true do |t|
    t.integer  "servicio_id"
    t.integer  "muestra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_solicitudes", force: true do |t|
    t.integer  "consecutivo"
    t.string   "codigo",                      limit: 20
    t.integer  "proyecto_id"
    t.integer  "sede_id"
    t.integer  "prioridad"
    t.integer  "cliente_id"
    t.integer  "contacto_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descripcion"
    t.text     "motivo_status"
    t.string   "razon_cancelacion",                      default: "1"
    t.integer  "status",                                 default: 1
    t.string   "orden_compra"
    t.date     "fecha_inicio"
    t.date     "fecha_termino"
    t.integer  "responsable_presupuestal_id"
    t.integer  "duracion",                               default: 1
    t.integer  "tipo",                                   default: 1
    t.integer  "tiempo_entrega",                         default: 1
  end

  create_table "vinculacion_tamanos_empresa", force: true do |t|
    t.string   "codigo",      limit: 20
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
