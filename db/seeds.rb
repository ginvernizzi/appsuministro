# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "ana", email: "ana@tnc.gob.ar", password: "123456").save
User.create!(name: "jorge", email: "jorge@tnc.gob.ar", password: "123456").save
User.create!(name: "ricardo", email: "ricardo@tnc.gob.ar", password: "123456").save

TipoDeDocumento.new(nombre: "factura").save
TipoDeDocumento.new(nombre: "orden de compra").save

@bien_de_consumo_1 = BienDeConsumo.create!(nombre: "mouse optico", codigo: "1111").save
@bien_de_consumo_2 = BienDeConsumo.create!(nombre: "tijera", codigo: "2222").save
@bien_de_consumo_3 = BienDeConsumo.create!(nombre: "resma hojas A4 x 5", codigo: "3333").save
@bien_de_consumo_4 = BienDeConsumo.create!(nombre: "indebleble negro", codigo: "4444").save
@bien_de_consumo_5 = BienDeConsumo.create!(nombre: "fibron pizarra rojo", codigo: "5555").save
@bien_de_consumo_6 = BienDeConsumo.create!(nombre: "fibron pizarra verde", codigo: "6666").save
@bien_de_consumo_7 = BienDeConsumo.create!(nombre: "fibron pizarra azul", codigo: "7777").save
@bien_de_consumo_8 = BienDeConsumo.create!(nombre: "Goma lapiz", codigo: "8888").save
@bien_de_consumo_9 = BienDeConsumo.create!(nombre: "abrochadora", codigo: "9999").save
@bien_de_consumo_000 = BienDeConsumo.create!(nombre: "escuadra", codigo: "0000").save

ObraProyecto.create!(descripcion: "gestion/proyecto").save
ObraProyecto.create!(descripcion: "cartas del ausente").save

areaSuministro = Area.create!(nombre: 'Patrimonio y Suministro', responsable:'Ana Salanitro')
areaSistemas = Area.create!(nombre: 'Sistemas', responsable:'Christian Fincic')

Deposito.create!(area_id: areaSuministro.id, nombre:'piso -1')
Deposito.create!(area_id: areaSistemas.id, nombre:'piso 10')
Deposito.create!(area_id: areaSistemas.id, nombre:'piso 3')

###########################

# @recepcion_de_bien_de_consumo_1 = RecepcionDeBienDeConsumo.create!(fecha:DateTime.now, estado:3) 
    
# @tipo_doc_factura.save    
# @tddp = @tipo_doc_factura

# @docRecepcion_p = DocumentoDeRecepcion.create!(numero_de_documento: "288034355", tipo_de_documento: @tddp)

# @recepcion_de_bien_de_consumo_1.build_documento_principal(documento_de_recepcion:@docRecepcion_p, 
#                                                           recepcion_de_bien_de_consumo: @recepcion_de_bien_de_consumo_1)

# @recepcion_de_bien_de_consumo_1.bienes_de_consumo_de_recepcion.create!(cantidad: 100, costo:34, bien_de_consumo: @bien_de_consumo_1)
# @recepcion_de_bien_de_consumo_1.bienes_de_consumo_de_recepcion.create!(cantidad: 200, costo:35, bien_de_consumo: @bien_de_consumo_2)






