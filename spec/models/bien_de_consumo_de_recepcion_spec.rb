require 'spec_helper'

describe BienDeConsumoDeRecepcion do
	before {  		
  		@bien_de_consumo = BienDeConsumo.create!(nombre: "silla", codigo: "silla 34ED")

  		@recepcion_de_bien_consumo = RecepcionDeBienDeConsumo.create!(estado:1, fecha: DateTime.now)
  		@bien_de_consumo_de_recepcion = @recepcion_de_bien_consumo.bienes_de_consumo_de_recepcion.create!(cantidad: 21, costo:452)
		@bien_de_consumo_de_recepcion.bien_de_consumo = @bien_de_consumo
  	}

	subject { @bien_de_consumo_de_recepcion }

    it { should respond_to(:cantidad) }
  	it { should respond_to(:costo) }

  	it { should respond_to(:bien_de_consumo) }
  	it { should respond_to(:recepcion_de_bien_de_consumo) }
end