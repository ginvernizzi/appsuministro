class RecepcionDeBienDeConsumo < ActiveRecord::Base
  belongs_to :documento_de_recepcion  

  #No cambiar los values o keys, y sus ordenes
  ESTADOS = { :definitiva => 1, :provisoria => 2 , :"pendiente de evaluacion" => 3, :rechazada => 4, :"consumo directo" => 5, :"En stock" => 6 }

  has_many :bienes_de_consumo_de_recepcion

  has_one :documento_principal

  has_many :documentos_secundario 

  validates :fecha, presence: true
  validates :estado, presence: true, :inclusion => { :in => self::ESTADOS.values }  
  validates :documento_principal, presence: true

  validates_associated :documento_principal      

  ################# NEW #################
  #accepts_nested_attributes_for :bienes_de_consumo_de_recepcion, :allow_destroy => true
  #validates_associated :bienes_de_consumo_de_recepcion

  # def bienes_de_consumo_de_recepcion_attributes=(attributes)
  #   bienes_de_consumo_de_recepcion.create!(attributes)
  # end
end
