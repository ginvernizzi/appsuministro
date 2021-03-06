require 'spec_helper'

describe DocumentoSecundario do
	before do
		@tddf = TipoDeDocumento.create!(nombre: "factura")
		@tddr = TipoDeDocumento.create!(nombre: "remito")

		@doc_recepcion1 = DocumentoDeRecepcion.create!(numero_de_documento: "1", tipo_de_documento: @tddf)
		@doc_recepcion2 = DocumentoDeRecepcion.create!(numero_de_documento: "2", tipo_de_documento: @tddr)

		@docSecundario = DocumentoSecundario.create!(documento_de_recepcion:@doc_recepcion2, 
			                                       recepcion_de_bien_de_consumo: @rbc) 
				
	end

	subject { @docSecundario }
	
	it { should respond_to(:documento_de_recepcion) }
	it { should respond_to(:recepcion_de_bien_de_consumo) }

	describe "relaciones" do
	 	describe "documentos secundarios" do
	 		before do
 				@tddr = TipoDeDocumento.create!(nombre: "remito")	 			
				@tddf = TipoDeDocumento.create!(nombre: "factura")	
				 		
				@rbc = RecepcionDeBienDeConsumo.create!(fecha:DateTime.now, estado:1)					

				@docRecepcion2 = DocumentoDeRecepcion.create!(numero_de_documento: "2", tipo_de_documento: @tddf)
	 			@docRecepcion3 = DocumentoDeRecepcion.create!(numero_de_documento: "11", tipo_de_documento: @tddf)

	 			@docSecundario1 = @rbc.documentos_secundario.create!(documento_de_recepcion:@docRecepcion2,
	 																 recepcion_de_bien_de_consumo: @rbc)

	 			@docSecundario2 = @rbc.documentos_secundario.create!(documento_de_recepcion:@docRecepcion3,
	 																 recepcion_de_bien_de_consumo: @rbc) 

	 		end
     		it { 
	 			doc_rec2 = @rbc.documentos_secundario.find(@docSecundario1.id).documento_de_recepcion
	 			doc_rec2.tipo_de_documento.nombre.should == "factura"
	 		}

	 		it {
	 			doc_rec3 = @rbc.documentos_secundario.find(@docSecundario2.id).documento_de_recepcion
	 			doc_rec3.tipo_de_documento.nombre.should == "factura"
	 		}
	 		
	 	end
	end
end
