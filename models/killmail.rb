class Killmail < ActiveRecord::Base
  validates_presence_of :citadel_id, :killmail_id, :killmail_json
  validates_uniqueness_of :killmail_id

  belongs_to :citadel

  def self.valid_citadel_types_names
    ['Astrahus', 'Fortizar', 'Keepstar', 'Upwell Palatine Keepstar']
  end

  def self.valid_citadel_types_ids
    [35832, 35833, 35834, 35835]
  end

  def system_id_lookup(id)
    System.where(system_id: id).first.name
  end

  def region_lookup(id)
    Region.where(region_id: System.where(system_id: id).first.region_id).first.name
  end

  def killed_at_datetime(killed_time = nil)
    return nil unless killed_time and killed_time.to_s.length > 0
    return killed_time if killed_time.is_a?(Time)
    Time.parse(killed_time)
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
    if killmail_json.is_a?(String)
      km_json = JSON.parse(killmail_json) 
    else
      km_json = killmail_json
    end
    return nil unless killmail_json
    if km_json.keys.include?('package') 
      km_json['package'] && km_json['package']['killmail']
    else
      km_json
    end
  end

  def citadel?
    citadel_victim? || citadel_attacker? || false
  end

  def citadel_victim?
    return false unless killmail_data && killmail_data['victim']
    if killmail_data['victim']['shipTypeID']
      self.class.valid_citadel_types_ids.include?(killmail_data['victim']['shipTypeID'])
    elsif killmail_data['victim']['shipType']['name']
      self.class.valid_citadel_types_names.include?(killmail_data['victim']['shipType']['name'])
    else
      false
    end
  end

  def citadel_attacker?
    return false unless killmail_data
    killmail_data['attackers'].each do |attacker|
      if attacker['shipType']
        next unless self.class.valid_citadel_types_names.include?(attacker['shipType']['name'])
        return true
      elsif attacker['shipTypeID']
        next unless self.class.valid_citadel_types_ids.include?(attacker['shipTypeID'])
        return true
      end
    end
    false
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
        next unless self.class.valid_citadel_types_names.include?(attacker['shipType']['name'])
        attacker_hash = {
          system: killmail_data['solarSystem']['name'],
          region: region_lookup(killmail_data['solarSystem']['id']),
          citadel_type: attacker['shipType']['name'],
          corporation: attacker['corporation']['name']
        }
        if attacker['alliance']
          attacker_hash[:alliance] = attacker['alliance']['name']
        else
          attacker_hash[:alliance] = nil
        end
      elsif attacker['shipTypeID']
        next unless self.class.valid_citadel_types_ids.include?(attacker['shipTypeID'])
        attacker_hash = {
          system: system_id_lookup(killmail_data['solarSystemID']),
          region: region_lookup(killmail_data['solarSystemID']),
          citadel_type: citadel_type_lookup(attacker['shipTypeID'].to_s),
          corporation: attacker['corporationName'],
        }
        if attacker['allianceName'] == ''
          attacker_hash[:alliance] = nil
        else
          attacker_hash[:alliance] = attacker['allianceName']
        end
      else
        return {}
      end
    end
    attacker_hash
  end

  def create_victim_hash
    if killmail_data['victim']['shipType']
      victim_hash = {
        system: killmail_data['solarSystem']['name'],
        region: region_lookup(killmail_data['solarSystem']['id']),
        citadel_type: killmail_data['victim']['shipType']['name'],
        corporation: killmail_data['victim']['corporation']['name'],
        killed_at: killmail_data['killTime']
      }
      if killmail_data['victim']['alliance']
        victim_hash[:alliance] = killmail_data['victim']['alliance']['name']
      else
        victim_hash[:alliance] = nil
      end
    elsif killmail_data['victim']['shipTypeID']
      victim_hash = {
        system: system_id_lookup(killmail_data['solarSystemID']),
        region: region_lookup(killmail_data['solarSystemID']),
        citadel_type: citadel_type_lookup(killmail_data['victim']['shipTypeID'].to_s),
        corporation: killmail_data['victim']['corporationName'],
        killed_at: killmail_data['killTime']
      }
      if killmail_data['victim']['allianceName']
        victim_hash[:alliance] = killmail_data['victim']['allianceName']
      else
        victim_hash[:alliance] = nil
      end
    end
    victim_hash
  end

  def find_or_create_citadel
    return false if killmail_data.nil?
    citadel = Citadel.where(generate_citadel_hash.except(:killed_at)).first
    unless citadel
      citadel = Citadel.create(generate_citadel_hash)
    end
    if citadel_victim?
      citadel.update_attribute(:killed_at, killmail_data['killTime'])
    end
    citadel
  end

  def save_if_relevant
    if citadel? == false
      return false
    else
      self.citadel_id = find_or_create_citadel.id
      self.killmail_id = killmail_data['killID']
      save
    end
  end
end
