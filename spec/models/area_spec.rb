require 'spec_helper'

describe Area do

	before do
		@area = Area.create!(nombre:"suministro", responsable: "fincic") 
	end

	subject { @area }

	it { should validate_presence_of(:nombre) }
	it { should validate_presence_of(:responsable) }
	it { should respond_to(:depositos) }	

	 describe "relaciones" do
		describe "depositos" do
	 		before do	 				 	

	 			@area = Area.create!(nombre:"suministro", responsable: "fincic") 

	 			#@deposito = @area.create_deposito(nombre: "piso 10")
	 		end	 		
	 	end
    end
end        
