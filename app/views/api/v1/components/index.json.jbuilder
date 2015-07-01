@components.each do |k,v|
  json.set! k do
    json.array! v, :name, :pretty_name, :description
  end
end
