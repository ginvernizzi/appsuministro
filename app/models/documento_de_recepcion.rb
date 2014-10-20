class DocumentoDeRecepcion < ActiveRecord::Base
  belongs_to :tipo_de_documento

  has_and_belongs_to_many :recepciones_de_bien_de_consumo
end
