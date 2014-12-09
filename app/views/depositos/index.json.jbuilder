json.array!(@depositos) do |deposito|
  json.extract! deposito, :id, :nombre, :area_id
  json.url deposito_url(deposito, format: :json)
end
