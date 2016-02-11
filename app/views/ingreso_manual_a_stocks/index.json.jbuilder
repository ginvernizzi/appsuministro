json.array!(@ingreso_manual_a_stocks) do |ingreso_manual_a_stock|
  json.extract! ingreso_manual_a_stock, :id, :fecha
  json.url ingreso_manual_a_stock_url(ingreso_manual_a_stock, format: :json)
end
