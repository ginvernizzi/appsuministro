require 'spec_helper'

describe Transferencia do
	before do
		@area = Area.create!(nombre:"sistemas", responsable:"fincic")
		@deposito10 = Deposito.create!(area:@area, nombre:'piso 10')
		@deposito3 = Deposito.create!(area:@area, nombre:'piso 3')		
		@transferencia = Transferencia.create!(area:@area, deposito: @deposito10, fecha:DateTime.now) 
	end

	subject { @transferencia }

	it { should validate_presence_of(:fecha) }
	it { should validate_presence_of(:area) }
	it { should validate_presence_of(:deposito) }	
	
	 describe "relaciones" do
		describe "bien de consumo para transferir" do
	 		before do	 				 	
	 			@bien_de_consumo = BienDeConsumo.create!(nombre: "silla", codigo: "silla 34ED")
	 			
	 			@area = Area.create!(nombre:"sistemas", responsable:"fincic")
				@deposito10 = Deposito.create!(area: @area, nombre:'piso 10')
				@deposito3 = Deposito.create!(area: @area, nombre:'piso 3')

		        @transferencia2 = Transferencia.create!(area:@area, deposito: @deposito10, fecha:DateTime.now) 
	 			@bien_de_consumo_para_transferir = @transferencia2.bienes_de_consumo_para_transferir.build(bien_de_consumo:@bien_de_consumo, cantidad: 21, costo:452)
	 		end

			it { 
	 			@transferencia2.bienes_de_consumo_para_transferir.bien_de_consumo.id.should == @bien_de_consumo.id 
	 			@transferencia2.bienes_de_consumo_para_transferir.find(@bien_de_consumo_para_transferir.id).bien_de_consumo.id.should == @bien_de_consumo.id 
	 		}
	 	end
    end
end

