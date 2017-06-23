# coding: utf-8
# frozen_string_literal: true

require_relative 'movie'

class ModernMovie < Movie
  def to_s
    "#{name} - современное кино, играют #{@actors})"
  end
end
