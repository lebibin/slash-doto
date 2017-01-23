# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require 'vcr'
require 'dotenv'
require File.expand_path '../../web.rb', __FILE__

Dotenv.load(
  File.expand_path('../../.env.test', __FILE__)
)

module RSpecMixin
  include Rack::Test::Methods
  def app
    SlashDoto::Web
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
  c.hook_into :webmock
end

RSpec.configure do |c|
  c.include RSpecMixin
end
