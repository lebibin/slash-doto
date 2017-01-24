# frozen_string_literal: true
require 'spec_helper'
require_relative '../command.rb'

module SlashDoto
  describe Command do
    context 'when initialized with no command' do
      it 'should return false for #valid?' do
        expect(described_class.new(nil).valid?).to be(false)
      end
    end
    context 'when initialized with valid command' do
      subject(:command) { Command.new('player playerid') }
      it 'should return #command string' do
        expect(command.action).to eq('player')
      end
      it 'should return #parameter string' do
        expect(command.parameter).to eq('playerid')
      end
      it 'should return true for #valid?' do
        expect(command.valid?).to be(true)
      end
    end
    context 'when initialized with incomplete command' do
      subject(:command) { Command.new('player') }
      it 'should return false for #valid?' do
        expect(command.valid?).to be(false)
      end
    end
  end
end
