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
    geojson = { "type" => "FeatureCollection", "features" => []}

    TribeMember.all.each do |tm|
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
