require 'httparty'
require 'pp'

class KillmailIntegration
  def fetch_killmail
    HTTParty.get('http://redisq.zkillboard.com/listen.php')
  end

  def parse_killmail(package)
    km = Killmail.new(killmail_json: package)
    km.find_or_create_citadel
    km.save_if_relevant
  end


  def json_to_killmail(json_data)
    pp json_data
    killmail_hash = {}
    json_data.each do |km|
      pp '*** START ARRAY ***'
      pp km
      killmail_hash = Killmail.new(killmail_json: km)
    end
    pp killmail_hash
    killmail_hash
  end
end

# is interpreted as a string because the other comes in
# as a table field set to JSON.

# Astrahus : 35832
# Fortizar : 35833
# Keepstar : 35834
# Upwell   : 35835