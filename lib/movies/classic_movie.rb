# coding: utf-8
# frozen_string_literal: true

class ClassicMovie < Movie
  def period
    :classic
  end

  def price
    1.5
  end

  def to_s
    "#{name} - классический фильм (#{@genres}), режиссер #{producer}, снял также #{producer_movies}"
  end

  private

  def producer_movies
    @collection
      .filter(producer: producer)
      .reject { |m| m === self }
      .map(&:name)
      .join(', ')
  end
end
