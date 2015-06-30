json.extract! @sketch, :created_at, :updated_at, :config, :sha256
json.sketch @sketch.get_hex_data
