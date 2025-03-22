json.response do
  json.data JSON.parse(yield)
end
