require 'spec_helper'

describe TipoDeDocumento do
    before {
  		@tipo_de_docuemento = TipoDeDocumento.new 
  	}

	subject { @tipo_de_docuemento }

  	it { should validate_presence_of(:nombre) }
end
