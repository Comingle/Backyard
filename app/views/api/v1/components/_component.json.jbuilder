json.set! component.name do
  json.extract! component, :pretty_name, :description
  json.set! :variables, component.variable_objs
end
