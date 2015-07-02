#@components.each do |k,v|
#  json.set! k do
#    json.array! v, :name, :pretty_name, :description
#  end
#end

@components.each do |k,v|
  json.set! k do 
    v.each do |r|
      json.set! r.name do
        json.extract! r, :pretty_name, :description
        json.set! :variables, r.variable_objs
      end
    end
  end
end
