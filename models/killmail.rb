class Killmail < ActiveRecord::Base
  validates_presence_of :citadel_id, :killmail_eveid, :killmail_json
  validates_uniqueness_of :killmail_eveid

  belongs_to :citadel

  def self.valid_citadel_types_names
    ['Astrahus', 'Fortizar', 'Keepstar', 'Upwell Palatine Keepstar']
  end

  def self.valid_citadel_types_ids
    [35832, 35833, 35834, 35835]
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

  def killed_at_datetime(killed_time = nil)
    return nil unless killed_time and killed_time.to_s.length > 0
    return killed_time if killed_time.is_a?(DateTime)
    DateTime.parse(killed_time)
  end

  def killmail_data
    killmail_json.is_a?(String) ? km_json = JSON.parse(killmail_json) : km_json = killmail_json
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
    killmail_data['attackers'].detect { |attacker| valid_attacker_type?(attacker) }
  end

  def generate_citadel_hash
    citadel_hash = { system_eveid: system_eveid_from_json }
    if citadel_victim?
      citadel_hash.merge!(killmail_data['victim']['shipType'] ? listening_victim_hash : legacy_victim_hash)
    else
      killmail_data['attackers'].each do |attacker|
        citadel_hash.merge!(attacker['shipType'] ? listening_attacker_hash(attacker) : legacy_attacker_hash(attacker))
      end
    end
    citadel_hash[:alliance] = nil if citadel_hash[:alliance] == ''
    citadel_hash
  end

  def system_eveid_from_json
    if killmail_data['solarSystem']
      killmail_data['solarSystem']['id']
    else
      killmail_data['solarSystemID']
    end
  end

  def find_or_create_citadel
    return false if killmail_data.nil?
    citadel = Citadel.where(generate_citadel_hash.except(:killed_at)).first
    unless citadel
      citadel = Citadel.create(generate_citadel_hash)
    end
    if citadel_victim?
      citadel.update_attribute(:killed_at, killed_at_datetime(killmail_data['killTime']))
    end
    citadel
  end

  def save_if_relevant
    if citadel? == false
      return false
    else
      self.citadel_id = find_or_create_citadel.id
      self.killmail_eveid = killmail_data['killID']
      save
    end
  end

  private

  def valid_attacker_type?(attacker)
    if attacker['shipType']
      self.class.valid_citadel_types_names.include?(attacker['shipType']['name'])
    elsif attacker['shipTypeID']
      self.class.valid_citadel_types_ids.include?(attacker['shipTypeID'])
    end
  end

  def listening_attacker_hash(attacker)
    return {} unless valid_attacker_type?(attacker)
    {
      citadel_type: attacker['shipType']['name'],
      corporation: attacker['corporation']['name'],
      alliance: attacker['alliance'] && attacker['alliance']['name']
    }
  end

  def legacy_attacker_hash(attacker)
    return {} unless attacker['shipTypeID'] && valid_attacker_type?(attacker)
    {
      citadel_type: citadel_type_lookup(attacker['shipTypeID'].to_s),
      corporation: attacker['corporationName'],
      alliance: attacker['allianceName']
    }
  end

  def listening_victim_hash
    {
      citadel_type: killmail_data['victim']['shipType']['name'],
      corporation: killmail_data['victim']['corporation']['name'],
      killed_at: killed_at_datetime(killmail_data['killTime']),
      alliance: killmail_data['victim']['alliance'] && killmail_data['victim']['alliance']['name']
    }
  end

  def legacy_victim_hash
    {
      citadel_type: citadel_type_lookup(killmail_data['victim']['shipTypeID'].to_s),
      corporation: killmail_data['victim']['corporationName'],
      killed_at: killed_at_datetime(killmail_data['killTime']),
      alliance: killmail_data['victim']['allianceName']
    }
  end
end
