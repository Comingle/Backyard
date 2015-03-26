json.array!(@sketches) do |sketch|
  json.extract! sketch, :id
  json.url sketch_url(sketch, format: :json)
end
