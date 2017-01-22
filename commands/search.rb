require 'net/http'
require 'json'
module SlashDoto
  class Command
    class Search
      def initialize personaname
        @personaname = personaname || ""
      end

      def response
        return if @personaname.empty?
        url = URI.parse("http://api.opendota.com/api/search?q=#{@personaname}&similarity=0.7")
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        r = JSON.parse res.body
        attachments = []
        for player in r
          similarity = player['similarity'].to_f
          color = if similarity <= 1.0 && similarity > 0.95
                    "#145924"
                  elsif similarity <= 0.95 && similarity > 0.85
                    "#36A64F"
                  elsif similarity <= 0.85 && similarity > 0.75
                    "#A63642"
                  else
                    "#590B13"
                  end
          result = {
            "color": color,
            "title": player['personaname'],
            "text": player['account_id'],
            "thumb_url": player['avatarfull'],
            "footer": "/doto player ACCOUNT_ID",
          }
          attachments << result
        end
        {
          "response_type": "in_channel",
          "text": nil,
          "attachments": attachments
        }
      end
    end
  end
end
