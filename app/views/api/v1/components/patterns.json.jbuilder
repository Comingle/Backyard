json.array! @patterns do |pattern|
  json.id pattern.id
  json.name pattern.name
  json.pretty_name pattern.pretty_name
  json.description pattern.description
  json.options pattern.pat_options
  json.testride pattern.test_pattern
end
