json.array! @patterns do |p|
  json.partial! 'pattern', pattern: p
end
