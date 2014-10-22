require 'spec_helper'

describe DocumentoPrincipal do

	before do
		@tdd1 = TipoDeDocumento.create!(nombre: "factura")
		#@tdd2 = TipoDeDocumento.create!(nombre: "remito")

		@doc_recepcion1 = DocumentoDeRecepcion.create!(numero_de_documento: "1", tipo_de_documento: @tdd1)
		#@doc_recepcion2 = DocumentoRecepcion.create!(numero_de_documento: "2", tipo_de_documento: @tdd2)


		@docPrincipal = DocumentoPrincipal.create!(documento_de_recepcion:@doc_recepcion1, 
			                                       recepcion_de_bien_de_consumo: @rbc) 
				
	end

	subject { @docPrincipal }
	
	it { should respond_to(:documento_de_recepcion) }
	it { should respond_to(:recepcion_de_bien_de_consumo) }

	describe "relaciones" do
	 	describe "documento principal" do
	 		before do

	 			@rbc = RecepcionDeBienDeConsumo.create!(fecha:DateTime.now, estado:1)

	 			@tddr = TipoDeDocumento.create!(nombre: "remito")	 			
	 			@docRecepcion1 = DocumentoDeRecepcion.create!(numero_de_documento: "1", tipo_de_documento: @tddr)

	 			@docPrincipal = DocumentoPrincipal.create!(documento_de_recepcion:@docRecepcion1, 
			                                       recepcion_de_bien_de_consumo: @rbc)
	 		end
     		it { 
	 			#@docPrincipal.recepcion_de_bien_de_consumo.id.should ==  @recepcion_de_bien_de_consumo.id 
	 			@rbc.documento_principal.id.should == @docPrincipal.id
	 		}

	 		it { 
	 			@docPrincipal.documento_de_recepcion.id.should ==  @docRecepcion1.id 	 			
	 		}
	 	end

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
	end
end

