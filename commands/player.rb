# frozen_string_literal: true
require 'net/http'
require 'json'
require_relative '../opendoto/api/player'
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
        JSON parse_response(res.body)
      end

      private

      def parse_response(body)
        parsed_res = JSON.parse body
        player = OpenDoto::API::Player.new(parsed_res)
        if player.valid?
          valid_response_from(player)
        else
          invalid_response
        end
      end

      def valid_response_from(player)
        {}.tap do |res|
          res['response_type'] = 'in_channel'
          res['attachments'] = []
          res['attachments'][0] = attachment_field_for(player)
        end
      end

      def invalid_response
        {}
      end

      def attachment_field_for(player)
        {}.tap do |res|
          res['color'] = '#36a64f'
          res['thumb_url'] = player.avatar(:medium)
          res['title'] = player.persona_name
          res['title_link'] = player.profile_url
          res['fields'] = [
            mmr_field('Solo MMR', player.solo_mmr),
            mmr_field('Party MMR', player.party_mmr)
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
