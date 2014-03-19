class Race < ActiveRecord::Base
  belongs_to :track
  has_many :runners
end