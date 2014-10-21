require 'spec_helper'

describe DocumentoDeRecepcion do
  	before do
		@doc = DocumentoDeRecepcion.create!(numero_de_documento: "28803436")
		@tipo_de_doc = @doc.build_tipo_de_documento(nombre: "remito")
	end

	subject { @doc }
  	
  	it { should respond_to(:numero_de_documento) }
  	it { should respond_to(:tipo_de_documento) }

  	it { should be_valid }
end
