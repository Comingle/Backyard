json.extract! @sketch, :created_at, :updated_at, :config, :sha256
if !@defer
  json.sketch @sketch.get_hex_data
end
