# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
ActiveSupport::Inflector.inflections do |inflect|

  inflect.irregular 'documento_principal', 'documentos_principal'
  inflect.irregular 'documento_secundario', 'documentos_secundario'

  inflect.irregular 'tipo_de_documento', 'tipos_de_documentos'
  inflect.irregular 'documento_de_recepcion', 'documentos_de_recepcion'
  inflect.irregular 'documento_de_recepcion_secundario', 'documentos_de_recepcion_secundario'
  inflect.irregular 'bien_de_consumo', 'bienes_de_consumo'
  inflect.irregular 'bien_de_consumo_de_recepcion', 'bienes_de_consumo_de_recepcion'
  inflect.irregular 'recepcion_de_bien_de_consumo', 'recepciones_de_bien_de_consumo'

  inflect.irregular 'obra_proyecto', 'obras_proyectos'
  inflect.irregular 'bien_de_consumo_para_consumir', 'bienes_de_consumo_para_consumir'
  inflect.irregular 'consumo_directo', 'consumos_directo'
  inflect.irregular 'costo_de_bien_de_consumo', 'costos_de_bien_de_consumo'
  inflect.irregular 'costo_de_bien_de_consumo_historico', 'costos_de_bien_de_consumo_historico'
  inflect.irregular 'item_stock', 'items_stock'
  inflect.irregular 'transferencia', 'transferencias'
  inflect.irregular 'bien_de_consumo_para_transferir', 'bienes_de_consumo_para_transferir'
  inflect.irregular 'persona', 'personas'
  inflect.irregular 'item_stock_a_fechas', 'items_stock_a_fechas'
  inflect.irregular 'reporte_a_fecha', 'reportes_a_fecha'

  inflect.irregular 'inciso', 'incisos'
  inflect.irregular 'partida_principal', 'partidas_principales'
  inflect.irregular 'partida_parcial', 'partidas_parciales'
  inflect.irregular 'clase', 'clases'

  inflect.irregular 'reemplazo_bdc', 'reemplazos_bdc'
  inflect.irregular 'reemplazo_clase', 'reemplazos_clase'
  inflect.irregular 'ingreso_manual_a_stock', 'ingreso_manual_a_stocks'
  inflect.irregular 'recepcion_para_consumo_directo', 'recepciones_para_consumo_directo'

end