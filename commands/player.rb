require 'net/http'
require 'json'
module SlashDoto
  class Command
    class Player
      def initialize account_id
        @account_id = account_id || ""
      end

      def response
        return if @account_id.empty?
        url = URI.parse("http://api.opendota.com/api/players/#{@account_id}")
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        r = JSON.parse res.body
        if r.has_key?('profile')
          solo_mmr = r['solo_competitive_rank']
          party_mmr = r['competitive_rank']
          name = r['profile']['personaname']
          picture = r['profile']['avatarmedium']
          url = r['profile']['profileurl']
          {
            "response_type": "in_channel",
            "text": nil,
            "attachments": [
              {
                "color": "#36a64f",
                "title": name,
                "title_link": url,
                "fields": [
                  {
                    "title": "Solo MMR",
                    "value": solo_mmr,
                    "short": true
                  },                {
                    "title": "Party MMR",
                    "value": party_mmr,
                    "short": true
                  }
                ],
                "thumb_url": picture
              }
            ]
          }
        else
          {}
        end
      end
    end
  end
end