require 'sinatra/base'
require_relative 'command'

module SlashDoto
  class Web < Sinatra::Base
    InvalidTokenError = Class.new(Exception)
    get '/' do
      'El Psy Tuturu?'
    end
    post '/' do
      begin
        raise(InvalidTokenError) if params[:token].nil? || params[:token] != ENV['SLACK_TOKEN']
        command = Command.new(params[:text], params)
        content_type :json
        JSON command.execute
      rescue InvalidTokenError
        halt 401, "You. are. the. only. exception..."
      end
    end
  end
end
