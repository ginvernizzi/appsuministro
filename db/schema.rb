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

ActiveRecord::Schema.define(version: 20160211184809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "nombre"
    t.string   "responsable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bienes_de_consumo", force: :cascade do |t|
    t.string   "nombre"
    t.string   "codigo",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "detalle_adicional"
    t.string   "unidad_de_medida"
    t.integer  "clase_id"
    t.datetime "fecha_de_baja"
    t.integer  "stock_minimo"
  end

  add_index "bienes_de_consumo", ["clase_id"], name: "index_bienes_de_consumo_on_clase_id", using: :btree

  create_table "bienes_de_consumo_de_recepcion", force: :cascade do |t|
    t.integer  "bien_de_consumo_id"
    t.integer  "cantidad"
    t.decimal  "costo"
    t.integer  "recepcion_de_bien_de_consumo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bienes_de_consumo_de_recepcion", ["bien_de_consumo_id"], name: "index_bienes_de_consumo_de_recep_on_bien_de_consumo_id", using: :btree
  add_index "bienes_de_consumo_de_recepcion", ["recepcion_de_bien_de_consumo_id"], name: "index_bienes_de_consumo_de_recep_on_recep_de_bien_de_consumo_id", using: :btree

  create_table "bienes_de_consumo_para_consumir", force: :cascade do |t|
    t.integer  "cantidad"
    t.decimal  "costo"
    t.integer  "bien_de_consumo_id"
    t.integer  "consumo_directo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
  end

  add_index "bienes_de_consumo_para_consumir", ["bien_de_consumo_id"], name: "index_bienes_de_consumo_para_consumir_on_bien_de_consumo_id", using: :btree
  add_index "bienes_de_consumo_para_consumir", ["consumo_directo_id"], name: "index_bienes_de_consumo_para_consumir_on_consumo_directo_id", using: :btree
  add_index "bienes_de_consumo_para_consumir", ["deposito_id"], name: "index_bienes_de_consumo_para_consumir_on_deposito_id", using: :btree

  create_table "bienes_de_consumo_para_transferir", force: :cascade do |t|
    t.decimal  "costo"
    t.integer  "cantidad"
    t.integer  "bien_de_consumo_id"
    t.integer  "transferencia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
  end

  add_index "bienes_de_consumo_para_transferir", ["bien_de_consumo_id"], name: "index_bienes_de_consumo_para_transferir_on_bien_de_consumo_id", using: :btree
  add_index "bienes_de_consumo_para_transferir", ["deposito_id"], name: "index_bienes_de_consumo_para_transferir_on_deposito_id", using: :btree
  add_index "bienes_de_consumo_para_transferir", ["transferencia_id"], name: "index_bienes_de_consumo_para_transferir_on_transferencia_id", using: :btree

  create_table "clases", force: :cascade do |t|
    t.string   "codigo",             limit: 5
    t.string   "nombre"
    t.integer  "partida_parcial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha_de_baja"
  end

  add_index "clases", ["partida_parcial_id"], name: "index_clases_on_partida_parcial_id", using: :btree

  create_table "consumos_directo", force: :cascade do |t|
    t.date     "fecha"
    t.integer  "area_id"
    t.integer  "obra_proyecto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consumos_directo", ["area_id"], name: "index_consumos_directo_on_area_id", using: :btree
  add_index "consumos_directo", ["obra_proyecto_id"], name: "index_consumos_directo_on_obra_proyecto_id", using: :btree

  create_table "costos_de_bien_de_consumo", force: :cascade do |t|
    t.date     "fecha"
    t.integer  "bien_de_consumo_id"
    t.decimal  "costo"
    t.string   "usuario"
    t.integer  "origen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "costos_de_bien_de_consumo", ["bien_de_consumo_id"], name: "index_costos_de_bien_de_consumo_on_bien_de_consumo_id", using: :btree

  create_table "costos_de_bien_de_consumo_historico", force: :cascade do |t|
    t.date     "fecha"
    t.integer  "bien_de_consumo_id"
    t.decimal  "costo"
    t.string   "usuario"
    t.integer  "origen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "costos_de_bien_de_consumo_historico", ["bien_de_consumo_id"], name: "index_costos_de_bien_de_consumo_historico_on_bien_de_consumo_id", using: :btree

  create_table "depositos", force: :cascade do |t|
    t.integer  "area_id"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "depositos", ["area_id"], name: "index_depositos_on_area_id", using: :btree

  create_table "documentos_de_recepcion", force: :cascade do |t|
    t.integer  "tipo_de_documento_id"
    t.string   "numero_de_documento"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documentos_de_recepcion", ["tipo_de_documento_id"], name: "index_documentos_de_recepcion_on_tipo_de_documento_id", using: :btree

  create_table "documentos_principal", force: :cascade do |t|
    t.integer  "documento_de_recepcion_id"
    t.integer  "recepcion_de_bien_de_consumo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documentos_principal", ["documento_de_recepcion_id"], name: "index_documentos_principal_on_documento_de_recepcion_id", using: :btree
  add_index "documentos_principal", ["recepcion_de_bien_de_consumo_id"], name: "index_documentos_principal_on_recepcion_de_bien_de_consumo_id", using: :btree

  create_table "documentos_secundario", force: :cascade do |t|
    t.integer  "documento_de_recepcion_id"
    t.integer  "recepcion_de_bien_de_consumo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documentos_secundario", ["documento_de_recepcion_id"], name: "index_documentos_secundario_on_documento_de_recepcion_id", using: :btree
  add_index "documentos_secundario", ["recepcion_de_bien_de_consumo_id"], name: "index_documentos_secundario_on_recepcion_de_bien_de_consumo_id", using: :btree

  create_table "incisos", force: :cascade do |t|
    t.string   "codigo",     limit: 1
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingreso_manual_a_stocks", force: :cascade do |t|
    t.date     "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_stock_a_fechas", force: :cascade do |t|
    t.integer  "bien_de_consumo_id"
    t.decimal  "costo"
    t.integer  "cantidad"
    t.integer  "deposito_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_stock_a_fechas", ["bien_de_consumo_id"], name: "index_item_stock_a_fechas_on_bien_de_consumo_id", using: :btree
  add_index "item_stock_a_fechas", ["deposito_id"], name: "index_item_stock_a_fechas_on_deposito_id", using: :btree

  create_table "items_stock", force: :cascade do |t|
    t.integer  "bien_de_consumo_id"
    t.decimal  "cantidad"
    t.integer  "costo_de_bien_de_consumo_id"
    t.integer  "deposito_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items_stock", ["bien_de_consumo_id"], name: "index_items_stock_on_bien_de_consumo_id", using: :btree
  add_index "items_stock", ["costo_de_bien_de_consumo_id"], name: "index_items_stock_on_costo_de_bien_de_consumo_id", using: :btree
  add_index "items_stock", ["deposito_id"], name: "index_items_stock_on_deposito_id", using: :btree
  add_index "items_stock", ["ingreso_manual_a_stock_id"], name: "index_items_stock_on_ingreso_manual_a_stock_id", using: :btree

  create_table "obras_proyectos", force: :cascade do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partidas_parciales", force: :cascade do |t|
    t.string   "codigo",               limit: 1
    t.string   "nombre"
    t.integer  "partida_principal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partidas_parciales", ["partida_principal_id"], name: "index_partidas_parciales_on_partida_principal_id", using: :btree

  create_table "partidas_principales", force: :cascade do |t|
    t.string   "codigo",     limit: 1
    t.string   "nombre"
    t.integer  "inciso_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partidas_principales", ["inciso_id"], name: "index_partidas_principales_on_inciso_id", using: :btree

  create_table "personas", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recepciones_de_bien_de_consumo", force: :cascade do |t|
    t.datetime "fecha"
    t.integer  "estado"
    t.text     "descripcion_provisoria"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descripcion_rechazo"
  end

  create_table "reemplazos_bdc", force: :cascade do |t|
    t.integer  "bdc_viejo_id"
    t.integer  "bdc_nuevo_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "reemplazos_bdc", ["bdc_nuevo_id"], name: "index_reemplazos_bdc_on_bdc_nuevo_id", using: :btree
  add_index "reemplazos_bdc", ["bdc_viejo_id", "bdc_nuevo_id"], name: "index_reemplazos_bdc_on_bdc_viejo_id_and_bdc_nuevo_id", unique: true, using: :btree
  add_index "reemplazos_bdc", ["bdc_viejo_id"], name: "index_reemplazos_bdc_on_bdc_viejo_id", using: :btree

  create_table "reemplazos_clase", force: :cascade do |t|
    t.integer  "clase_vieja_id"
    t.integer  "clase_nueva_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reemplazos_clase", ["clase_nueva_id"], name: "index_reemplazos_clase_on_clase_nueva_id", using: :btree
  add_index "reemplazos_clase", ["clase_vieja_id", "clase_nueva_id"], name: "index_reemplazos_clase_on_clase_vieja_id_and_clase_nueva_id", unique: true, using: :btree
  add_index "reemplazos_clase", ["clase_vieja_id"], name: "index_reemplazos_clase_on_clase_vieja_id", using: :btree

  create_table "reportes_a_fecha", force: :cascade do |t|
    t.date     "fecha"
    t.text     "stock_diario"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipos_de_documentos", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transferencias", force: :cascade do |t|
    t.date     "fecha"
    t.integer  "area_id"
    t.integer  "deposito_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transferencias", ["area_id"], name: "index_transferencias_on_area_id", using: :btree
  add_index "transferencias", ["deposito_id"], name: "index_transferencias_on_deposito_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "bienes_de_consumo", "clases"
  add_foreign_key "clases", "partidas_parciales"
  add_foreign_key "items_stock", "ingreso_manual_a_stocks"
  add_foreign_key "partidas_parciales", "partidas_principales"
  add_foreign_key "partidas_principales", "incisos"
end
