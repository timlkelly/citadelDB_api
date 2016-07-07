require 'httparty'

class KillmailIntegration
  def fetch_killmail
    HTTParty.get('http://redisq.zkillboard.com/listen.php')
  end

  def parse_killmail(package = fetch_killmail)
    Killmail.new(killmail_json: package).save_if_relevant
  end

  def json_to_killmail(json_data = fetch_past_killmails)
    json_parsed = JSON.parse(json_data.body)
    json_parsed.each do |km|
      Killmail.new(killmail_json: km).save_if_relevant_past
    end
  end

  def fetch_past_killmails
    HTTParty.get('http://zkillboard.com/api/shipTypeID/35832/', 
      :headers => { 'User-Agent:' => 'github.com/timlkelly/citadelDB Maintainer: Tim' })
  end

  def astrahus
    '/shipTypeID/35832/'
  end

  def fortizar
    '/shipTypeID/35833/'
  end

  def keepstar
    '/shipTypeID/35834'
  end

  def upwell
    '/shipTypeID/35835/'
  end
end

# 'http://zkillboard.com/api'
# '/kills'
# '/losses'
# '/shipTypeID'
# '/35832/'
# '/35833/'
# '/35834/'
# '/35835/'
