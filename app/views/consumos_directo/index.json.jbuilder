json.array!(@consumos_directo) do |consumo_directo|
  json.extract! consumo_directo, :id, :fecha, :area, :obra_proyecto_id
  json.url consumo_directo_url(consumo_directo, format: :json)
end
