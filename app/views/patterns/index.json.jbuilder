json.array!(@patterns) do |pattern|
  json.extract! pattern, :id
  json.url pattern_url(pattern, format: :json)
end
