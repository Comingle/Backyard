if @components.present?
  @components.each do |c|
    if c.category.match("pattern")
      json.partial! 'pattern', pattern: c
    else
      json.partial! 'component', component: c
    end
  end
else
  json.partial! 'component', component: @component
end
