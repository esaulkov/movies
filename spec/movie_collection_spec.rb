# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe MovieCollection do
  describe '#new' do
    let(:params) do
      {
        name: 'The best movie',
        producer: "It's me",
        actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley'
      }
    end
    let(:ancient_params) { params.merge(year: '1930') }
    let(:classic_params) { params.merge(year: rand(1946..1968).to_s) }
    let(:modern_params) { params.merge(year: rand(1969..2000).to_s) }
    let(:new_params) { params.merge(year: rand(2001..Date.today.year).to_s) }

    subject { MovieCollection.new }

    context 'when year is before 1946' do
      before(:each) do
        allow(CSV).to receive(:read).and_return([ancient_params])
      end

      it 'creates AncientMovie instance' do
        expect(subject.movies.last).to be_an_instance_of(AncientMovie)
      end
    end

    context 'when year is in range 1946-1968' do
      before(:each) do
        allow(CSV).to receive(:read).and_return([classic_params])
      end

      it 'creates ClassicMovie instance' do
        expect(subject.movies.last).to be_an_instance_of(ClassicMovie)
      end
    end

    context 'when year is in range 1969-2000' do
      before(:each) do
        allow(CSV).to receive(:read).and_return([modern_params])
      end

      it 'creates ModernMovie instance' do
        expect(subject.movies.last).to be_an_instance_of(ModernMovie)
      end
    end

    context 'when year is after 2000' do
      before(:each) do
        allow(CSV).to receive(:read).and_return([new_params])
      end

      it 'creates NewMovie instance' do
        expect(subject.movies.last).to be_an_instance_of(NewMovie)
      end
    end

    context 'when year is undefined' do
      before(:each) do
        allow(CSV).to receive(:read).and_return([params])
      end

      it 'creates Movie instance' do
        expect(subject.movies.last).to be_an_instance_of(Movie)
      end
    end
  end
end
