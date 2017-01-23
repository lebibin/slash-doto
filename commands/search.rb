# frozen_string_literal: true
require 'net/http'
require 'json'
module SlashDoto
  class Command
    # :nodoc:
    class Search
      def initialize(personaname, options = {})
        @personaname = personaname || ''
        @options = options
      end

      def response
        initiate_search_request
        immediate_response
      end

      private

      def initiate_search_request
        Thread.new do
          base_url = 'https://api.open.dota.com/api'
          endpoint = "/search?similarity=0.5&q=#{@personaname}"
          url = URI.parse("#{base_url}#{endpoint}")
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) do |http|
            http.request(req)
          end
          parse_response res.body
        end
      end

      def parse_response(body)
        parsed_res = JSON.parse body
        body = prepare_body(parsed_res)
        Net::HTTP.post(URI.parse(@options[:response_url]),
                       body.to_json,
                       'Content-Type' => 'application/json')
      end

      def immediate_response
        {
          "response_type": 'ephemeral',
          "text": "Processing your search for `#{@personaname}`, please wait!"
        }
      end

      def prepare_body(parsed_response)
        if parsed_response.empty?
          empty_result_response
        else
          attachments = build_attachments(parsed_response)
          result_response(attachments)
        end
      end

      def build_attachments(response)
        [].tap do |attachments|
          results = response.first(10)
          sorted = results.sort { |x, y| y['similarity'] <=> x['similarity'] }
          sorted.each do |player|
            attachments << parse_info(player)
          end
        end
      end

      def parse_info(player)
        {}.tap do |info|
          similarity = player['similarity'].to_f
          info['color'] = similarity > 0.7 ? '#145924' : '#590B13'
          info['title'] = player['personaname']
          info['text'] = player['account_id']
          info['thumb_url'] = player['avatarfull']
          info['footer'] = "/doto player #{account_id}"
        end
      end

      def result_response(attachments)
        {
          "response_type": 'in_channel',
          "text": "Found #{attachments.count} for `#{@personaname}`",
          "attachments": attachments
        }
      end

      def empty_result_response
        {
          "response_type": 'ephemeral',
          "text": <<-RES
          Sorry, we couldn't find anyone named `#{@personaname}`...\FeelsBadMan
          RES
        }
      end
    end
  end
end
