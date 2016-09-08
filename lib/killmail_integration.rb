require 'httparty'

class KillmailIntegration
  def fetch_killmail
    HTTParty.get('http://redisq.zkillboard.com/listen.php')
  end

  def parse_killmail(package)
    Killmail.new(killmail_json: package).save_if_relevant
  end

  def listen
    km_json = JSON.parse(fetch_killmail.body)
    if km_json['package'] && km_json['package']['killmail']
      puts "killmailID: #{km_json['package']['killID']}"
      parse_killmail(km_json)
      listen
    end
    puts "finished"
  end

  def json_to_killmail(url_array = create_url_array)
    url_array.each do |url|
      json_parsed = JSON.parse(fetch_past_killmails(url))
      json_parsed.each do |km|
        Killmail.new(killmail_json: km).save_if_relevant
      end
    end
  end

  def fetch_past_killmails(url)
    puts url
    HTTParty.get(url, headers: { 'User-Agent:' => 'github.com/timlkelly/citadelDB Maintainer: Tim' }).body
  end

  def create_url_array
    Array(1..10).map do |page|
      Killmail.valid_citadel_types_ids.map do |citadel|
        %w(kills losses).map { |type| "https://zkillboard.com/api/#{type}/shipTypeID/#{citadel}/page/#{page}/" }
      end
    end.flatten
  end
end
