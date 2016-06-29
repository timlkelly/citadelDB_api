class Killmail < ActiveRecord::Base
  validates_presence_of :citadel_id, :killmail_id, :killmail_json
  validates_uniqueness_of :killmail_id

  belongs_to :citadel

  def self.valid_citadel_types
    ['Astrahus', 'Fortizar', 'Keepstar', 'Upwell Palatine Keepstar']
  end

  def killmail_data
    killmail_json['package'] || killmail_json
  end

  def citadel?
    citadel_victim? || citadel_attacker? || false
  end

  def citadel_victim?
    self.class.valid_citadel_types.include?(killmail_data['victim']['shipType']['name'])
  end

  def citadel_attacker?
    killmail_data['attackers'].each do |attacker|
     self.class.valid_citadel_types.include?(attacker['shipType'])
    end
  end

  def generate_citadel_hash
    if citadel_victim?
      create_victim_hash
    else
      create_attacker_hash
    end
  end

  def create_attacker_hash
    attacker_hash = {}
    killmail_data['attackers'].each do |attacker|
      next unless self.class.valid_citadel_types.include?(attacker['shipType']['name'])
      attacker_hash = {
        system: killmail_data['solarSystem']['name'],
        citadel_type: attacker['shipType']['name'],
        corporation: attacker['corporation']['name'],
        killed_at: nil
      }
      if attacker['alliance']
        attacker_hash[:alliance] = attacker['alliance']['name']
      else
        attacker_hash[:alliance] = nil
      end
    end
    attacker_hash
  end

  def create_victim_hash
    victim_hash = {
      system: killmail_data['solarSystem']['name'],
      citadel_type: killmail_data['victim']['shipType']['name'],
      corporation: killmail_data['victim']['corporation']['name'],
      killed_at: killmail_data['killTime']
    }
    if killmail_data['victim']['alliance']
      victim_hash[:alliance] = killmail_data['victim']['alliance']['name']
    else
      victim_hash[:alliance] = nil
    end
    victim_hash
  end

  def find_or_create_citadel
    Citadel.find_or_create_by(generate_citadel_hash)
  end

  def citadel_exists?
    citadel_data = generate_citadel_hash
    if Citadel.find_by(citadel_data) == true
      true
    else
      false
    end
  end
end
