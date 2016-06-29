class Killmail < ActiveRecord::Base
  validates_presence_of :citadel_id, :killmail_id, :killmail_json
  validates_uniqueness_of :killmail_id

  belongs_to :citadel

  def citadel?
    # pp is_citadel_attacker?
    citadel_victim? || citadel_attacker? || false
  end

  def citadel_victim?
    case killmail_json['victim']['shipType']['name']
    when 'Astrahus', 'Fortizar', 'Keepstar', 'Upwell Palatine Keepstar'
      true
    end
  end

  def citadel_attacker?
    killmail_json['attackers'].each_index do |i|
      case killmail_json['attackers'][i]['shipType']['name']
      when 'Astrahus', 'Fortizar', 'Keepstar', 'Upwell Palatine Keepstar'
        return true
      end
    end
  end
end
