
$LOAD_PATH.unshift(File.expand_path('../lib'))

require 'rspec'
require 'movies'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/support/vcr_cassettes"
  config.hook_into :webmock
end
