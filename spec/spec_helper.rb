require 'rack/test'
require 'rspec'

require 'dotenv'
Dotenv.load(
  File.expand_path '../../.env.test', __FILE__
)

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../web.rb', __FILE__
module RSpecMixin
  include Rack::Test::Methods
  def app() SlashDoto::Web end
end

RSpec.configure { |c| c.include RSpecMixin }
