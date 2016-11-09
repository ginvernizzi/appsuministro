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

  #scope :name, joins(:table).where('.field = ?', 'value')
  scope :bien_de_consumo_para_consumir, ->(estado_activo, obra_proyecto_id, fecha_inicio, fecha_fin) { joins(:consumo_directo).where("consumos_directo.estado = ? AND consumos_directo.obra_proyecto_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", estado_activo, obra_proyecto_id, fecha_inicio, fecha_fin) }
#BienDeConsumoParaConsumir.joins(:consumo_directo).where("consumos_directo.estado = ? AND consumos_directo.obra_proyecto_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", estado_activo, obra_proyecto_id, fecha_inicio, fecha_fin)


#  scope :created_before, ->(time) { where("created_at < ?", time) }
end
