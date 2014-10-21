require 'spec_helper'

describe RecepcionDeBienDeConsumo do
  	before do
  		@recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.create!(estado:1, fecha: DateTime.now) 
  		@doc_de_recepcion = @recepcion_de_bien_de_consumo.build_documento_de_recepcion(numero_de_documento:"2")
  	end

	subject { @recepcion_de_bien_de_consumo }

  	it { should validate_presence_of(:fecha) }
  	it { should validate_presence_of(:estado) }
  	it { should respond_to(:documento_de_recepcion) }
end
