# frozen_string_literal: true
require 'sinatra/base'
require_relative 'command'

module SlashDoto
  # :nodoc:
  class Web < Sinatra::Base
    InvalidTokenError = Class.new(Exception)
    get '/' do
      'El Psy Tuturu?'
    end
    post '/' do
      begin
        raise(InvalidTokenError) if params[:token] != ENV['SLACK_TOKEN']
        command = Command.new(params)
        content_type :json
        JSON command.execute
      rescue InvalidTokenError
        halt 401, 'You. are. the. only. exception...'
      end
    end
  end
end
