# frozen_string_literal: true
require 'spec_helper'
require_relative '../command.rb'

module SlashDoto
  describe Command do
    context 'when initialized with no command' do
      it 'returns false for #valid?' do
        expect(described_class.new(nil).valid?).to be(false)
      end
    end
    context 'when initialized with valid command' do
      let(:params) { { text: 'player 123456789' } }
      subject(:command) { Command.new(params) }
      it 'returns #command string' do
        expect(command.action).to eq('player')
      end
      it 'returns #parameter string' do
        expect(command.parameter).to eq('123456789')
      end
      it 'returns true for #valid?' do
        expect(command.valid?).to be(true)
      end
    end
    context 'when valid but initialized with multi-word parameter' do
      let(:params) { { text: 'player this is actually my name' } }
      subject(:command) { Command.new(params) }
      it 'returns full #parameter string' do
        expect(command.parameter).to eq('this is actually my name')
      end
    end
    context 'when initialized with incomplete command' do
      let(:params) { { text: 'player' } }
      subject(:command) { Command.new(params) }
      it 'return false for #valid?' do
        expect(command.valid?).to be(false)
      end
    end
  end
end
