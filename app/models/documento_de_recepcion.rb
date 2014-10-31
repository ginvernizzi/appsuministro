class DocumentoDeRecepcion < ActiveRecord::Base
  belongs_to :tipo_de_documento 
  has_one :recepcion_de_bien_de_consumo  

  validates :numero_de_documento, presence: true   
end
