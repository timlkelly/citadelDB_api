class Citadel < ActiveRecord::Base
  validates_presence_of :system, :citadel_type, :corporation

  has_many :killmails
end
