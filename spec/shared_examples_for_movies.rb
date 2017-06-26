shared_examples 'create instance of proper class' do |period, class_name|
  let(:params) do
    {
      name: 'The best movie',
      producer: "It's me",
      actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
      year: rand(period).to_s
    }
  end

  before(:each) do
    allow(CSV).to receive(:read).and_return([params])
  end

  it "should create an instance of #{class_name}" do
    expect(subject.movies.last).to be_an_instance_of(class_name)
  end
end
