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
  attr_accessor :subtotal

  #scope :name, joins(:table).where('.field = ?', 'value')
  scope :bien_de_consumo_para_consumir, ->(estado_activo, obra_proyecto_id, fecha_inicio, fecha_fin) { joins(:consumo_directo => [:area]).
  where("consumos_directo.estado = ? AND consumos_directo.obra_proyecto_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", estado_activo, obra_proyecto_id, fecha_inicio, fecha_fin) }

  def lista_final_con_subtotales(lista_de_consumos_por_obra_proyecto, subtotales_x_area_destino)
    @lista_final = Array.new
    area_id_actual = lista_de_consumos_por_obra_proyecto.first.consumo_directo.area.id
    lista_de_consumos_por_obra_proyecto.each do |bien|
          if bien.consumo_directo.area.id == area_id_actual
              @lista_final << bien
          else
              subtotal_del_area = subtotales_x_area_destino.select {|e| e.area_id == area_id_actual}[0].subtotal
              @lista_final.last.update(subtotal: subtotal_del_area)

              area_id_actual = bien.consumo_directo.area.id
              @lista_final << bien
              
              if bien.id == lista_de_consumos_por_obra_proyecto.last.id
                subtotal_del_area = subtotales_x_area_destino.select {|e| e.area_id == bien.consumo_directo.area.id}[0].subtotal
                @lista_final.last.update(subtotal: subtotal_del_area)
              end
          end
    end
    return @lista_final
  end



  def costo_total
      self.cantidad * costo
  end

#  scope :created_before, ->(time) { where("created_at < ?", time) }
end
