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

ActiveRecord::Schema.define(version: 20141022165510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bienes_de_consumo", force: true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bienes_de_consumo_de_recepcion", force: true do |t|
    t.integer  "bien_de_consumo_id"
    t.integer  "cantidad"
    t.decimal  "costo"
    t.integer  "recepcion_de_bien_de_consumo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bienes_de_consumo_de_recepcion", ["bien_de_consumo_id"], name: "index_bienes_de_consumo_de_recep_on_bien_de_consumo_id", using: :btree
  add_index "bienes_de_consumo_de_recepcion", ["recepcion_de_bien_de_consumo_id"], name: "index_bienes_de_consumo_de_recep_on_recep_de_bien_de_consumo_id", using: :btree

  create_table "documentos_de_recepcion", force: true do |t|
    t.integer  "tipo_de_documento_id"
    t.string   "numero_de_documento"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documentos_de_recepcion", ["tipo_de_documento_id"], name: "index_documentos_de_recepcion_on_tipo_de_documento_id", using: :btree

  create_table "documentos_principal", force: true do |t|
    t.integer  "documento_de_recepcion_id"
    t.integer  "recepcion_de_bien_de_consumo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documentos_principal", ["documento_de_recepcion_id"], name: "index_documentos_principal_on_documento_de_recepcion_id", using: :btree
  add_index "documentos_principal", ["recepcion_de_bien_de_consumo_id"], name: "index_documentos_principal_on_recepcion_de_bien_de_consumo_id", using: :btree

  create_table "documentos_secundario", force: true do |t|
    t.integer  "documento_de_recepcion_id"
    t.integer  "recepcion_de_bien_de_consumo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documentos_secundario", ["documento_de_recepcion_id"], name: "index_documentos_secundario_on_documento_de_recepcion_id", using: :btree
  add_index "documentos_secundario", ["recepcion_de_bien_de_consumo_id"], name: "index_documentos_secundario_on_recepcion_de_bien_de_consumo_id", using: :btree

  create_table "recepciones_de_bien_de_consumo", force: true do |t|
    t.datetime "fecha"
    t.integer  "estado"
    t.text     "descripcion_provisoria"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipos_de_documentos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
