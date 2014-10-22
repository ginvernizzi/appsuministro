require 'spec_helper'

describe RecepcionDeBienDeConsumo do

	before do
		@recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.create!(estado:1, fecha: DateTime.now) 
	end

	subject { @recepcion_de_bien_de_consumo }

	it { should validate_presence_of(:fecha) }
	it { should validate_presence_of(:estado) }
	it { should respond_to(:documento_principal) }
	it { should respond_to(:documentos_secundario) }

	# describe "relaciones" do
	# 	describe "documento principal" do
	# 		before do
	# 			@tdd = TipoDeDocumento.create!(nombre: "factura")
	# 			@doc_de_recepcion = @recepcion_de_bien_de_consumo.create_documento_de_recepcion(numero_de_documento:"2", tipo_de_documento: @tdd)
	# 		end

	# 		it { 
	# 			@doc_de_recepcion.recepcion_de_bien_de_consumo.id.should ==  @recepcion_de_bien_de_consumo.id 
	# 		}
	# 	end

	# 	describe "documentos secundario" do
	# 		before do
	# 			@factura = TipoDeDocumento.create!(nombre: "factura")
	# 			@remito = TipoDeDocumento.create!(nombre: "remito")
	# 			@documentos_de_recepcion1 = @recepcion_de_bien_de_consumo.documentos_de_recepcion.create!(numero_de_documento:"2", tipo_de_documento: @factura)
	# 			@documentos_de_recepcion2 = @recepcion_de_bien_de_consumo.documentos_de_recepcion.create!(numero_de_documento:"2", tipo_de_documento: @remito)
	# 		end

	# 		it {
	# 			doc_rec = @recepcion_de_bien_de_consumo.documentos_de_recepcion.find(@documentos_de_recepcion1.id)
	# 			doc_rec.tipo_de_documento.nombre.should == "factura"
	# 		}

	# 		it {
	# 			doc_rec = @recepcion_de_bien_de_consumo.documentos_de_recepcion.find(@documentos_de_recepcion2.id)
	# 			doc_rec.tipo_de_documento.nombre.should == "remito"
	# 		}

	# 		it {
	# 			doc_rec = @recepcion_de_bien_de_consumo.documentos_de_recepcion.find(@documentos_de_recepcion2.id)
	# 			doc_rec.recepcion_de_bien_de_consumo.should be_nil
	# 		}


	# 	end
	# end
end
