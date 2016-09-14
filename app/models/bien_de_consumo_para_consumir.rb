class BienDeConsumoParaConsumir < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :consumo_directo
  belongs_to :deposito

  attr_accessor :fecha_inicio_impresion
  attr_accessor :fecha_fin_impresion
  attr_accessor :ppal_impresion
  attr_accessor :area_id_impresion
  attr_accessor :obra_proyecto_impresion
  attr_accessor :clase_impresion
  attr_accessor :descripcion_de_recepcion
  attr_accessor :bien_id_impresion
end
