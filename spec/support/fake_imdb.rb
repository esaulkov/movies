# coding: utf-8
# frozen_string_literal: true

require 'sinatra/base'

class FakeImdb < Sinatra::Base
  get '/title/:imdb_id' do
    html_response 200, 'movie.html'
  end

  private

  def html_response(response_code, file_name)
    content_type :html
    status response_code
    File.open(File.dirname(__FILE__) + '/vcr_cassettes/' + file_name, 'rb').read
  end
end
