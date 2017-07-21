# coding: utf-8
# frozen_string_literal: true

module Movies
  # Namespace for classes that work with cinema and its elements
  module Cinema
    # Class for online cinema
    # @!attribute [r] balance
    #   @return [Money] user balance. Decreases by the movie show.
    # @!attribute [r] filters
    #   @return [Array<Hash, Proc>] user filters for this cinema.
    # @!attribute [r] collection
    #   @return [MovieCollection] movie collection that used by this cinema.
    class Netflix < Cinema
      # Helpful messages
      MONEY_MSG = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'
      NEGATIVE_VALUE_MSG = 'Нельзя пополнить баланс на отрицательную сумму'
      NOT_FOUND_MSG = 'Такой фильм не найден'

      extend Cashbox

      attr_reader :balance, :filters, :collection

      # Creates an instance of cinema
      # @param [MovieCollection] collection movie collection that used by this cinema.
      # @return [Netflix] an instance of Netflix
      def initialize(collection)
        super
        @balance = Money.new(0)
        @filters = {}
      end

      # Prepares cinema collection to filter by country
      # @example Find all movies from Spain
      #   cinema.by_country.spain
      #   => [#<Movie Pan's Labyrinth - новинка, вышло 11 лет назад! (Drama, Fantasy, War)>]
      #
      # @return [CountrySelection]
      def by_country
        CountrySelection.new(@collection)
      end

      # Prepares cinema collection to filter by genre
      # @example Find all music movies
      #   cinema.by_genre.music =>
      #   [#<Movie Whiplash - новинка, вышло 3 года назад! (Drama, Music)>,
      #   #<Movie Departures - новинка, вышло 9 лет назад! (Drama, Music)>]
      #
      # @return [GenreSelection]
      def by_genre
        GenreSelection.new(@collection)
      end

      # Saves user filter or creates new from existing filter
      # @param [Symbol] name filter name
      # @param [Symbol] from ('') name of another filter which should be used
      # @param [String, Integer] arg ('') argument value that used by the new filter
      # @param [Proc] block
      #
      # @example Create filter from a block
      #   cinema.define_filter(:sci_fi) do |movie, year|
      #     movie.year < year && movie.genre.include?('Sci-Fi')
      #   end
      #   => <Proc:0x00000002707950@(irb):5>
      #
      # @example Create filter from another filter
      #   cinema.define_filter(:ancient_sci_fi, from: :sci_fi, arg: 1941)
      #   => <Proc:0x0000000271eab0@(irb):8>
      #
      # @return [Proc] filter that can be used later
      def define_filter(name, from: nil, arg: nil, &block)
        return @filters[name] = block if from.nil?

        @filters[name] = ->(movie) { @filters[from].call(movie, arg) }
      end

      # Shows movie from cinema collection by params
      # @param [Hash] opts ({}) list of params that will be used for movie selection
      # @option opts [String] name movie name
      # @option opts [Symbol] period one of the list(:ancient, :classic, :modern, :new),
      #   depends on movie year
      # @option opts [String, Array<String>] genre specifies genre of selected movie.
      #   Could be array, if you want to watch one of several genres (e.g. Adventure or Action)
      # @option opts [String] country movie country
      # @option opts [Integer, Range] year release year or range of years
      # @option opts [String] producer movie producer
      # @option opts [String, Array<String>] actors show movie with defined actor (one or more)
      # @param [Proc] block condition to select movie from collection, written at Ruby.
      #   Could be used for comparising ({ |movie| movie.rating > 8.1 }),
      #   negation ({ |movie| !movie.country == 'Japan' })
      #   or weak filter ({ |movie| movie.name.include?('Termin') })
      #
      # @example By opts
      #   cinema.show(genre: 'Comedy', period: :modern)
      #   => "Now showing: Cinema Paradiso - современное кино (Comedy, Drama),
      #       играют Philippe Noiret, Enzo Cannavale, Antonella Attili"
      #
      # @example By block
      #   cinema.show { |movie| movie.genre.include?('Action') && movie.year > 2003 }
      #   => "Now showing: Batman Begins - новинка, вышло 12 лет назад! (Action, Adventure)"
      #
      # @raise [ArgumentError] when balance is lesser than movie price
      #
      # @return [String] string with movie description
      def show(opts = {}, &block)
        args = process_filters(opts)
        args << block if block_given?
        selection = @collection.filter(args)
        movie = choice(selection)

        raise ArgumentError, MONEY_MSG if @balance < movie.price

        @balance -= movie.price
        display(movie)
      end

      # Renders movie collection to HTML format
      # @return [String] result message (success or not)
      def render
        output = Utils::HamlPresenter.new(self).show
        res = File.write('data/result.html', output)
        res > 0 ? 'Cinema rendered successfully' : 'Nothing to render'
      end

      # Increases sum of balance. This balance is required to show movie.
      # Every time when 'show' method is called, balance is decreased accordingly movie price.
      #
      # @param [Integer] sum of money
      #
      # @raise [ArgumentError] when argument is negative
      def pay(sum)
        raise ArgumentError, NEGATIVE_VALUE_MSG if sum.negative?
        @balance += Money.new(sum * 100.0)
        Netflix.put_money(sum.to_f)
      end

      # Defines price of the movie
      # @param [String] name movie name
      #
      # @raise [ArgumentError] when movie does not found
      #
      # @return [String] movie price
      def how_much?(name)
        movie = @collection.filter(name: name).first
        raise ArgumentError, NOT_FOUND_MSG if movie.nil?
        movie.price.format
      end

      private

      # Converts filter by the argument value
      # @private
      #
      # @param [Symbol] key filter name
      # @param [Boolean, String, Integer] value can be true, false or something else
      #
      # @return [Proc] filter
      def convert_filter(key, value)
        case value
        when true then @filters[key]
        when false then ->(movie) { !@filters[key].call(movie) }
        else ->(movie) { @filters[key].call(movie, value) }
        end
      end

      # Tries to find and convert filter by params. Otherwise returns param pair as is.
      # @private
      # @param [Hash] params user parameters
      #
      # @return [Array<Proc, Hash>] filters to show movie
      def process_filters(params)
        params.map do |key, value|
          @filters.key?(key) ? convert_filter(key, value) : {key => value}
        end
      end
    end
  end
end
