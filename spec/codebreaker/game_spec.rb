require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#initialize' do
      let(:game) {Game.new}
      it '@phrases should not be empty' do
        expect(game.instance_variable_get(:@phrases)).not_to be_empty
      end
    end

    context '#start' do
      let(:game) {Game.new}

      it '@phrases should have hello key' do
        allow(game).to receive(:call_if_allow)
        expect(game.instance_variable_get(:@phrases)).to have_key(:hello)
        game.start
      end

    context '#call_if_allow' do
      let(:game) {Game.new}

      it 'should raise error if method isn\'t allowed' do
        allow(game).to receive(:current_decision) {'test'}
        expect{game.call_if_allow(['new','load'])}.to raise_error('No allowed method')
      end

      it 'should call the method of it\'s allowed' do
        allow(game).to receive(:current_decision) {'new'}
        expect(game).to receive(:new)
        game.call_if_allow(['new','load'])
      end
    end

    context '#generate_secret_code'
      let(:game) {Game.new}

      it 'code should consists of 4 symbols' do
        game.send('generate_secret_code')
        expect(game.secret_code.size).to eql(4)
      end

      it 'saves 4 numbers secret code' do
        game.send('generate_secret_code')
        expect(game.secret_code).to match(/[1-6]+/)
      end
    end

    context '#ask_name' do
      let(:game) {game = Game.new}

      it 'phrases should have ask_name key' do
        expect(game.instance_variable_get(:@phrases)).to have_key(:ask_name)
      end
    end

    context '#ask_difficulty' do
      let(:game) {game = Game.new}

      it 'phrases should have ask_name key' do
        expect(game.instance_variable_get(:@phrases)).to have_key(:ask_difficulty)
      end
    end

    context '#get_and_retrive_answer' do
      let(:game) {game = Game.new}
      it 'check current answer' do

      end
    end

    context '#get_answer' do
      let(:game) {game = Game.new}

      it 'phrases should have hint_info key' do
        expect(game.instance_variable_get(:@phrases)).to have_key(:hint_info)
      end

      it 'phrases should have ask_answer key' do
        expect(game.instance_variable_get(:@phrases)).to have_key(:ask_answer)
      end

      it ''
    end

  end
end