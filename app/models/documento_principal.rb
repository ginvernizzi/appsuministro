class DocumentoPrincipal < ActiveRecord::Base
  belongs_to :documento_de_recepcion
  belongs_to :recepcion_de_bien_de_consumo  

  validates :documento_de_recepcion, presence: true
end
