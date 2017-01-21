require 'sinatra/base'

module SlashDoto
  class Web < Sinatra::Base
    InvalidTokenError = Class.new(Exception)
    get '/' do
      'El Psy Tuturu?'
    end
    post '/' do
      begin
        raise(InvalidTokenError) if params[:token].nil? || params[:token] != ENV['SLACK_TOKEN']
        params[:text]
      rescue InvalidTokenError => e
        halt 401, "You. are. the. only. exception..."
      end
    end
  end
end
