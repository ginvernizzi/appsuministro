require 'spec_helper'

describe BienDeConsumo do
  	before {
  		@bien_de_consumo = BienDeConsumo.new 
  	}

	subject { @bien_de_consumo }

  	it { should respond_to(:nombre)}
  	it { should respond_to(:codigo)}
  	it { should validate_presence_of(:nombre) }
  	it { should validate_presence_of(:codigo) }
end

