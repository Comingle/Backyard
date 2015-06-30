json.array!(@nunchucks) do |nunchuck|
  json.extract! nunchuck, :id
  json.url nunchuck_url(nunchuck, format: :json)
end
