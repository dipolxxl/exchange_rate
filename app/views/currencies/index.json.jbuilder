json.(@rates) do |rate|
  json.code rate.currency.code
  json.course rate.course
end