json.array!(@clases) do |clase|
  json.extract! clase, :id, :codigo, :nombre, :partida_parcial_id
  json.url clase_url(clase, format: :json)
end
