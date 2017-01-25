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

    def initialize(params = {})
      parsed_params = stringify_keys(params).fetch(:text, '')
                                            .scan(ACTION_PARAM_REGEX).flatten
      @action = parsed_params.first
      @parameter = parsed_params.last
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

    private

    def stringify_keys(params)
      @params = (params || {}).collect { |k, v| [k.to_sym, v] }.to_h
    end
  end
end
