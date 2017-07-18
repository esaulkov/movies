# coding: utf-8
# frozen_string_literal: true

describe Movies::TmdbParser do
  let(:collection) { Movies::MovieCollection.new.first(1) }
  let(:parser) { described_class.new }
  let(:info) { [{'tt0111161' => {title:'Начало', poster_path: '/7SivRwOLuA6DR09zNJ9JIo14GyX.jpg'}}] }

  describe '#run' do
    subject { parser.run(collection) }

    it 'get movie attributes as result' do
      expect(subject).to eq(info)
    end
  end

  describe '#save' do
    subject { parser.save(info) }

    it 'saves result to local file' do
      expect(File).to receive(:write).with('info.yml', an_instance_of(String))
      subject
    end
  end
end
