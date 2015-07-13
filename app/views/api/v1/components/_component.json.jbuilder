json.set! component.name do
  json.extract! component, :id, :pretty_name, :description
  json.set! :variables do
   json.array! component.variable_objs, :name, :description, :min, :max
  end
end
