require 'spec_helper'

describe Deposito do
  	before do
		@deposito = Deposito.create!(nombre:"piso10") 
	end

	subject { @deposito }

	it { should validate_presence_of(:nombre) }		

end
