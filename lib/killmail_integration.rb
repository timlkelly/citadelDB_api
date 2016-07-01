require 'httparty'

class KillmailIntegration
  def fetch_killmail
    HTTParty.get('http://redisq.zkillboard.com/listen.php')
  end

  def parse_killmail(package)
    km = Killmail.new(killmail_json: package)
    km.find_or_create_citadel
    km.save_if_relevant
  end
end
