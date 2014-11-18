json.array!(@obras_proyectos) do |obra_proyecto|
  json.extract! obra_proyecto, :id, :codigo, :descripcion
  json.url obra_proyecto_url(obra_proyecto, format: :json)
end
