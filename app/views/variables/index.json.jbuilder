json.array!(@variables) do |variable|
  json.extract! variable, :id
  json.url variable_url(variable, format: :json)
end
