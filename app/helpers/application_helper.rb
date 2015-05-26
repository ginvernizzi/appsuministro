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

  def obtener_codigo_completo_bien_de_consumo(nombre_de_bien_de_consumo)
    @array_bien_de_consumo = BienDeConsumo.where(nombre: nombre_de_bien_de_consumo)    

    bien = @array_bien_de_consumo[0]
    cod_bien = bien.codigo

    clase = bien.clase 
    cod_clase  = clase.codigo

    partida_parcial = clase.partida_parcial
    cod_partida_parcial = partida_parcial.codigo
    
    partida_principal = partida_parcial.partida_principal
    cod_partida_principal = partida_principal.codigo      

    inciso = partida_principal.inciso
    cod_inciso = inciso.codigo    

    codigo_completo = "#{cod_inciso}" + "." + "#{cod_partida_principal}" + "." + "#{cod_partida_parcial}" + "." + "#{cod_clase}" + "." + "#{cod_bien}"      

    return codigo_completo
  end 
end
