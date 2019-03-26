require 'twitter/rest/request'
require 'twitter/premium_search_results'
require 'twitter/premium_search_counts'

module Twitter
  module REST
    module PremiumSearch
      MAX_TWEETS_PER_REQUEST = 100
      DEFAULT_PRODUCT = '30day'
      ENTERPRISE_BASE_URL = "https://gnip-api.twitter.com".freeze

      # Returns counts from the 30-Day API that match a specified query.
      #
      # @see https://developer.twitter.com/en/docs/tweets/search/overview/premium
      # @see https://developer.twitter.com/en/docs/tweets/search/api-reference/premium-search#CountsEndpoint
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param query [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :tag Tags can be used to segregate rules and their matching data into different logical groups.
      # @option options [String] :fromDate The oldest UTC timestamp (from most recent 30 days) from which the Tweets will be provided. Date should be formatted as yyyymmddhhmm.
      # @option options [String] :toDate The latest, most recent UTC timestamp to which the activities will be provided. Date should be formatted as yyyymmddhhmm.
      # @option options [String] :bucket The unit of time for which count data will be provided ("day", "hour", "minute").
      # @option options [String] :next This parameter is used to get the next 'page' of results.
      # @return [Twitter::PremiumSearchCounts] Return counts (data volumes) data for the specified query
      def premium_search_counts(query, label, options = {})
        options = options.dup
        product = options.delete(:product) || DEFAULT_PRODUCT
        options[:request_method] ||= :json_post
        request = Twitter::REST::Request.new(self, options.delete(:request_method), "/1.1/tweets/search/#{product}/#{label}/counts.json", options.merge(query: query))
        Twitter::PremiumSearchCounts.new(request)
      end

      def enterprise_search_counts(query, label, options = {})
        options = options.dup
        product = options.delete(:product) || DEFAULT_PRODUCT
        options[:request_method] ||= :json_post
        request = Twitter::REST::Request.new(self, options.delete(:request_method), "#{ENTERPRISE_BASE_URL}/search/#{product}/accounts/#{account_name}/#{label}/counts", options.merge(query: query))
        Twitter::PremiumSearchCounts.new(request)
      end

      # Returns tweets from the 30-Day API that match a specified query.
      #
      # @see https://developer.twitter.com/en/docs/tweets/search/overview/premium
      # @see https://developer.twitter.com/en/docs/tweets/search/api-reference/premium-search.html#DataEndpoint
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param query [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :tag Tags can be used to segregate rules and their matching data into different logical groups.
      # @option options [Integer] :maxResults The maximum number of search results to be returned by a request. A number between 10 and the system limit (currently 500, 100 for Sandbox environments). By default, a request response will return 100 results
      # @option options [String] :fromDate The oldest UTC timestamp (from most recent 30 days) from which the Tweets will be provided. Date should be formatted as yyyymmddhhmm.
      # @option options [String] :toDate The latest, most recent UTC timestamp to which the activities will be provided. Date should be formatted as yyyymmddhhmm.
      # @return [Twitter::PremiumSearchResults] Return tweets that match a specified query with search metadata
      def premium_search(query, label, options = {})
        options = options.dup
        product = options.delete(:product) || DEFAULT_PRODUCT
        options[:maxResults] ||= MAX_TWEETS_PER_REQUEST
        options[:request_method] ||= :json_post
        request = Twitter::REST::Request.new(self, options.delete(:request_method), "/1.1/tweets/search/#{product}/#{label}.json", options.merge(query: query))
        Twitter::PremiumSearchResults.new(request)
      end

      # Returns tweets from the 30-Day API that match a specified query.
      #
      # @see https://developer.twitter.com/en/docs/tweets/search/overview/enterprise
      # @see https://developer.twitter.com/en/docs/tweets/search/api-reference/enterprise-search
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param query [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :tag Tags can be used to segregate rules and their matching data into different logical groups.
      # @option options [Integer] :maxResults The maximum number of search results to be returned by a request. A number between 10 and the system limit (currently 500, 100 for Sandbox environments). By default, a request response will return 100 results
      # @option options [String] :fromDate The oldest UTC timestamp (from most recent 30 days) from which the Tweets will be provided. Date should be formatted as yyyymmddhhmm.
      # @option options [String] :toDate The latest, most recent UTC timestamp to which the activities will be provided. Date should be formatted as yyyymmddhhmm.
      # @return [Twitter::PremiumSearchResults] Return tweets that match a specified query with search metadata
      def enterprise_search(query, account_name, label, options = {})
        options = options.dup
        product = options.delete(:product) || DEFAULT_PRODUCT
        options[:maxResults] ||= MAX_TWEETS_PER_REQUEST
        options[:request_method] ||= :json_post
        request = Twitter::REST::Request.new(self, options.delete(:request_method), "#{ENTERPRISE_BASE_URL}/search/#{product}/accounts/#{account_name}/prod.json", options.merge(query: query))
        Twitter::PremiumSearchResults.new(request)
      end

      def full_archive_search(query, label, options = {})
        premium_search(query, label, options.merge(product: 'fullarchive'))
      end

      def full_archive_counts(query, label, options = {})
        premium_search_counts(query, label, options.merge(product: 'fullarchive'))
      end
    end
  end
end
