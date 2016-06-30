class Citadel < ActiveRecord::Base
  validates_presence_of :system, :nearest_celestial_y_s, :nearest_celestial_x_s, :nearest_celestial_z_s, :citadel_type, :corporation

  has_many :killmails

  def nearest_celestial_y
    BigDecimal.new(nearest_celestial_y_s)
  end

  def nearest_celestial_x
    BigDecimal.new(nearest_celestial_x_s)
  end

  def nearest_celestial_z
    BigDecimal.new(nearest_celestial_z_s)
  end

end
