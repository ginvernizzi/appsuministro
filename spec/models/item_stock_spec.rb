require 'spec_helper'

describe ItemStock do
  	before {  		
      @bien_de_consumo = BienDeConsumo.create!(nombre: "silla", codigo: "silla 34ED")
      @deposito = Deposito.create!(nombre: 'piso 3', area: @area)   
      @costo = CostoDeBienDeConsumo.create!(bien_de_consumo: @bien_de_consumo, fecha: DateTime.now, costo: '23', usuario: 'gsantacruz', origen: '1')
  		@area = Area.create!(nombre: 'sistemas', responsable: 'fincic')  	  		  		
  		@item_stock = ItemStock.create!(bien_de_consumo: @bien_de_consumo, cantidad: '23', costo_de_bien_de_consumo: @costo, 
                                      deposito: @deposito)  		
  	}

	subject { @item_stock }

    it { should respond_to(:cantidad) }
  	it { should respond_to(:costo_de_bien_de_consumo) }
  	it { should respond_to(:bien_de_consumo) }
  	it { should respond_to(:deposito) }
end
