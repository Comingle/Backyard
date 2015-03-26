json.array!(@toys) do |toy|
  json.extract! toy, :id
  json.url toy_url(toy, format: :json)
end
