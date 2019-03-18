class Stat < ApplicationRecord
  serialize :older, Hash
  serialize :average, Array

  def self.prepare_hash
    hash = TribeMember.all.group_by { |tm| tm.birthdate.year }
    hash_count = {}
    hash.each do |key, value|
      hash_count[key] = value.count
    end
    hash_count
  end
end
