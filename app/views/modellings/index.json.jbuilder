json.array!(@modellings) do |modelling|
  json.extract! modelling, :id
  json.url modelling_url(modelling, format: :json)
end
