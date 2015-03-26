json.array!(@sketch_histories) do |sketch_history|
  json.extract! sketch_history, :id
  json.url sketch_history_url(sketch_history, format: :json)
end
