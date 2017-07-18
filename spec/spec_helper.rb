
$LOAD_PATH.unshift(File.expand_path('../lib'))

require 'rspec'
require 'movies'
require 'webmock/rspec'
require 'vcr'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /api.themoviedb.org/).to_rack(FakeTmdb)
  end
end
