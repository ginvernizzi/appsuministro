json.array!(@recepciones_de_bien_de_consumo) do |recepcion_de_bien_de_consumo|
  json.extract! recepcion_de_bien_de_consumo, :id, :fecha, :estado, :descripcion_provisoria
  json.url recepcion_de_bien_de_consumo_url(recepcion_de_bien_de_consumo, format: :json)
end
