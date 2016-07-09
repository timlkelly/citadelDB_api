class Citadel < ActiveRecord::Base
  validates_presence_of :system, :citadel_type, :corporation

  has_many :killmails

  def api_hash
    {
      system: system,
      region: region,
      citadel_type: citadel_type,
      corporation: corporation,
      alliance: alliance,
      killed_at: killed_at && killed_at.to_i
    }
  end
end
