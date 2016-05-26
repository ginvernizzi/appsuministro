class RecepcionDeBienDeConsumo < ActiveRecord::Base
  belongs_to :documento_de_recepcion  
  #has_one :recepcion_para_consumo_directo

  #No cambiar los values o keys, y sus ordenes
  ESTADOS = { :DEFINITIVA => 1, :PROVISORIA => 2 , :"PENDIENTE DE EVALUACION" => 3, :RECHAZADA => 4, :"ANULADA" => 7, :FINALIZADA => 8  }

  has_many :bienes_de_consumo_de_recepcion

  has_one :documento_principal

  has_many :documentos_secundario 
  has_and_belongs_to_many :consumos_directo, :class_name => 'ConsumoDirecto'

  validates :fecha, presence: true
  validates :estado, presence: true, :inclusion => { :in => self::ESTADOS.values }  
  validates :documento_principal, presence: true

  validates_associated :documento_principal  

  attr_accessor :fecha_inicio_impresion
  attr_accessor :fecha_fin_impresion 
  attr_accessor :bien_de_consumo_id 
     
end
