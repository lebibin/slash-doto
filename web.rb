require 'sinatra/base'

module SlashDoto
  class Web < Sinatra::Base
    get '/' do
      'El Psy Tuturu?'
    end
  end
end
