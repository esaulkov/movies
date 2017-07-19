
$LOAD_PATH.unshift(File.expand_path('../lib'))

require 'rspec'
require 'movies'
require 'webmock/rspec'
require 'vcr'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /api.themoviedb.org/)
      .and_return(
        status: 200,
        body: File.open(File.dirname(__FILE__) + '/support/vcr_cassettes/movies.json', 'rb').read
      )

    stub_request(:any, /imdb.com/)
      .and_return(
        status: 200,
        body: File.open(File.dirname(__FILE__) + '/support/vcr_cassettes/movie.html', 'rb').read
      )
  end
end
