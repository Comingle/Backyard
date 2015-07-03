json.sketch do
  json.size @sketch.size
  json.fingerprint @sketch.sha256
  json.config @sketch.config
end
