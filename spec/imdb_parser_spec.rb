# coding: utf-8
# frozen_string_literal: true

describe Movies::ImdbParser do
  let(:collection) { Movies::MovieCollection.new.first(1) }
  let(:parser) { described_class.new }
  let(:info) { {'tt0111161' => '$25,000,000'} }

  describe '#run' do
    subject { parser.run(collection) }

    it 'get movie attributes as result' do
      VCR.use_cassette('page') do
        expect { subject }.to change(parser, :budgets).from({}).to(info)
      end
    end
  end

  describe '#save' do
    subject { parser.save }

    it 'saves result to local file' do
      expect(File).to receive(:write).with('budgets.yml', an_instance_of(String))
      subject
    end
  end
end
