require 'spec_helper'

describe BienDeConsumoParaConsumir do
	before {  		
  		@bien_de_consumo = BienDeConsumo.create!(nombre: "silla", codigo: "silla 34ED")
  		@obra_proyecto =  ObraProyecto.create!(codigo:"01", descripcion:"obra/proyecto")

  		@consumo = ConsumoDirecto.create!(fecha:DateTime.now, area:"sistemas", obra_proyecto:@obra_proyecto)
  		@bien_de_consumo_para_consumir = @consumo.bienes_de_consumo_para_consumir.create!(cantidad: 21, costo:452)
		@bien_de_consumo_para_consumir.bien_de_consumo = @bien_de_consumo
  	}

	subject { @bien_de_consumo_para_consumir }

    it { should respond_to(:cantidad) }
  	it { should respond_to(:costo) }

  	it { should respond_to(:bien_de_consumo) }
  	it { should respond_to(:consumo_directo) }
end