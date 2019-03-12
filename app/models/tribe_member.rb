class TribeMember < ApplicationRecord

  def self.set_location_array
    locations = []
    TribeMember.all.each do |tm|
      next if tm.latitude.nil? || tm.longitude.nil?
      a = [tm.latitude.to_f, tm.longitude.to_f]
      locations << a
    end
    locations
  end

end
