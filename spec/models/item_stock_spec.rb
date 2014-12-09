require 'spec_helper'

describe ItemStock do
  	before {  		
  		@area = Area.create!(nombre: 'sistemas', responsable: 'fincic')  	
  		@bien_de_consumo = BienDeConsumo.create!(nombre: "silla", codigo: "silla 34ED")
  		@deposito = Deposito.create!(nombre: 'piso 3', area: @area)  	
  		@item_stock = ItemStock.create!(bien_de_consumo: @bien_de_consumo, cantidad: '23', costo: '45', deposito: @deposito)  		
  	}

	subject { @item_stock }

    it { should respond_to(:cantidad) }
  	it { should respond_to(:costo) }

  	it { should respond_to(:bien_de_consumo) }
  	it { should respond_to(:deposito) }
end
