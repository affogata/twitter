require 'cgi'
require 'twitter/enumerable'
require 'twitter/rest/request'
require 'twitter/utils'
require 'uri'

module Twitter
  module Insights
    class Engagements
      include Twitter::Enumerable
      include Twitter::Utils
      # @return [Hash]
      attr_reader :attrs, :rate_limit, :entries, :unavailable_tweet_ids
      alias to_h attrs
      alias to_hash to_h

      # Initializes a new Engagements object
      #
      # @param request [Twitter::REST::Request]
      # @return [Twitter::Insights::Engagements]
      def initialize(request)
        @client = request.client
        @request_method = request.verb
        @path = request.path
        @options = request.options
        @collection = []
        self.attrs = request.perform
      end

      private

      # @param attrs [Hash]
      # @return [Hash]
      def attrs=(attrs)
        @attrs = attrs
        @attrs
      end

      def unavailable_tweet_ids
        @attrs['unavailable_tweet_ids'] || []
      end

      # Converts query string to a hash
      #
      # @param query_string [String] The query string of a URL.
      # @return [Hash] The query string converted to a hash (with symbol keys).
      # @example Convert query string to a hash
      #   query_string_to_hash("foo=bar&baz=qux") #=> {:foo=>"bar", :baz=>"qux"}
      def query_string_to_hash(query_string)
        query = CGI.parse(URI.parse(query_string).query)
        Hash[query.collect { |key, value| [key.to_sym, value.first] }]
      end
    end

    class TotalEngagements < Engagements
    end

    class Hr28Engagements < Engagements
      attr_reader :start, :end

      def start
        self.attrs[:start]
      end

      def end
        self.attrs[:end]
      end
    end

    class HistoricalEngagements < Engagements
      attr_reader :start, :end

      def start
        self.attrs[:start]
      end

      def end
        self.attrs[:end]
      end
    end

  end
end
