require 'spec_helper'

describe DocumentoDeRecepcion do
 	before {
  		@documento_de_recepcion = DocumentoDeRecepcion.new 
  	}

	subject { @documento_de_recepcion }

  	it { should validate_presence_of(:numero_de_documento) }
end
