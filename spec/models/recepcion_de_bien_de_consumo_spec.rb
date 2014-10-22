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

	 describe "relaciones" do
		describe "documento principal" do
	 		before do	 				 	

	 			@rbc = RecepcionDeBienDeConsumo.create!(fecha:DateTime.now, estado:1)		

	 			@tddr = TipoDeDocumento.create!(nombre: "remito")	 				 			

	 			@docRecepcion1 = DocumentoDeRecepcion.create!(numero_de_documento: "1", tipo_de_documento: @tddr)

	 			@documentoPpal = @rbc.create_documento_principal(documento_de_recepcion:@docRecepcion1, 
			                                                      recepcion_de_bien_de_consumo: @rbc)
	 		end

	 		it { 
	 			@rbc.documento_principal.documento_de_recepcion.id.should ==  @docRecepcion1.id 
	 		}
	 	end

	 	describe "documentos secundarios" do
	 		before do	 				 	

	 			@rbc = RecepcionDeBienDeConsumo.create!(fecha:DateTime.now, estado:1)		

	 			@tddr = TipoDeDocumento.create!(nombre: "remito")	 				 			
	 			@tddf = TipoDeDocumento.create!(nombre: "factura")

	 			@docRecepcion1 = DocumentoDeRecepcion.create!(numero_de_documento: "1", tipo_de_documento: @tddf)
	 			@docRecepcion2 = DocumentoDeRecepcion.create!(numero_de_documento: "2", tipo_de_documento: @tddf)
	 			@docRecepcion3 = DocumentoDeRecepcion.create!(numero_de_documento: "3", tipo_de_documento: @tddr)

	 			@documentoPpal = @rbc.create_documento_principal(documento_de_recepcion:@docRecepcion1, 
			                                                     recepcion_de_bien_de_consumo: @rbc)

	 			@documentoSecundario1 = @rbc.documentos_secundario.create!(documento_de_recepcion:@docRecepcion2, 
			                                                               recepcion_de_bien_de_consumo: @rbc)

	 			@documentoSecundario2 = @rbc.documentos_secundario.create!(documento_de_recepcion:@docRecepcion3, 
			                                                               recepcion_de_bien_de_consumo: @rbc)
	 		end

	 		it { 
	 			@rbc.documentos_secundario.find(@documentoSecundario1.id).documento_de_recepcion.tipo_de_documento.nombre.should ==  "factura"	 		
	 		}

	 		it {
	 		    @rbc.documentos_secundario.find(@documentoSecundario2.id).documento_de_recepcion.tipo_de_documento.nombre.should ==  "remito"
	 		}
	 	end
    end
end
