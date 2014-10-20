require 'spec_helper'

describe RecepcionDeBienDeConsumo do
  	before {
  		@recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new 
  	}

	subject { @recepcion_de_bien_de_consumo }

  	it { should validate_presence_of(:fecha) }
  	it { should validate_presence_of(:estado) }
end
