class TipoDeDocumento < ActiveRecord::Base
		validates :nombre, presence: true
end
