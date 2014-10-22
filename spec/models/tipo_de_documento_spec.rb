require 'spec_helper'

describe TipoDeDocumento do
    before {
  		@tipo_de_documento = TipoDeDocumento.new 
  	}

	subject { @tipo_de_documento }

  	it { should validate_presence_of(:nombre) }
end
