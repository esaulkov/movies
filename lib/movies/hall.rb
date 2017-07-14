# coding: utf-8
# frozen_string_literal: true

module Movies
  class Hall
    attr_reader :name, :title, :places

    def initialize(name, title: '', places: '')
      @name = name
      @title = title
      @places = places
    end
  end
end
