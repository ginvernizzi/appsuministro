class ConsumoDirecto < ActiveRecord::Base
  belongs_to :obra_proyecto
  has_many :bienes_de_consumo_para_consumir

  validates :fecha, presence: true
  validates :area, presence: true
  validates :obra_proyecto, presence: true
end
