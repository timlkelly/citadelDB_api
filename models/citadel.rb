class Citadel < ActiveRecord::Base
  validates_presence_of :system_eveid, :citadel_type, :corporation

  has_many :killmails
  belongs_to :system, primary_key: :eveid, foreign_key: :system_eveid
  delegate :region, to: :system

  def api_hash
    {
      system: system.name,
      region: region,
      citadel_type: citadel_type,
      corporation: corporation,
      alliance: alliance,
      killed_at: killed_at && killed_at.to_i
    }
  end
end
