# frozen_string_literal: true
require 'spec_helper'
describe 'Search commands' do
  context 'present personaname parameter' do
    let(:query) { 'KSHHJ' }
    it 'should return json response' do
      VCR.use_cassette 'opendoto/search/present' do
        post '/', token: 'validtoken', text: "search #{query}" do
          expect(last_response).to be_ok
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end
end
