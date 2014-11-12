# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "ana", email: "ana@tnc.gob.ar", password: "123456").save
User.create!(name: "jorge", email: "jorge@tnc.gob.ar", password: "123456").save

TipoDeDocumento.create!(nombre: "factura").save
TipoDeDocumento.create!(nombre: "orden de compra").save

BienDeConsumo.create!(nombre: "mouse optico", codigo: "1111").save
BienDeConsumo.create!(nombre: "tijera", codigo: "2222").save
BienDeConsumo.create!(nombre: "resma hojas A4 x 5", codigo: "3333").save
BienDeConsumo.create(nombre: "indebleble negro", codigo: "4444").save
BienDeConsumo.create!(nombre: "fibron pizarra rojo", codigo: "5555").save
BienDeConsumo.create!(nombre: "fibron pizarra verde", codigo: "6666").save
BienDeConsumo.create!(nombre: "fibron pizarra azul", codigo: "7777").save




