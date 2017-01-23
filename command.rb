# frozen_string_literal: true
require_relative 'commands/player'
require_relative 'commands/search'

module SlashDoto
  class Command
    VALID_COMMANDS = %w(
      player
    ).freeze

    def initialize(command = '', params = {})
      @params = params
      @text = (command || '').split(/\s+/)
      @command = @text.first
      @parameter = @text[1]
    end

    def execute
      case @command
      when 'player'
        Player.new(@parameter, response_url: @params[:response_url]).response
      when 'search'
        Search.new(@parameter, response_url: @params[:response_url]).response
      end
    end

    def valid?
      VALID_COMMANDS.include?(@command) && !@parameter.nil?
    end
  end
end
