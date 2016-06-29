class Citadel < ActiveRecord::Base
  validates_presence_of :system, :nearest_celestial, :citadel_type, :corporation

  has_many :killmails
end
