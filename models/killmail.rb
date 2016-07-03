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
      if attacker['shipType']
        return true if self.class.valid_citadel_types.include?(attacker['shipType']['name'])
      else
        return false
      end
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
      if attacker['shipType']
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
      else
        return false
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

  # def generate_victim_hash_past
  #   victim_hash = {}
  #   json_data.each do |killmail|
  #     victim_hash = {
  #       system:
  #       citadel_type:
  #       corporation:
  #       alliance:
  #       killed_at: 
  #     }
  #     if killmail['victim']['allianceName']
  #       victim_hash[:alliance] = killmail['victim']['allianceName']
  #     else
  #       victim_hash[:alliance] = nil
  #     end
  #   end
  #   victim_hash
  # end

  def find_or_create_citadel
    # return false if killmail_data['package'] == nil
    citadel = Citadel.where(generate_citadel_hash).first
    unless citadel
      citadel = Citadel.create(generate_citadel_hash)
    end
    citadel
  end

  def save_if_relevant
    self.citadel_id = find_or_create_citadel.id
    self.killmail_id = killmail_data['killID']
    save
  end
end
