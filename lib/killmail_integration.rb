require 'httparty'

class KillmailIntegration
  def fetch_killmail
    HTTParty.get('http://redisq.zkillboard.com/listen.php')
  end

  def parse_killmail(package = fetch_killmail)
    Killmail.new(killmail_json: package).save_if_relevant
  end


  # has to create killmail data differently
  
  def json_to_killmail(json_data)
    json_parsed = JSON.parse(json_data)
    json_parsed.each do |km|
      parse_killmail(km)
    end
  end
end

# is interpreted as a string because the other comes in
# as a table field set to JSON.

# Astrahus : 35832
# Fortizar : 35833
# Keepstar : 35834
# Upwell   : 35835