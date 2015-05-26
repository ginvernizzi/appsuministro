json.array!(@partidas_principales) do |partida_principal|
  json.extract! partida_principal, :id, :codigo, :nombre, :inciso_id
  json.url partida_principal_url(partida_principal, format: :json)
end
