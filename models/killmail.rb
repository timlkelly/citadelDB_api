class Killmail < ActiveRecord::Base
  validates_presence_of :citadel_id, :killmail_id, :killmail_json
  validates_uniqueness_of :killmail_id

  belongs_to :citadel

  def self.valid_citadel_types
    ['Astrahus', 'Fortizar', 'Keepstar', 'Upwell Palatine Keepstar']
  end

  def self.valid_citadel_types_past
    [35832, 35833, 35834, 35835]
  end

  def system_id_lookup(id)
    System.where(system_id: id).first.name
  end

  def citadel_type_lookup(id)
    citadel_types = {
      '35832' => 'Astrahus',
      '35833' => 'Fortizar',
      '35834' => 'Keepstar',
      '35835' => 'Upwell Palatine Keepstar'
    }
    citadel_types.values_at(id).first
  end

  def killmail_data
    if killmail_json.keys.include?('package')
      killmail_json['package']
    else
      killmail_json
    end
  end

  def citadel?
    citadel_victim? || citadel_attacker? || false
  end

  def citadel_victim?
    self.class.valid_citadel_types.include?(killmail_data['victim']['shipType']['name'])
  end

  def citadel_victim_past?
    self.class.valid_citadel_types_past.include?(killmail_data['victim']['shipTypeID'])
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

  def generate_citadel_hash_past
    if citadel_victim_past?
      create_victim_hash_past
    else
      create_attacker_hash_past
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

  def create_attacker_hash_past
    attacker_hash = {}
    killmail_data['attackers'].each do |attacker|
      if attacker['shipTypeID']
        next unless self.class.valid_citadel_types_past.include?(attacker['shipTypeID'])
        attacker_hash = {
          system: system_id_lookup(killmail_data['solarSystemID']),
          citadel_type: citadel_type_lookup(attacker['shipTypeID'].to_s),
          corporation: attacker['corporationName'],
          alliance: attacker['allianceName'],
          killed_at: nil
        }
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

  def create_victim_hash_past
    victim_hash = {
      system: system_id_lookup(killmail_data['solarSystemID']),
      citadel_type: citadel_type_lookup(killmail_data['victim']['shipTypeID'].to_s),
      corporation: killmail_data['victim']['corporationName'],
      killed_at: killmail_data['killTime']
    }
    if killmail_data['victim']['allianceName']
      victim_hash[:alliance] = killmail_data['victim']['allianceName']
    else
      victim_hash[:alliance] = nil
    end
    victim_hash
  end

  def find_or_create_citadel
    return false if killmail_data.nil?
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
