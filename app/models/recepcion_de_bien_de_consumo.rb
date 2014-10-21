class RecepcionDeBienDeConsumo < ActiveRecord::Base
  belongs_to :documento_de_recepcion

  has_and_belongs_to_many :documentos_de_recepcion, :join_table => "documentos_de_recepcion_recepciones_de_bien_de_consumo"

  has_many :bienes_de_consumo_de_recepcion

  validates :fecha, presence: true
  validates :estado, presence: true 

  ESTADOS = { :definitiva => 1, :provisoria => 2 }
 
 #RecepcionDeBienDeConsumo::ESTADOS
 #para acceder: RecepcionDeBienDeConsumo::ESTADOS.key(recepcion_de_bien_de_consumo.estado)

end
