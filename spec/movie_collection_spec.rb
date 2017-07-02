# coding: utf-8
# frozen_string_literal: true

describe Movies::MovieCollection do
  describe 'include methods from Enumerable module' do
    subject { Movies::MovieCollection.new }

    it { is_expected.to respond_to(:first).and respond_to(:count) }
    it { is_expected.to respond_to(:one?).and respond_to(:flat_map) }
  end
end
