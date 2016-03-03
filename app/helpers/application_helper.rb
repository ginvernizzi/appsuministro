module ApplicationHelper
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
      #costo_unitario_con_precision = number_with_precision(cantidad_unitario.to_f , :precision => 3) 
      #costo_unitario_con_precision * cantidad_unitario
      result = BigDecimal.new(costo_unitario.to_s) * cantidad_unitario.to_i
      #number_with_precision(result, :precision => 3)
  end 

  def obtener_total_general_de_bienes_de_consumo(bienes_de_consumo)
    sum = 0.0
    bienes_de_consumo.each do |bien|
      sum = sum + obtener_costo_total(bien.costo, bien.cantidad)      
    end
    return sum
  end

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


  def flash_class(level)
    case level
    when "notice" then "alert alert-info"
    when "success" then "alert alert-success"
    when "error" then 'alert alert-warning'
    when "alert" then "alert alert-danger"
    end
  end
end