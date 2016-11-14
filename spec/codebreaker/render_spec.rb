require 'spec_helper'

module Codebreaker
  RSpec.describe Render do
    context '#initialize' do
      let(:render) {Render.new}
      it '@phrases should not be empty' do
        expect(render.instance_variable_get(:@phrases)).not_to be_empty
      end
    end

    context '#hello' do
      let(:render) {Render.new}
      it 'key hello must be in @phrases' do
        expect(render.instance_variable_get(:@phrases)).to have_key(:hello)
      end
    end

    context '#no_stats' do
      let(:render) {Render.new}
      it 'key no_stats must be in @phrases' do
        expect(render.instance_variable_get(:@phrases)).to have_key(:no_stats)
      end
    end

    context '#answers_hints_info' do
      let(:render) {Render.new}
      it 'key hint_info must be in @phrases' do
        expect(render.instance_variable_get(:@phrases)).to have_key(:hint_info)
      end
      it 'key ask_answer must be in @phrases' do
        expect(render.instance_variable_get(:@phrases)).to have_key(:ask_answer)
      end
    end

    context '#ask_name' do
      let(:render) {Render.new}
      it 'key ask_name must be in @phrases' do
        expect(render.instance_variable_get(:@phrases)).to have_key(:ask_name)
      end
    end

    context '#no_hints' do
      let(:render) {Render.new}
      it 'key no_hints must be in @phrases' do
        expect(render.instance_variable_get(:@phrases)).to have_key(:no_hints)
      end
    end
  end
end