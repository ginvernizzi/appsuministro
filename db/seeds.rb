#encoding: utf-8
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

Persona.create!(nombre: "Christian", apellido:" Fincic" ).save
Persona.create!(nombre: "Ana", apellido:"Salanitro").save
Persona.create!(nombre: "Diego", apellido:"Tanel").save
Persona.create!(nombre: "Paula", apellido:"Trabatoni").save

TipoDeDocumento.new(nombre: "factura").save
TipoDeDocumento.new(nombre: "orden de compra").save

######################## arbol ########################
@inciso_2 = Inciso.create!(nombre: "bienes de consumo", codigo:"2")

@partida_principal_1 = PartidaPrincipal.create!(nombre: "Productos alimenticios agropecuarios y forestales", codigo:"1", inciso:@inciso_2)

@partida_parcial_1 = PartidaParcial.create!(nombre: "Alimentos para personas", codigo:"1", partida_principal:@partida_principal_1)
@partida_parcial_2 = PartidaParcial.create!(nombre: "Alimentos para animales", codigo:"2", partida_principal:@partida_principal_1)
@partida_parcial_3 = PartidaParcial.create!(nombre: "Productos pecuarios", codigo:"3", partida_principal:@partida_principal_1)
@partida_parcial_4 = PartidaParcial.create!(nombre: "Productos agroforestales", codigo:"4", partida_principal:@partida_principal_1)
@partida_parcial_5 = PartidaParcial.create!(nombre: "Madera, corcho y sus manufacturas", codigo:"5", partida_principal:@partida_principal_1)
@partida_parcial_6 = PartidaParcial.create!(nombre: "Otros no especificados precedentemente (n.e.p.)", codigo:"9", partida_principal:@partida_principal_1)

@partida_principal_2 = PartidaPrincipal.create!(nombre: "Textiles y vestuario", codigo:"2", inciso:@inciso_2)

@partida_parcial_7 = PartidaParcial.create!(nombre: "Hilados y telas", codigo:"1", partida_principal:@partida_principal_2)
@partida_parcial_8 = PartidaParcial.create!(nombre: "Prendas de vestir", codigo:"2", partida_principal:@partida_principal_2)
@partida_parcial_9 = PartidaParcial.create!(nombre: "Confecciones textiles", codigo:"3", partida_principal:@partida_principal_2)
@partida_parcial_10 = PartidaParcial.create!(nombre: "Otros n.e.p.", codigo:"9", partida_principal:@partida_principal_2)

@partida_principal_3 = PartidaPrincipal.create!(nombre: "Productos de papel, carton e impresos", codigo:"3", inciso:@inciso_2)

@partida_parcial_11 = PartidaParcial.create!(nombre: "Papel de escritorio y carton", codigo:"1", partida_principal:@partida_principal_3)
@partida_parcial_12 = PartidaParcial.create!(nombre: "Papel de computacion", codigo:"2", partida_principal:@partida_principal_3)
@partida_parcial_13 = PartidaParcial.create!(nombre: "Prdocutos de artes graficas", codigo:"3", partida_principal:@partida_principal_3)
@partida_parcial_14 = PartidaParcial.create!(nombre: "Productos de cartel y carton", codigo:"4", partida_principal:@partida_principal_3)
@partida_parcial_15 = PartidaParcial.create!(nombre: "Libros, revistas y periodicos", codigo:"5", partida_principal:@partida_principal_3)
@partida_parcial_16 = PartidaParcial.create!(nombre: "Textos de enseñanza", codigo:"6", partida_principal:@partida_principal_3)
@partida_parcial_17 = PartidaParcial.create!(nombre: "Especies timbradas y valores", codigo:"7", partida_principal:@partida_principal_3)
@partida_parcial_18 = PartidaParcial.create!(nombre: "Otros n.e.p.", codigo:"9", partida_principal:@partida_principal_3)

##############################################################################################################

@clase_1 = Clase.create!(nombre: "clase 1", codigo:"00000", partida_parcial:@partida_parcial_6)

##############################################################################################################

@bien_de_consumo_1 = BienDeConsumo.create!(nombre: "mouse optico", codigo: "1111", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_2 = BienDeConsumo.create!(nombre: "tijera", codigo: "2222", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_3 = BienDeConsumo.create!(nombre: "resma hojas A4 x 5", codigo: "3333", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_4 = BienDeConsumo.create!(nombre: "indebleble negro", codigo: "4444", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_5 = BienDeConsumo.create!(nombre: "fibron pizarra rojo", codigo: "5555", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_6 = BienDeConsumo.create!(nombre: "fibron pizarra verde", codigo: "6666", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_7 = BienDeConsumo.create!(nombre: "fibron pizarra azul", codigo: "7777", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_8 = BienDeConsumo.create!(nombre: "Goma lapiz", codigo: "8888", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_9 = BienDeConsumo.create!(nombre: "abrochadora", codigo: "9999", clase:@clase_1, stock_minimo: 0).save
@bien_de_consumo_000 = BienDeConsumo.create!(nombre: "escuadra", codigo: "0000", clase:@clase_1, stock_minimo: 0).save

######################################################################################################

ObraProyecto.create!(descripcion: "gestion/proyecto").save
ObraProyecto.create!(descripcion: "cartas del ausente").save

areaSuministro = Area.create!(nombre: 'Patrimonio y Suministro', responsable:'Ana Salanitro')
	Deposito.create!(area_id: areaSuministro.id, nombre:'piso -1')
areaSistemas = Area.create!(nombre: 'Sistemas', responsable:'Christian Fincic')
	Deposito.create!(area_id: areaSistemas.id, nombre:'piso 10')
	Deposito.create!(area_id: areaSistemas.id, nombre:'piso 3')
areaAuditoria = Area.create!(nombre: 'Auditoria', responsable:'Fernandez')
areaSistemas = Area.create!(nombre: 'Legales', responsable:'lopez')


#Gereador de bienes
# @clase = Clase.first
# for i in 10..99
#   BienDeConsumo.create!(nombre: "polenta"+i.to_s, codigo: "00"+i.to_s, clase: @clase , stock_minimo: 150).save
# end

    #Gereador de clases
# @partida = PartidaParcial.first
# for i in 10..99
#    Clase.create!(nombre: "classs"+i.to_s, codigo: "000"+i.to_s, partida_parcial: @partida).save
# end









