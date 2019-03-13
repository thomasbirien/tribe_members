class TribeMember < ApplicationRecord
  require 'rgeo/geo_json'

  def self.set_location_array
    locations = []
    TribeMember.all.each do |tm|
      next if tm.latitude.nil? || tm.longitude.nil?
      a = [tm.latitude.to_f, tm.longitude.to_f]
      locations << a
    end
    locations
  end

  def self.build_geojson
    # {  "type": "FeatureCollection",
    # "features": []
    # }
    # TribeMember.all.each do |tm|
    #   str = '{"type":"Feature","geometry":{"type":"Point","coordinates":["#{tm.latitude.to_f}", "#{tm.longitude.to_f}"]},"properties":{"color":"red"}}'

    # end
    # str2 = '{"type":"Feature","geometry":{"type":"Point","coordinates":[2.5,4.0]},"properties":{"color":"red"}}'
    # feature = RGeo::GeoJSON.decode(str2)
    # feature['color']          # => 'red'
    # feature.geometry.as_text  # => "POINT (2.5 4.0)"

    # hash = RGeo::GeoJSON.encode(feature)
    # hash.to_json == str2

    geojson = { "type" => "FeatureCollection", "features" => []}

    TribeMember.all.limit(6).each do |tm|
      hash = {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [tm.latitude.to_f, tm.longitude.to_f]
        },
        properties: {
        title: tm.id
        }
      }

      geojson["features"] << hash
  end

  geojson_json = geojson.to_json
  File.open("public/geo.geojson","w") do |f|
    f.write(geojson_json)
  end

  geojson



     # TribeMember.all.each do |tm|
     #   str = '{"type":"Feature","geometry":{"type":"Point","coordinates":["#{tm.latitude.to_f}", "#{tm.longitude.to_f}"]},"properties":{"color":"red"}}'
     #   hash[:features] << str
     # end

     # hash = hash.to_json
  end

end
