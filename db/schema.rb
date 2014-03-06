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

ActiveRecord::Schema.define(version: 20140306010315) do

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

end
