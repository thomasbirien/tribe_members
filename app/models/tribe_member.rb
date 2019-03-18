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

  def self.add_to_geojson(tribe_member)
    data_hash = JSON.parse(File.read('public/geo.geojson'))
    hash = {"type"=>"Feature", "geometry"=>{"type"=>"Point", "coordinates"=>[tribe_member.latitude, tribe_member.longitude]}, "properties"=>{"title"=>tribe_member.id}}
    data_hash["features"] << hash

    geo_to_save = data_hash.to_json

    File.open("public/geo.geojson","w") do |f|
      f.write(geo_to_save)
    end
  end

  def self.data_parse
    average_age = Stat.last.average.sum / Stat.last.average.count
    oldest_member = TribeMember.find(Stat.last.older[:id])
    data_to_show = {average: average_age, count: Stat.last.total_member, oldest_member: oldest_member, age_oldest_member: Stat.last.older[:age]}
  end

  def self.add_to_stats(tribe_member)
    stat = Stat.last
    age_year = ((Time.zone.now - tribe_member.birthdate.to_time) / 1.year.seconds).floor
    stat.average << age_year
    age_time = Time.zone.now - tribe_member.birthdate.to_time
    if stat.older[:age_time] < age_time
      stat.older[:age_time] = age_time
      stat.older[:age] = age_year
      stat.older[:id] = tribe_member.id
    end

    stat.total_member = stat.total_member + 1
    stat.save

  end

  def self.generate_stats
    puts "start"
    count = 0
    average = []
    older = {age: 0, age_time: 0, id: nil}
    TribeMember.all.each do |tm|
      puts "#{tm.id}"
      count += 1

      age_year = ((Time.zone.now - tm.birthdate.to_time) / 1.year.seconds).floor
      age_time = Time.zone.now - tm.birthdate.to_time
      # if older[:age] == 0
      #   older[:age] = age_time
      # end
      # next if age_year > 90
      average << age_year
      if older[:age_time] < age_time
        older[:age] = age_year
        older[:age_time] = age_time
        older[:id] = tm.id
      end
      puts "older: #{older}"
    end
    # average_age = average.sum / average.count
    # puts "average_age: #{average_age}"
    puts "count: #{count}"
    stat = Stat.new(total_member: count, older: older, average: average)
    stat.save

    # stat_info = {age: average, count: count, older: older}
    # stat_to_save = stat_info.to_json
    # File.open("public/data_for_stat.json","w") do |f|
    #   f.write(stat_to_save)
    # end
  end


end
