# frozen_string_literal: true
require 'net/http'
require 'json'
module SlashDoto
  class Command
    # :nodoc:
    class Player
      def initialize(account_id, options = {})
        @account_id = account_id || ''
        @options = options
      end

      def response
        return if @account_id.empty?
        url = URI.parse("http://api.opendota.com/api/players/#{@account_id}")
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request req
        end
        parse_response res.body
      end

      private

      def parse_response(body)
        parsed_res = JSON.parse body
        if parsed_res.key? 'profile'
          valid_response parsed_res
        else
          invalid_response
        end
      end

      def valid_response(r)
        {}.tap do |res|
          res['response_type'] = 'in_channel'
          res['attachments'] = []
          res['attachments'][0] = attachment_field(r)
        end
      end

      def invalid_response
        {}
      end

      def attachment_field(r)
        {}.tap do |res|
          res['color'] = '#36a64f'
          res['thumb_url'] = r['profile']['avatarmedium']
          res['title'] = r['profile']['personaname']
          res['title_link'] = r['profile']['profileurl']
          res['fields'] = [
            mmr_field('Solo MMR', r['solo_competitive_rank']),
            mmr_field('Party MMR', r['competitive_rank'])
          ]
        end
      end

      def mmr_field(title, value)
        {
          "title": title,
          "value": value,
          "short": true
        }
      end
    end
  end
end
