# coding: utf-8

class Database
  NAME_INDEX = 1.freeze
  RATING_INDEX = 7.freeze

  attr_reader :movies

  def initialize
    @movies = []
  end

  def load(path)
    db = File.new(path, 'r')
    db.each_line do |line|
      movie_params = line.split('|')
      @movies << {name: movie_params[NAME_INDEX], rating: movie_params[RATING_INDEX].to_f}
    end
  end

  def names
    @movies.map { |movie| movie[:name] }
  end

  def rating(name)
    selected_movie = @movies.select { |movie| movie[:name] == name }.first
    selected_movie[:rating]
  end

  def search(search_string)
    names.select { |name| name.include?(search_string) }
  end
end
