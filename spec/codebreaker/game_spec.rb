require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) {Game.new}
    context '#initialize' do
      it 'render is a kind of render' do
        expect(game.render).to be_a_kind_of(Render)
      end

      it 'options exists' do
        expect(game).to respond_to(:options)
      end

      it 'options should be a hash' do
        expect(game.options).to be_an_instance_of(Hash)
      end
    end

    context '#start' do

      it 'should call "new" method if scenario allowed' do
        allow(game).to receive_message_chain(:gets).and_return('new')
        allow(game).to receive(:new)
        expect(game).to receive(:new)
        game.start
      end

      it 'should call "exit" method if scenario allowed' do
        allow(game).to receive_message_chain(:gets).and_return('exit')
        allow(game).to receive(:exit)
        expect(game).to receive(:exit)
        game.start
      end

      it 'should call "stats" method if scenario allowed' do
        allow(game).to receive_message_chain(:gets).and_return('stats')
        allow(game).to receive(:stats)
        expect(game).to receive(:stats)
        game.start
      end
    end
  end
end