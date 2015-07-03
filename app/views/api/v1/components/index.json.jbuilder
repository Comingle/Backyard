#@components.each do |k,v|
#  json.set! k do
#    json.array! v, :name, :pretty_name, :description
#  end
#end

@components.each do |k,v|
  json.set! k do 
    v.each do |r|
      json.partial! 'component', component: r
    end
  end
end
