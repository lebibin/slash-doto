# frozen_string_literal: true
require_relative 'commands/player'
require_relative 'commands/search'

module SlashDoto
  # :nodoc:
  class Command
    ACTION_PARAM_REGEX = /\A(\w+)\ {1}(.+)\z/
    VALID_COMMANDS = %w(
      player
    ).freeze

    attr_reader :action, :parameter

    def initialize(action = '', params = {})
      @params = params
      @text = (action || '').scan(ACTION_PARAM_REGEX).flatten
      @action = @text.first
      @parameter = @text[1]
    end

    def execute
      case action
      when 'player'
        Player.new(parameter, response_url: @params[:response_url]).response
      when 'search'
        Search.new(parameter, response_url: @params[:response_url]).response
      end
    end

    def valid?
      VALID_COMMANDS.include?(action) && !parameter.nil?
    end
  end
end
