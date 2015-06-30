@components.each do |k,v|
  json.set! k do
    json.array! v
  end
end
