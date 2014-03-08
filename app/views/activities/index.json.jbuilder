json.array!(@activities) do |activity|
  json.extract! activity, :id, :started_at, :stopped_at
  json.url activity_url(activity, format: :json)
end
