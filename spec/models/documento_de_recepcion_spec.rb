require 'spec_helper'

describe DocumentoDeRecepcion do

  	before do
		@tdd = TipoDeDocumento.create!(nombre: "factura")
		@doc_recepcion = DocumentoDeRecepcion.create!(numero_de_documento: "28803436", tipo_de_documento: @tdd)
	  end

	subject { @doc_recepcion }
  	
  	it { should respond_to(:numero_de_documento) }
  	it { should respond_to(:tipo_de_documento) }

  	it { @doc_recepcion.tipo_de_documento_id.should == @tdd.id }

  	it { should be_valid }
end
