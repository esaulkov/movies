# coding: utf-8
# frozen_string_literal: true

describe Movies::GenreSelection do
  let(:collection) { Movies::MovieCollection.new }
  let(:genres) { %w[Drama Comedy Sci-Fi] }

  subject { described_class.new(collection) }

  before(:each) do
    allow(collection).to receive(:genres).and_return(genres)
  end

  it { is_expected.to respond_to(:drama) }
  it { is_expected.to respond_to(:comedy) }
  it { is_expected.to respond_to(:sci_fi) }
  it { is_expected.to_not respond_to(:opera) }
end
