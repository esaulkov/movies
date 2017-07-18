# coding: utf-8
# frozen_string_literal: true

require 'sinatra/base'

class FakeTmdb < Sinatra::Base
  get '/3/find/:external_id' do
    json_response 200, 'movies.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/vcr_cassettes/' + file_name, 'rb').read
  end
end
