require 'spec_helper'
describe 'Player commands' do
  context 'valid account_id parameter' do
    before(:each) do
      @valid_account_id = '296295895'
    end
    it 'should return json response with attachment' do
      VCR.use_cassette 'opendoto/player/valid' do
        post '/', {token: 'validtoken', text: "player #{@valid_account_id}"} do
          expect(last_response).to be_ok
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.body['attachments']).not_to be_nil
        end
      end
    end
  end
  context 'invalid account_id parameter' do
    before(:each) do
      @invalid_account_id = '0000000000000'
    end
    it 'should return json response without attachments' do
      VCR.use_cassette 'opendoto/player/invalid' do
        post '/', {token: 'validtoken', text: "player #{@invalid_account_id}"} do
          expect(last_response).to be_ok
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.body['attachments']).to be_nil
        end
      end
    end
  end
end
