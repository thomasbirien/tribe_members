class Stat < ApplicationRecord
  serialize :older, Hash
  serialize :average, Array
end
