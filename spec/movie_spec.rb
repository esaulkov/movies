# coding: utf-8
# frozen_string_literal: true

shared_examples 'create instance of proper class' do |period, class_name|
  let(:params) do
    {
      name: 'The best movie',
      producer: "It's me",
      actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
      year: rand(period).to_s
    }
  end

  it "should create an instance of #{class_name}" do
    expect(subject).to be_an_instance_of(class_name)
  end
end

shared_examples 'return proper value from file' do |attr_name, attr_value|
  let(:movie) do
    Movies::Movie.create(
      link: 'http://imdb.com/title/tt1555149/?ref_=chttp_tt_250',
      name: 'Elite Squad: The Enemy Within',
      year: '2010',
      collection: collection
    )
  end

  it "returns #{attr_name} from info file" do
    allow(File).to receive(:exist?).and_return(true)
    allow(YAML).to receive(:load_file).and_return(
      [{"tt1555149"=>{
        :title=>"Элитный отряд: Враг внутри",
        :poster_path=>"/An36DV15SQupjsADzsBbYKMDNUs.jpg"
      }}]
    )

    expect(subject).to eq(attr_value)
  end

  it 'raises an error when file does not exist' do
    allow(File).to receive(:exist?).and_return(false)

    expect { subject }.to raise_error(ArgumentError, 'File not found!')
  end
end

describe Movies::Movie do
  let(:collection) { Movies::MovieCollection.new }

  describe '#budget' do
    let(:movie) do
      Movies::Movie.create(
        link: 'http://imdb.com/title/tt0133093/?ref_=chttp_tt_18',
        name: 'The Matrix',
        producer: 'Andy Wachowski',
        year: '1999',
        genres: 'Action,Sci-Fi',
        collection: collection
      )
    end
    let(:movie2) do
      Movies::Movie.create(
        link: 'http://imdb.com/title/tt0133095/?ref_=chttp_tt_18',
        name: 'The Movie without budget',
        year: '1899',
        collection: collection
      )
    end

    before(:example) do
      allow(File).to receive(:exist?).and_return(true)
      allow(YAML).to receive(:load_file).and_return(
        {"tt0133093"=>'$63,000,000'}
      )
    end

    subject { movie.budget }

    context 'when budget is defined' do
      it 'returns the budget sum' do
        is_expected.to eq('$63,000,000')
      end
    end

    context 'when budget is not defined' do
      subject { movie2.budget }

      it { is_expected.to eq('Unknown') }
    end
  end

  describe '#create' do
    subject { Movies::Movie.create(params) }

    context 'when year is before 1946' do
      it_behaves_like 'create instance of proper class', 1901..1945, Movies::AncientMovie
    end

    context 'when year is in range 1946-1968' do
      it_behaves_like 'create instance of proper class', 1946..1968, Movies::ClassicMovie
    end

    context 'when year is in range 1969-2000' do
      it_behaves_like 'create instance of proper class', 1969..2000, Movies::ModernMovie
    end

    context 'when year is after 2000' do
      it_behaves_like 'create instance of proper class', 2001..Date.today.year, Movies::NewMovie
    end

    context 'when year is undefined' do
      it_behaves_like 'create instance of proper class', nil, Movies::Movie
    end
  end

  describe '#imdb_id' do
    let(:movie) do
      Movies::Movie.create(
        link: 'http://imdb.com/title/tt0133093/?ref_=chttp_tt_18',
        name: 'The Matrix',
        producer: 'Andy Wachowski',
        year: '1999',
        release: '1999-03-31',
        length: '136 min',
        rating: '8.7',
        genres: 'Action,Sci-Fi',
        actors: 'Keanu Reeves,Laurence Fishburne,Carrie-Anne Moss'
      )
    end

    subject { movie.imdb_id }

    it 'returns imdb id for the movie' do
      is_expected.to eq('tt0133093')
    end
  end

  describe '#matches?' do
    let(:movie) do
      Movies::Movie.create(
        name: 'Pulp Fiction',
        producer: 'Quentin Tarantino',
        year: '1994',
        release: '1994-10-14',
        length: '154 min',
        rating: '8.9',
        genres: 'Crime,Drama',
        actors: 'John Travolta,Uma Thurman,Samuel L. Jackson'
      )
    end

    it 'returns TRUE if movie attributes match params' do
      expect(movie.matches?(:year, 1994)).to be_truthy
      expect(movie.matches?(:year, 1991..1994)).to be_truthy
      expect(movie.matches?(:rating, 8.9)).to be_truthy
      expect(movie.matches?(:length, 154)).to be_truthy
      expect(movie.matches?(:genre, 'Drama')).to be_truthy
      expect(movie.matches?(:genres, ['Adventure', 'Drama'])).to be_truthy
      expect(movie.matches?(:actors, 'Uma Thurman')).to be_truthy
    end

    it 'returns FALSE unless movie attributes match params' do
      expect(movie.matches?(:year, 2015)).to be_falsey
      expect(movie.matches?(:year, '1994')).to be_falsey
      expect(movie.matches?(:rating, '8.9')).to be_falsey
      expect(movie.matches?(:genre, 'Adventure')).to be_falsey
      expect(movie.matches?(:genres, 'Crime,Action')).to be_falsey
      expect(movie.matches?(:genre, ['Action', 'History'])).to be_falsey
      expect(movie.matches?(:actors, 'Tom Hanks')).to be_falsey
      expect(movie.matches?(:actors, 'John Travolta ||')).to be_falsey
    end
  end

  describe '#poster_path' do
    subject { movie.poster_path }

    it_behaves_like 'return proper value from file', :poster_path,
      '/An36DV15SQupjsADzsBbYKMDNUs.jpg'
  end

  describe '#title_in_russian' do
    subject { movie.title_in_russian }

    it_behaves_like 'return proper value from file', :title_in_russian,
      'Элитный отряд: Враг внутри'
  end

  describe '#to_s' do
    let (:movie) do
      Movies::Movie.new(
          name: 'The best movie',
          producer: "It's me",
          actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley'
      )
    end
    subject { movie.to_s }

    it 'contents movie name' do
      is_expected.to include(movie.name)
    end
  end
end
