json.array!(@groups) do |group|
  json.extract! group, :id, :name, :aboutme
  json.url group_url(group, format: :json)
end
