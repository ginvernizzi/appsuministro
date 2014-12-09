json.array!(@areas) do |area|
  json.extract! area, :id, :nombre, :responsable
  json.url area_url(area, format: :json)
end
