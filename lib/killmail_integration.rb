require 'httparty'

class KillmailIntegration
  def fetch_killmail
    HTTParty.get('http://redisq.zkillboard.com/listen.php')
  end

  def parse_killmail(package = fetch_killmail)
    Killmail.new(killmail_json: package).save_if_relevant
  end

  def json_to_killmail(json_data)
    json_parsed = JSON.parse(json_data)
    json_parsed.each do |km|
      Killmail.new(killmail_json: km).generate_citadel_hash_past
    end
  end
end
