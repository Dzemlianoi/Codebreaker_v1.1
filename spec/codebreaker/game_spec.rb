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

    end

    context '#call_if_allow' do

      it 'should raise error if method isn\'t allowed'

      it 'should call the method of it\'s allowed'
    end
  end
end