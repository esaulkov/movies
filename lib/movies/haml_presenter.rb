# coding: utf-8
# frozen_string_literal: true

require 'haml'

module Movies
  class HamlPresenter
    TEMPLATE_DIR = 'lib/movies/templates/'

    def initialize(object)
      template = File.read("#{template_name(object.class.to_s)}.haml")
      @engine = Haml::Engine.new(template)
      @object = object
    end

    def show
      @engine.render(@object)
    end

    private

    def template_name(class_name)
      class_name
        .gsub(/Movies::/, TEMPLATE_DIR)
        .gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end
  end
end
