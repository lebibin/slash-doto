require 'net/http'
require 'json'
module SlashDoto
  class Command
    class Search
      def initialize personaname, options = {}
        @personaname = personaname || ''
        @options = options
      end

      def response
        Thread.new do
          url = URI.parse("http://api.opendota.com/api/search?similarity=0.5&q=#{@personaname}")
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) {|http|
            http.request(req)
          }
          r = JSON.parse res.body
          attachments = []
          for player in r.first(10).sort{|x, y| y['similarity'] <=> x['similarity']}
            similarity = player['similarity'].to_f
            color = if similarity <= 1.0 && similarity > 0.9
                      "#145924"
                    elsif similarity <= 0.9 && similarity > 0.8
                      "#36A64F"
                    elsif similarity <= 0.8 && similarity > 0.7
                      "#A63642"
                    else
                      "#590B13"
                    end
            name        = player['personaname']
            account_id  = player['account_id']
            avatar      = player['avatarfull']
            result      = {
              "color": color,
              "title": name,
              "text": account_id,
              "thumb_url": avatar,
              "footer": "/doto player #{account_id}",
            }
            attachments << result
          end

          body = unless attachments.empty?
                   {
                     "response_type": "in_channel",
                     "text": "Found #{attachments.count} for `#{@personaname}`",
                     "attachments": attachments
                   }
                 else
                   {
                     "response_type": "ephemeral",
                     "text": "Sorry, we couldn't find anyone named `#{@personaname}`... FeelsBadMan"
                   }
                 end
          Net::HTTP::post(URI.parse(@options[:response_url]),
                          body.to_json,
                          'Content-Type' => 'application/json'
                         )
        end

        {
          "response_type": "ephemeral",
          "text": "Processing your search for `#{@personaname}`, please hang tight!"
        }

      end
    end
  end
end
