# coding: utf-8
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'yaml'

module Movies
  module Utils
    class ImdbParser
      attr_reader :budgets

      def initialize
        @budgets = {}
      end

      def run(collection)
        bar = ProgressBar.new(collection.size, :bar, :counter, :eta)
        collection.each do |movie|
          url = "http://www.imdb.com/title/#{movie.imdb_id}"

          doc = Nokogiri::HTML(open(url))
          budget = find_text(doc, 'Budget:')

          @budgets[movie.imdb_id] = budget unless budget.nil?
          bar.increment!
        end
      end

      def save
        File.write(Movies::MovieCollection::BUDGETS_FILE, @budgets.to_yaml)
      end

      private

      def find_text(doc, str)
        node = doc.at_xpath("//h4[contains(text(), '#{str}')]")
        return if node.nil?

        node
          .parent
          .children
          .select { |child| child.is_a?(Nokogiri::XML::Text) }
          .map(&:text)
          .join('')
          .strip
      end
    end
  end
end
