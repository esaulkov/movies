# coding: utf-8
# frozen_string_literal: true

describe Movies::MovieCollection do
  describe 'include methods from Enumerable module' do
    subject { Movies::MovieCollection.new }

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
end
