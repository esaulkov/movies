#coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movies/version'

Gem::Specification.new do |spec|
  spec.name          = 'movies'
  spec.version       = Movies::VERSION
  spec.authors       = ['Evgeny Esaulkov']
  spec.email         = ['evg.esaulkov@gmail.com']
  spec.description   = %q{Shows different information about top 250 movies}
  spec.summary       = %q{Information about popular movies}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'dotenv', '~> 2.2.1', '>= 2.2.1'
  spec.add_dependency 'haml', '~> 5.0.1', '>= 5.0.1'
  spec.add_dependency 'money', '~> 6.9.0', '>= 6.9.0'
  spec.add_dependency 'nokogiri', '~> 1.8.0', '>= 1.8.0'
  spec.add_dependency 'progress_bar', '~> 1.1.0', '>= 1.1.0'
  spec.add_dependency 'slop', '~> 4.5.0', '>= 4.5.0'
  spec.add_dependency 'themoviedb-api', '~> 1.2.0', '>= 1.2.0'
  spec.add_dependency 'virtus', '~> 1.0.5', '>= 1.0.5'
  spec.add_development_dependency 'rake', '~> 10.4.2', '>= 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.6.0', '>= 3.6.0'
  spec.add_development_dependency 'vcr', '~> 3.0.3', '>= 3.0.3'
  spec.add_development_dependency 'webmock', '~> 3.0.1', '>= 3.0.1'
end
