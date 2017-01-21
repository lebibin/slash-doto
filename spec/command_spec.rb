require 'spec_helper'
require_relative '../command.rb'

module SlashDoto
  describe Command do
    context 'initialized with no command' do
      it 'should not raise error' do
        expect{described_class.new}.to raise_error(ArgumentError)
      end
      it 'should return false for #valid?' do
        expect(described_class.new(nil).valid?).to be(false)
      end
    end
    context 'initialized with valid command' do
      before(:each) do
        @command = Command.new('player playerid')
      end
      it 'should return true for #valid?' do
        expect(@command.valid?).to be(true)
      end
    end
    context 'initialized with incomplete command' do
      before(:each) do
        @command = Command.new('player')
      end
      it 'should return false for #valid?' do
        expect(@command.valid?).to be(false)
      end
    end
  end
end
