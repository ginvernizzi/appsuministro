class ItemStock < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :bien_de_consumo
  belongs_to :deposito
  belongs_to :costo_de_bien_de_consumo
  belongs_to :ingreso_manual_a_stock

  validates :cantidad, presence: true
  # validates :costo_de_bien_de_consumo, presence: true
  validates :costo_de_bien_de_consumo_id, presence: true
  #accepts_nested_attributes_for :deposito
  attr_accessor :fecha_inicio_impresion
  attr_accessor :fecha_fin_impresion
  attr_accessor :area_id_impresion
  attr_accessor :bien_id_impresion
  attr_accessor :partida_parcial_impresion
  attr_accessor :subtotal

  def lista_final_con_subtotales(items_de_stock, subtotales_por_partida_parcial)
    @lista_final = Array.new
    pp_actual = obtener_codigo_de_partida_parcial(items_de_stock.first.bien_de_consumo.clase.partida_parcial.id)
    items_de_stock.each do |item|
          if obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id) == pp_actual
              @lista_final << item

              if item.id == items_de_stock.last.id #es el ultimo???
                puts "#{pp_actual}"
                subtotal_por_pp = subtotales_por_partida_parcial.select {|e| e.partida_parcial == obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)}[0].subtotal
                @lista_final.last.update(subtotal: subtotal_por_pp)
                return @lista_final
              end
          else
              subtotal_por_pp = subtotales_por_partida_parcial.select {|e| e.partida_parcial == pp_actual}[0].subtotal
              #test << "********* sub: #{subtotal_por_pp} /// pp: #{pp_actual}"
              @lista_final.last.update(subtotal: subtotal_por_pp)

              pp_actual = obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)
              #test << "********* sub: #{subtotal_por_pp} /// pp: #{pp_actual}"
              @lista_final << item

              if item.id == items_de_stock.last.id
                subtotal_por_pp = subtotales_por_partida_parcial.select {|e| e.partida_parcial == obtener_codigo_de_partida_parcial(items_de_stock.last.iem_de_consumo_id)}[0].subtotal
                #test << "********* sub: #{subtotal_por_pp} /// pp: #{pp_actual}"
                @lista_final.last.update(subtotal: subtotal_por_pp)
              end
          end
    end
    return @lista_final
  end

  # def lista_final_con_subtotales(items_de_stock, subtotales_por_partida_parcial)
  #   # puts "***********  *  **  * * *************** * * Subottales  * * ****  **  **  ****  ******  **  ************    * ****"
  #   # agua = Array.new
  #   # subtotales_por_partida_parcial.each do |item|
  #   #     agua << " pp: #{item.partida_parcial} // subtotal: #{item.subtotal} // veces: #{item.cantidad_pp}"
  #   # end
  #   # puts agua
  #   # puts "*** *** ***"
  #   # put "car"
  #   pp_actual = obtener_codigo_de_partida_parcial(items_de_stock.first.bien_de_consumo.clase.partida_parcial.id)
  #
  #   items_de_stock.each do |item|
  #         puts "partida: #{pp_actual}"
  #         if obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id) == pp_actual
  #             #pp_actual = obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)
  #         else
  #             subtotal_por_pp = subtotales_por_partida_parcial.select {|e| e.partida_parcial == pp_actual}[0].subtotal
  #             item_nuevo = ItemStock.new
  #             item_nuevo.update(subtotal: subtotal_por_pp)
  #
  #             puts "******************** pp: #{pp_actual} // subtotal----ja: #{subtotales_por_partida_parcial.select {|e| e.partida_parcial == pp_actual}[0].subtotal}"
  #             pp_actual = obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)
  #             item_actual = item
  #
  #             if item.id == items_de_stock.last.id
  #               subtotal_por_pp = subtotales_por_partida_parcial.select {|e| e.partida_parcial == pp_actual}[0].subtotal
  #               item_actual.update(subtotal: subtotal_por_pp)
  #             end
  #         end
  #   end
  #
  #   # puts "***********  *  **  * * ***************filas con subtotal PPPAPAPPASPAPSPAPSPS **  **  **  ****  ******  **  ************    * ****"
  #   # agua = Array.new
  #   # items_de_stock.each do |item|
  #   #   if item.cantidad > 0
  #   #     agua << "canidad: #{item.cantidad} // pp: #{obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)} // subtotal: #{item.subtotal}"
  #   #   end
  #   # end
  #   # puts agua
  #   # put "car"
  #   return items_de_stock
  # end

  def traer_ultimo_costo_de_bien_de_consumo
    @costos = CostoDeBienDeConsumo.where("bien_de_consumo_id = ?", self.bien_de_consumo_id)
    if @costos.empty?
    else
      @costos.last.costo unless @costos.empty?
    end
  end

end
