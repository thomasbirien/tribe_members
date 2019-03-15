class TribeMember < ApplicationRecord
  attr_accessor :ancestor_name, :ancestor_surname

  belongs_to :ancestor, class_name: "TribeMember", foreign_key: :ancestor

  scope :by_name, -> (val) {
    TribeMember.where(name: val)
  }

  scope :by_surname, -> (val) {
    TribeMember.where(surname: val)
  }

  scope :by_birthdate, -> (val) {
    TribeMember.select{|tm| tm.birthdate == val.to_date}
  }


  scope :get_ancestor, -> (val) {
    TribeMember.find(val)
  }

  def self.set_location_array
    locations = []
    TribeMember.all.each do |tm|
      next if tm.latitude.nil? || tm.longitude.nil?
      a = [tm.latitude.to_f, tm.longitude.to_f]
      locations << a
    end
    locations
  end

  def self.search(params)
    if params[:name].present?
      search_result = TribeMember.by_name(params[:name])

    elsif params[:surname].present?
      search_result = TribeMember.by_surname(params[:surname])

    elsif params[:member_birthdate].present?
      if params[:member_birthdate]["birthdate(2i)"].to_i < 10
        params[:member_birthdate]["birthdate(2i)"] = "0" + params[:member_birthdate]["birthdate(2i)"]
      end
      if params[:member_birthdate]["birthdate(3i)"].to_i < 10
       params[:member_birthdate]["birthdate(3i)"] = "0" + params[:member_birthdate]["birthdate(3i)"]
      end
      birthdate = params[:member_birthdate]["birthdate(1i)"] + "-" + params[:member_birthdate]["birthdate(2i)"] + "-" + params[:member_birthdate]["birthdate(3i)"]
      search_result = TribeMember.by_birthdate(birthdate)

    elsif params[:ancestor_name].present? && params[:ancestor_surname].present?
      ancestor = TribeMember.where(name: params[:ancestor_name], surname: params[:ancestor_surname]).first
      search_result = TribeMember.where("ancestor = ?", ancestor.id)
    end

    if search_result == []
      search_result = "no result"
    end

    search_result
  end

  def self.build_json
    json = {"tribe_members" => []}

    TribeMember.all.each do |tm|

      hash = {
        name: tm.name,
        surname: tm.surname,
        birthdate: tm.birthdate,
        ancestor: {
          id: nil,
          name: "",
          surname: ""
        }
      }
      if tm.ancestor != 0
        ancestor = TribeMember.find(tm.ancestor)
        hash[:ancestor][:id] = ancestor.id
        hash[:ancestor][:name] = ancestor.name
        hash[:ancestor][:surname] = ancestor.surname
      end

      json["tribe_members"] << hash
    end

    json_to_send = json.to_json
    File.open("public/tribe_members.json","w") do |f|
      f.write(json_to_send)
    end

    json
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
  end

  def generate_stats
  end


end
