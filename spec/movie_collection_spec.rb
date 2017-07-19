# coding: utf-8
# frozen_string_literal: true

shared_examples 'load data from file' do
  context 'when data file exists' do
    let(:data) {
      {"tt1555149"=>{
        :title=>"Элитный отряд: Враг внутри",
        :poster_path=>"/An36DV15SQupjsADzsBbYKMDNUs.jpg"
      }}
    }

    before(:example) do
      allow(File).to receive(:exist?).and_return(true)
      allow(YAML).to receive(:load_file).and_return(data)
    end

    it 'loads data from file once only' do
      expect(YAML).to receive(:load_file).once
      subject
      subject
    end
  end

  context 'when data file does not exist' do
    before(:example) { allow(File).to receive(:exist?).and_return(false) }

    it 'raises an error' do
      expect { subject }.to raise_error(ArgumentError, 'File not found!')
    end
  end
end

describe Movies::MovieCollection do
  let(:collection) { described_class.new }
  describe 'include methods from Enumerable module' do
    subject { collection }

    it 'should have :each method' do
      expect(subject.each).to be_an_instance_of(Enumerator)
    end

    it 'should have :first method' do
      expect(subject.first).to be_an(Movies::Movie)
    end

    it 'should have :count method' do
      expect(subject.count).to be_a_kind_of(Fixnum)
    end
  end

  describe '#additional_info' do
    subject { collection.additional_info }
    it_behaves_like 'load data from file'
  end

  describe '#budgets' do
    subject { collection.budgets }
    it_behaves_like 'load data from file'
  end
end
