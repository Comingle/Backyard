json.set! pattern.name do
  json.extract! pattern, :id, :pretty_name, :description
  json.variables pattern.variables
  json.testride pattern.test_pattern
end
