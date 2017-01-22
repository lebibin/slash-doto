require 'spec_helper'
describe 'Search commands' do
  context 'present personaname parameter' do
    it 'should return json response' do
      query = 'KSHHJ'
      VCR.use_cassette 'opendoto/search/present' do
        post '/', {token: 'validtoken', text: "search #{query}"} do
          expect(last_response).to be_ok
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end
end
