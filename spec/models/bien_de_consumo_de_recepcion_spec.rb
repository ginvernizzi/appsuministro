require 'spec_helper'

describe BienDeConsumoDeRecepcion do
	before {
  		@bien_de_consumo_de_recepcion = BienDeConsumoDeRecepcion.new 
  	}

	subject { @bien_de_consumo_de_recepcion }

  	#it { should respond_to(:fecha)}
  	#it { should respond_to(:estado)}
  	
    it { should validate_presence_of(:cantidad) }
  	it { should validate_presence_of(:costo) }
end