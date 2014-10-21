class DocumentoDeRecepcion < ActiveRecord::Base
  belongs_to :tipo_de_documento
  has_and_belongs_to_many :recepciones_de_bien_de_consumo, :join_table => "documentos_de_recepcion_recepciones_de_bien_de_consumo"
  has_one :recepcion_de_bien_de_consumo
  
  validates :numero_de_documento, presence: true
end
