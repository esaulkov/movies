# coding: utf-8
# frozen_string_literal: true

module Movies
  module Cinema
    class CountrySelection
      def initialize(collection)
        @collection = collection
        @countries = @collection.stats(:country).keys.map { |country| country.downcase.tr(' ', '_') }
      end

      def method_missing(name)
        if valid_name?(name)
          @collection.filter(country: regex(name))
        else
          super
        end
      end

      def respond_to_missing?(name, *)
        valid_name?(name) || super
      end

      private

      def regex(name)
        /#{name.to_s.tr('_', ' ')}/i
      end

      def valid_name?(name)
        @countries.include?(name.to_s)
      end
    end
  end
end
