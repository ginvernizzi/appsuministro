module ApplicationHelper
  include ActionView::Helpers::NumberHelper
	# Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Suministro"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def obtener_costo_total(cantidad_unitario, costo_unitario)         
      result = costo_unitario * cantidad_unitario
  end 

  def obtener_total_general_de_bienes_de_consumo(bienes_de_consumo)
    sum = 0.0
    bienes_de_consumo.each do |bien|
      sum = sum + obtener_costo_total(bien.costo, bien.cantidad)      
    end
    return sum
  end

  #################
  def obtener_total_general_de_items_stock(items_stock)
    sum = 0.0
    items_stock.each do |item|
      sum = sum + obtener_costo_total(item.costo_de_bien_de_consumo.costo, item.cantidad.to_i)      
    end
    return sum
  end

  def obtener_costo_total(costo, cantidad)        
    result = costo * cantidad
  end 
  
  ################
  def obtener_total_general(items)
    sum = 0.0
    items.each do |item|
      sum = sum + obtener_costo_total(CostoDeBienDeConsumo.where("bien_de_consumo_id = ?", item.bien_de_consumo_id).last.costo, item.cantidad)
    end
    return number_to_currency(sum, :precision => 3)
  end
  #################

  def obtener_codigo_completo_bien_de_consumo(nombre_de_bien_de_consumo)
    @array_bien_de_consumo = BienDeConsumo.where(nombre: nombre_de_bien_de_consumo)    
    armar_codigo(@array_bien_de_consumo[0])
  end 


  def armar_codigo(array)
    bien = array
    cod_bien = bien.codigo

    clase = bien.clase 
    cod_clase  = clase.codigo

    partida_parcial = clase.partida_parcial
    cod_partida_parcial = partida_parcial.codigo
    
    partida_principal = partida_parcial.partida_principal
    cod_partida_principal = partida_principal.codigo      

    inciso = partida_principal.inciso
    cod_inciso = inciso.codigo    

    codigo_completo = "#{cod_inciso}" + "#{cod_partida_principal}" + "#{cod_partida_parcial}" + "." + "#{cod_clase}" + "." + "#{cod_bien}"      

    return codigo_completo
  end

  def obtener_codigo_de_inciso(id)      
    inciso = Inciso.find(id)  
    codigo_completo = "#{inciso.codigo}"
    return codigo_completo
  end 


  def obtener_codigo_de_partida_principal(id)      

    partida_principal = PartidaPrincipal.find(id)  
    codigo_completo = "#{partida_principal.inciso.codigo}" + "#{partida_principal.codigo}"
    return codigo_completo
  end 

  def obtener_codigo_de_partida_parcial(id)
    partida_parcial = PartidaParcial.find(id)  
    codigo_inciso = "#{partida_parcial.partida_principal.inciso.codigo}"
    codigo_partida_principal = "#{partida_parcial.partida_principal.codigo}" 
    codigo_partida_parcial = "#{partida_parcial.codigo}"

    codigo_completo =  codigo_inciso+codigo_partida_principal+codigo_partida_parcial 

    return codigo_completo
  end 

  def obtener_codigo_de_clase(id)
    clase = Clase.find(id) 
    codigo_inciso = "#{clase.partida_parcial.partida_principal.inciso.codigo}"
    codigo_partida_principal = "#{clase.partida_parcial.partida_principal.codigo}" 
    codigo_partida_parcial = "#{clase.partida_parcial.codigo}"
    codigo_clase = "#{clase.codigo}" 

    codigo_completo =  codigo_inciso +codigo_partida_principal+codigo_partida_parcial+ "." +codigo_clase

    return codigo_completo
  end 

def existen_stocks_minimos_superados
  resp = false
  @items = @items = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo")

  if @items.count > 0
    resp = true   
  end
end

def traer_cantidad_de_items_con_stock_bajo
    @items_stock = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo") 
    @items_stock.count
end

def volver_costo_de_bien_al_anterior(bien_de_consumo_a_consumir)
  ActiveRecord::Base.transaction do      
    begin              
      #Volver al ultimo costo ##### Si el costo del bien en la recepcion es igual al ultimo costo del item, voler y traer el costo inmediato anterior
      costo_actual = CostoDeBienDeConsumo.where("bien_de_consumo_id = ?", bien_de_consumo_a_consumir.bien_de_consumo.id).last.costo
      if bien_de_consumo_a_consumir.costo == costo_actual
        costo_inmediato_anterior = bien_de_consumo_a_consumir.bien_de_consumo.id.last(2).first.costo
        costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo: bien_de_consumo_a_consumir.bien_de_consumo, costo: costo_inmediato_anterior,        
                                           usuario: current_user.name, origen: "2" )           
        costo_de_bien.save!
        @costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo:  bien_de_consumo_a_consumir.bien_de_consumo, costo: costo_inmediato_anterior,
                                              usuario: current_user.name, origen: "2" )      
        @costo_de_bien_historico.save!
      end
    rescue Exception => e
      puts "Se produjo el siguiente error: #{e} " 
      raise ActiveRecord::Rollback
    end
  end
end

def flash_class(level)
  case level
  when "notice" then "alert alert-info"
  when "success" then "alert alert-success"
  when "error" then 'alert alert-warning'
  when "alert" then "alert alert-danger"
  end
end
end