# frozen_string_literal: true
require 'spec_helper'

describe 'SlashDoto Application' do
  context 'GET /' do
    it 'is successful' do
      get '/' do
        expect(last_response).to be_ok
      end
    end
  end
  context 'POST /' do
    it 'returns error message without token' do
      post '/', {} do
        expect(last_response).not_to be_ok
        expect(last_response.body).to eq('You. are. the. only. exception...')
      end
    end
    it 'returns error message with invalid token' do
      post '/', token: 'invalidtoken' do
        expect(last_response).not_to be_ok
        expect(last_response.body).to eq('You. are. the. only. exception...')
      end
    end
  end
  context 'GET /nonexistentpage' do
    it 'is unsuccessful' do
      get '/nonexistentpage' do
        expect(last_response).not_to be_ok
      end
    end
  end
end
