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

ActiveRecord::Schema.define(version: 20160419232942) do

  create_table "BAK_vinculacion_servicios_bitacora", id: false, force: :cascade do |t|
    t.integer  "id",                      limit: 4,                            default: 0,   null: false
    t.integer  "bitacora_id",             limit: 4
    t.string   "nombre",                  limit: 255
    t.string   "descripcion",             limit: 255
    t.decimal  "precio_venta",                        precision: 10, scale: 2, default: 0.0
    t.integer  "status",                  limit: 4,                            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "costo_interno",                       precision: 10, scale: 2, default: 0.0
    t.integer  "empleado_id",             limit: 4
    t.integer  "sede_id",                 limit: 4
    t.integer  "laboratorio_bitacora_id", limit: 4
  end

  create_table "bp1", id: false, force: :cascade do |t|
    t.string  "number",            limit: 20
    t.string  "system_id",         limit: 255
    t.integer "system_status",     limit: 4,   default: 1
    t.integer "system_request_id", limit: 4
  end

  create_table "corregir", id: false, force: :cascade do |t|
    t.integer "cid",         limit: 4,   default: 0, null: false
    t.string  "codigo",      limit: 20
    t.string  "consecutivo", limit: 255
    t.integer "cstatus",     limit: 4,   default: 1
    t.integer "sstatus",     limit: 4,   default: 1
  end

  create_table "costo_hora", id: false, force: :cascade do |t|
    t.integer "uh",     limit: 4
    t.text    "nombre", limit: 65535
    t.decimal "costo",                precision: 10, scale: 2
  end

  create_table "cotizacion1600", id: false, force: :cascade do |t|
    t.integer  "id",              limit: 4,                              default: 0,     null: false
    t.integer  "cantidad",        limit: 4,                              default: 1
    t.text     "concepto",        limit: 65535
    t.decimal  "precio_unitario",               precision: 10, scale: 2, default: 0.0
    t.integer  "status",          limit: 4,                              default: 0
    t.integer  "cotizacion_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "inmutable",                                              default: false
    t.integer  "servicio_id",     limit: 4
  end

  create_table "estados", force: :cascade do |t|
    t.string   "nombre",     limit: 255
    t.string   "codigo",     limit: 255
    t.string   "lat",        limit: 20
    t.string   "long",       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fixs", id: false, force: :cascade do |t|
    t.integer "cid",     limit: 4, default: 0, null: false
    t.integer "cstatus", limit: 4, default: 1
  end

  create_table "monedas", force: :cascade do |t|
    t.string   "codigo",     limit: 255
    t.string   "nombre",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paises", force: :cascade do |t|
    t.string   "nombre",     limit: 255
    t.string   "codigo",     limit: 255
    t.string   "lat",        limit: 20
    t.string   "long",       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proyectos_fondos", force: :cascade do |t|
    t.string   "nombre",      limit: 255
    t.text     "descripcion", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurso_id",  limit: 4
  end

  create_table "proyectos_proyectos", force: :cascade do |t|
    t.string   "cuenta",                 limit: 255
    t.string   "nombre",                 limit: 255
    t.text     "descripcion",            limit: 16777215
    t.text     "impacto",                limit: 16777215
    t.text     "resultado_esperado",     limit: 16777215
    t.text     "objetivo_estrategico",   limit: 16777215
    t.text     "alcance",                limit: 16777215
    t.string   "referencia_externa",     limit: 255
    t.string   "convenio",               limit: 255
    t.string   "banco_cuenta",           limit: 255
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.integer  "anio",                   limit: 4,                                 default: 0
    t.decimal  "presupuesto_autorizado",                  precision: 10, scale: 2, default: 0.0
    t.integer  "fondo_id",               limit: 4
    t.integer  "recurso_id",             limit: 4
    t.integer  "tipo_id",                limit: 4
    t.integer  "departamento_id",        limit: 4
    t.integer  "sede_id",                limit: 4
    t.integer  "moneda_id",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsable_id",         limit: 4
    t.integer  "proyecto_base_id",       limit: 4
  end

  create_table "proyectos_recursos", force: :cascade do |t|
    t.string   "nombre",      limit: 255
    t.text     "descripcion", limit: 16777215
    t.integer  "tipo_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proyectos_recursos", ["tipo_id"], name: "index_proyectos_recursos_on_tipo_id", using: :btree

  create_table "proyectos_tipos", force: :cascade do |t|
    t.string   "nombre",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rescoti", id: false, force: :cascade do |t|
    t.integer "solicitud_id",  limit: 4
    t.integer "cotizacion_id", limit: 4
    t.decimal "pv",                      precision: 45, scale: 4
  end

  create_table "rh_departamentos", force: :cascade do |t|
    t.string   "nombre",          limit: 255, null: false
    t.string   "descripcion",     limit: 255, null: false
    t.integer  "sede_id",         limit: 4
    t.integer  "empleado_id",     limit: 4
    t.integer  "departamento_id", limit: 4
    t.string   "image",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rh_empleados", force: :cascade do |t|
    t.string   "nombre",           limit: 255, null: false
    t.string   "apellido_paterno", limit: 255, null: false
    t.string   "apellido_materno", limit: 255, null: false
    t.string   "email",            limit: 255, null: false
    t.string   "codigo",           limit: 255
    t.string   "puesto",           limit: 255
    t.integer  "sede_id",          limit: 4
    t.date     "fecha_nacimiento"
    t.integer  "pais_id",          limit: 4
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.string   "curp",             limit: 255
    t.string   "rfc",              limit: 255
    t.integer  "departamento_id",  limit: 4
    t.integer  "empleado_id",      limit: 4
    t.string   "image",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rh_sedes", force: :cascade do |t|
    t.string   "nombre",      limit: 255, null: false
    t.string   "descripcion", limit: 255, null: false
    t.integer  "empleado_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sb1", id: false, force: :cascade do |t|
    t.integer  "id",                          limit: 4,                                 default: 0,   null: false
    t.integer  "consecutivo",                 limit: 4
    t.string   "codigo",                      limit: 20
    t.integer  "proyecto_id",                 limit: 4
    t.integer  "sede_id",                     limit: 4
    t.integer  "prioridad",                   limit: 4
    t.integer  "cliente_id",                  limit: 4
    t.integer  "contacto_id",                 limit: 4
    t.integer  "usuario_id",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descripcion",                 limit: 16777215
    t.text     "motivo_status",               limit: 16777215
    t.string   "razon_cancelacion",           limit: 255,                               default: "1"
    t.integer  "status",                      limit: 4,                                 default: 1
    t.string   "orden_compra",                limit: 255
    t.date     "fecha_inicio"
    t.date     "fecha_termino"
    t.integer  "responsable_presupuestal_id", limit: 4
    t.integer  "duracion",                    limit: 4,                                 default: 1
    t.integer  "tipo",                        limit: 4,                                 default: 1
    t.integer  "tiempo_entrega",              limit: 4,                                 default: 1
    t.decimal  "precio_sugerido",                              precision: 10, scale: 2, default: 0.0
    t.string   "vinculacion_hash",            limit: 255
  end

  create_table "sp2", id: false, force: :cascade do |t|
    t.datetime "updated_at"
    t.integer  "id",         limit: 4,  default: 0, null: false
    t.integer  "status",     limit: 4,  default: 1
    t.string   "number",     limit: 20
    t.integer  "rel",        limit: 4
  end

  create_table "sp3", id: false, force: :cascade do |t|
    t.datetime "updated_at"
    t.integer  "id",         limit: 4,  default: 0, null: false
    t.integer  "status",     limit: 4,  default: 1
    t.string   "number",     limit: 20
    t.integer  "rel",        limit: 4
  end

  create_table "tmp_clientes", id: false, force: :cascade do |t|
    t.integer "id",        limit: 4,   default: 0, null: false
    t.string  "calle_num", limit: 255
    t.string  "colonia",   limit: 255
    t.string  "ciudad",    limit: 255
    t.string  "estado",    limit: 255
    t.string  "pais",      limit: 255
    t.string  "cp",        limit: 255
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "usuario",     limit: 255,             null: false
    t.string   "email",       limit: 255,             null: false
    t.string   "nombre",      limit: 255,             null: false
    t.string   "apellidos",   limit: 255,             null: false
    t.string   "token",       limit: 255
    t.integer  "status",      limit: 4,   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",        limit: 255
    t.integer  "sede_id",     limit: 4
    t.integer  "proyecto_id", limit: 4
    t.string   "avatar_url",  limit: 255
  end

  add_index "usuarios", ["email"], name: "index_usuarios_on_email", using: :btree
  add_index "usuarios", ["usuario"], name: "index_usuarios_on_usuario", using: :btree

  create_table "vinculacion_cedulas", force: :cascade do |t|
    t.integer  "solicitud_id", limit: 4
    t.integer  "servicio_id",  limit: 4
    t.text     "codigo",       limit: 16777215
    t.integer  "status",       limit: 4,        default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_clientes", force: :cascade do |t|
    t.string   "rfc",            limit: 255
    t.string   "razon_social",   limit: 255
    t.integer  "num_empleados",  limit: 4
    t.string   "calle_num",      limit: 255
    t.string   "colonia",        limit: 255
    t.string   "cp",             limit: 255
    t.string   "telefono",       limit: 255
    t.string   "fax",            limit: 255
    t.string   "email",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tamano_empresa", limit: 4
    t.integer  "sector",         limit: 4
    t.integer  "pais_id",        limit: 4
    t.integer  "estado_id",      limit: 4
    t.string   "ciudad",         limit: 255
    t.string   "clave",          limit: 255
    t.string   "nombre",         limit: 255
  end

  create_table "vinculacion_clientes_old", id: false, force: :cascade do |t|
    t.integer  "id",             limit: 4,   default: 0, null: false
    t.string   "rfc",            limit: 255
    t.string   "razon_social",   limit: 255
    t.integer  "num_empleados",  limit: 4
    t.string   "calle_num",      limit: 255
    t.string   "colonia",        limit: 255
    t.string   "cp",             limit: 255
    t.string   "telefono",       limit: 255
    t.string   "fax",            limit: 255
    t.string   "email",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tamano_empresa", limit: 4
    t.integer  "sector",         limit: 4
    t.integer  "pais_id",        limit: 4
    t.integer  "estado_id",      limit: 4
    t.string   "ciudad",         limit: 255
    t.string   "clave",          limit: 255
    t.string   "nombre",         limit: 255
  end

  create_table "vinculacion_contactos", force: :cascade do |t|
    t.string   "nombre",       limit: 255
    t.string   "telefono",     limit: 255
    t.string   "email",        limit: 255
    t.string   "departamento", limit: 255
    t.string   "puesto",       limit: 255
    t.string   "notas",        limit: 255
    t.integer  "cliente_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_costeos", force: :cascade do |t|
    t.integer  "consecutivo",     limit: 4
    t.string   "codigo",          limit: 20
    t.integer  "servicio_id",     limit: 4
    t.integer  "usuario_id",      limit: 4
    t.integer  "status",          limit: 4,     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bitacora_id",     limit: 4
    t.text     "nombre_servicio", limit: 65535
    t.integer  "muestra_id",      limit: 4
  end

  create_table "vinculacion_costeos_detalle", force: :cascade do |t|
    t.integer  "costeo_id",       limit: 4
    t.integer  "tipo",            limit: 4
    t.string   "descripcion",     limit: 255
    t.decimal  "cantidad",                    precision: 10, scale: 2, default: 0.0
    t.decimal  "precio_unitario",             precision: 10, scale: 2
    t.integer  "status",          limit: 4,                            default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_costos_variables", force: :cascade do |t|
    t.integer  "tipo",        limit: 4
    t.text     "descripcion", limit: 16777215
    t.decimal  "costo",                        precision: 10, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cedula_id",   limit: 4
  end

  create_table "vinculacion_cotizaciones", force: :cascade do |t|
    t.string   "consecutivo",          limit: 255
    t.date     "fecha_notificacion"
    t.integer  "condicion",            limit: 4
    t.integer  "idioma",               limit: 4
    t.integer  "divisa",               limit: 4
    t.text     "comentarios",          limit: 16777215
    t.text     "observaciones",        limit: 16777215
    t.text     "notas",                limit: 16777215
    t.decimal  "subtotal",                              precision: 10, scale: 2, default: 0.0
    t.decimal  "precio_venta",                          precision: 10, scale: 2, default: 0.0
    t.decimal  "precio_unitario",                       precision: 10, scale: 2, default: 0.0
    t.decimal  "descuento_porcentaje",                  precision: 5,  scale: 2, default: 0.0
    t.integer  "solicitud_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "msg_notificacion",     limit: 16777215
    t.text     "motivo_status",        limit: 16777215
    t.integer  "duracion",             limit: 4
    t.decimal  "iva",                                   precision: 10, scale: 2, default: 15.0
    t.text     "motivo_descuento",     limit: 16777215
    t.integer  "status",               limit: 4,                                 default: 1
    t.integer  "tiempo_entrega",       limit: 4,                                 default: 1
  end

  create_table "vinculacion_cotizaciones_detalle", force: :cascade do |t|
    t.integer  "cantidad",        limit: 4,                              default: 1
    t.text     "concepto",        limit: 65535
    t.decimal  "precio_unitario",               precision: 10, scale: 2, default: 0.0
    t.integer  "status",          limit: 4,                              default: 0
    t.integer  "cotizacion_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "inmutable",                                              default: false
    t.integer  "servicio_id",     limit: 4
  end

  create_table "vinculacion_laboratorios_bitacora", force: :cascade do |t|
    t.integer "id_lab_bitacora", limit: 4
    t.string  "nombre",          limit: 255
  end

  create_table "vinculacion_muestras", force: :cascade do |t|
    t.integer  "solicitud_id",   limit: 4
    t.integer  "consecutivo",    limit: 4
    t.string   "codigo",         limit: 20
    t.string   "identificacion", limit: 255
    t.text     "descripcion",    limit: 16777215
    t.integer  "cantidad",       limit: 4
    t.integer  "usuario_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",         limit: 4,        default: 1
  end

  create_table "vinculacion_muestras_detalle", force: :cascade do |t|
    t.integer "muestra_id",             limit: 4
    t.integer "consecutivo",            limit: 4
    t.string  "cliente_identificacion", limit: 255
    t.text    "notas",                  limit: 65535
    t.string  "status",                 limit: 255,   default: "1"
  end

  create_table "vinculacion_registros", force: :cascade do |t|
    t.integer  "empleado_id",        limit: 4
    t.integer  "solicitud_id",       limit: 4
    t.string   "tipo",               limit: 255
    t.text     "mensaje",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",             limit: 4,     default: 0
    t.integer  "bitacora_alerta_id", limit: 4,     default: 0
    t.integer  "empleado_cierre_id", limit: 4,     default: 0
    t.date     "fecha_apertura"
    t.date     "fecha_cierre"
  end

  add_index "vinculacion_registros", ["empleado_id"], name: "index_vinculacion_registros_on_empleado_id", using: :btree
  add_index "vinculacion_registros", ["solicitud_id"], name: "index_vinculacion_registros_on_solicitud_id", using: :btree

  create_table "vinculacion_registros_nota", force: :cascade do |t|
    t.integer  "usuario_id",  limit: 4
    t.integer  "registro_id", limit: 4
    t.text     "mensaje",     limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "vinculacion_remanentes", force: :cascade do |t|
    t.integer  "empleado_id",              limit: 4
    t.decimal  "porcentaje_participacion",           precision: 6,  scale: 2, default: 0.0
    t.decimal  "monto",                              precision: 10, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cedula_id",                limit: 4
  end

  create_table "vinculacion_sectores_industrial", force: :cascade do |t|
    t.string   "codigo",      limit: 20
    t.text     "descripcion", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_servicios", force: :cascade do |t|
    t.integer  "solicitud_id",         limit: 4
    t.integer  "consecutivo",          limit: 4
    t.string   "codigo",               limit: 20
    t.text     "nombre",               limit: 65535
    t.text     "descripcion",          limit: 16777215
    t.integer  "empleado_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",               limit: 4,                                 default: 1
    t.integer  "servicio_bitacora_id", limit: 4
    t.decimal  "precio_sugerido",                       precision: 10, scale: 2, default: 0.0
    t.integer  "tiempo_estimado",      limit: 4,                                 default: 0
  end

  create_table "vinculacion_servicios_bitacora", force: :cascade do |t|
    t.integer  "bitacora_id",             limit: 4
    t.text     "nombre",                  limit: 65535
    t.text     "descripcion",             limit: 65535
    t.decimal  "precio_venta",                          precision: 10, scale: 2, default: 0.0
    t.integer  "status",                  limit: 4,                              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "costo_interno",                         precision: 10, scale: 2, default: 0.0
    t.integer  "empleado_id",             limit: 4
    t.integer  "sede_id",                 limit: 4
    t.integer  "laboratorio_bitacora_id", limit: 4
  end

  create_table "vinculacion_servicios_muestras", id: false, force: :cascade do |t|
    t.integer  "servicio_id", limit: 4
    t.integer  "muestra_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculacion_solicitudes", force: :cascade do |t|
    t.integer  "consecutivo",                 limit: 4
    t.string   "codigo",                      limit: 20
    t.integer  "proyecto_id",                 limit: 4
    t.integer  "sede_id",                     limit: 4
    t.integer  "prioridad",                   limit: 4
    t.integer  "cliente_id",                  limit: 4
    t.integer  "contacto_id",                 limit: 4
    t.integer  "usuario_id",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descripcion",                 limit: 16777215
    t.text     "motivo_status",               limit: 16777215
    t.string   "razon_cancelacion",           limit: 255,                               default: "1"
    t.integer  "status",                      limit: 4,                                 default: 1
    t.string   "orden_compra",                limit: 255
    t.date     "fecha_inicio"
    t.date     "fecha_termino"
    t.integer  "responsable_presupuestal_id", limit: 4
    t.integer  "duracion",                    limit: 4,                                 default: 1
    t.integer  "tipo",                        limit: 4,                                 default: 1
    t.integer  "tiempo_entrega",              limit: 4,                                 default: 1
    t.decimal  "precio_sugerido",                              precision: 10, scale: 2, default: 0.0
    t.string   "vinculacion_hash",            limit: 255
  end

  create_table "vinculacion_tamanos_empresa", force: :cascade do |t|
    t.string   "codigo",      limit: 20
    t.text     "descripcion", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vs1", id: false, force: :cascade do |t|
    t.integer  "id",                   limit: 4,                                 default: 0,   null: false
    t.integer  "solicitud_id",         limit: 4
    t.integer  "consecutivo",          limit: 4
    t.string   "codigo",               limit: 20
    t.string   "nombre",               limit: 255
    t.text     "descripcion",          limit: 16777215
    t.integer  "empleado_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",               limit: 4,                                 default: 1
    t.integer  "servicio_bitacora_id", limit: 4
    t.decimal  "precio_sugerido",                       precision: 10, scale: 2, default: 0.0
    t.integer  "tiempo_estimado",      limit: 4,                                 default: 0
  end

  create_table "xempleados", id: false, force: :cascade do |t|
    t.integer  "id",               limit: 4,   default: 0, null: false
    t.string   "nombre",           limit: 255,             null: false
    t.string   "apellido_paterno", limit: 255,             null: false
    t.string   "apellido_materno", limit: 255,             null: false
    t.string   "email",            limit: 255,             null: false
    t.string   "codigo",           limit: 255
    t.string   "puesto",           limit: 255
    t.integer  "sede_id",          limit: 4
    t.date     "fecha_nacimiento"
    t.integer  "pais_id",          limit: 4
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.string   "curp",             limit: 255
    t.string   "rfc",              limit: 255
    t.integer  "departamento_id",  limit: 4
    t.integer  "empleado_id",      limit: 4
    t.string   "image",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
