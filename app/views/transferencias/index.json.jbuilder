json.array!(@transferencias) do |transferencia|
  json.extract! transferencia, :id, :fecha, :area_id, :deposito_origen_id, :deposito_destino_id
  json.url transferencia_url(transferencia, format: :json)
end
