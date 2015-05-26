json.array!(@partidas_parciales) do |partida_parcial|
  json.extract! partida_parcial, :id, :codigo, :nombre, :partida_principal_id
  json.url partida_parcial_url(partida_parcial, format: :json)
end
