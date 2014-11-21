require 'spec_helper'

describe ConsumoDirecto do

	before do
		@obra_proyecto = ObraProyecto.create!(codigo:"01", descripcion:"gestion teatral")
		@consumo = ConsumoDirecto.create!(area:"sistemas", fecha:DateTime.now, obra_proyecto:@obra_proyecto) 
	end

	subject { @consumo }

	it { should validate_presence_of(:fecha) }
	it { should validate_presence_of(:area) }
	it { should validate_presence_of(:obra_proyecto) }	

	 describe "relaciones" do
		describe "bien de consumo para consumir" do
	 		before do	 				 	
	 			@bien_de_consumo = BienDeConsumo.create!(nombre: "silla", codigo: "silla 34ED")
	 			@obra_proyecto = ObraProyecto.create!(codigo: "01", descripcion:"gestion teatral")
		        @consumo = ConsumoDirecto.create!(area:"sistemas", fecha: DateTime.now, obra_proyecto:@obra_proyecto) 	 				 			
	 			@bien_de_consumo_para_consumir = @consumo.bienes_de_consumo_para_consumir.create!(cantidad: 21, costo:452)
				@bien_de_consumo_para_consumir.bien_de_consumo = @bien_de_consumo
	 		end

	 		it { 
	 			@consumo.bien_de_consumo_para_consumir.bien_de_consumo.id.should ==  @bien_de_consumo.id 
	 		}
	 	end
    end
end

