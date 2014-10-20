class RecepcionDeBienDeConsumo < ActiveRecord::Base
  belongs_to :documento_de_recepcion

  has_and_belongs_to_many :documentos_de_recepcion

  has_many :bienes_de_consumo_de_recepcion
end
