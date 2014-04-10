json.array!(@banos) do |bano|
  json.extract! bano, :descripcion, :latitud, :longitud
  json.url bano_url(bano, format: :json)
end
