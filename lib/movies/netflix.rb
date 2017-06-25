# coding: utf-8
# frozen_string_literal: true

class Netflix
  attr_reader :balance

  def initialize(collection)
    @collection = collection
    @balance = 0.0
  end

  def show(filter = {})
    if filter.empty?
      selection = @collection.all
    else
      params = validate_filter(filter)
      selection = @collection.filter(params)
    end
    movie = choice(selection)

    if @balance > price(movie)
      @balance -= price(movie)

      "Now showing: #{movie}"
    else
      msg = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'
      raise ArgumentError, msg
    end
  end

  def pay(sum)
    @balance += sum.to_f
  end

  def how_much?(name)
    movie = @collection.filter(name: name).first
    price(movie)
  end

  private

  def choice(movies)
    target = rand(sum_of_ratings(movies))
    movies.each do |movie|
      return movie if target <= movie.rating
      target -= movie.rating
    end
  end

  def price(movie)
    case movie.year
    when 1900..1945 then 1
    when 1946..1968 then 1.5
    when 1969..2000 then 3
    else 5
    end
  end

  def sum_of_ratings(movies)
    movies.inject(0) { |sum, movie| sum + movie.rating }
  end

  def validate_filter(params)
    if params.has_key?(:period)
      case params[:period]
      when :ancient then params[:year] = 1900..1945
      when :classic then params[:year] = 1946..1968
      when :modern then params[:year] = 1969..2000
      when :new then params[:year] = 2001..DateTime.now.year
      end

      params.delete(:period)
    end

    if params.has_key?(:genre)
      params[:genres] = params.delete(:genre)
    end

    params
  end
end
