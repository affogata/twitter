require 'twitter/rest/request'
require 'twitter/insights/engagements'

module Twitter
  module REST
    module Engagements
      BASE_URL = "https://data-api.twitter.com".freeze

      # Returns a set of insights from the Enterprise Engagements API for unlimited time
      #
      # @see https://developer.twitter.com/en/docs/metrics/get-tweet-engagement/overview
      # @see https://developer.twitter.com/en/docs/metrics/get-tweet-engagement/api-reference/post-insights-engagement#Totals
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param tweets [Integer, String] An array that includes the Tweet IDs for the Tweets to be queried for engagement data
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :engagement_types An array that includes the types of engagement metrics to be queried. The Totals endpoint supports only the following engagement types: impressions, engagements, favorites, retweets, replies, video_views.
      # @option options [Hash] :groupings Results from the Engagement API can be returned in different groups to best fit your needs. You can include a maximum of 3 groupings per request
      # @return [Twitter::TotalEngagements] Return insights objects for the retrieved engagements
      def tweet_engagements_totals(tweets, options = {})
        Twitter::Insights::TotalEngagements.new(tweet_engagements('totals', tweets, options))
      end

      # Returns a set of insights from the Enterprise Engagements API for the last 28 hours
      #
      # @see https://developer.twitter.com/en/docs/metrics/get-tweet-engagement/overview
      # @see https://developer.twitter.com/en/docs/metrics/get-tweet-engagement/api-reference/post-insights-engagement#28hr
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param tweets [Integer, String] An array that includes the Tweet IDs for the Tweets to be queried for engagement data
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :engagement_types An array that includes the types of engagement metrics to be queried. The Totals endpoint supports only the following engagement types: impressions, engagements, favorites, retweets, replies, video_views.
      # @option options [Hash] :groupings Results from the Engagement API can be returned in different groups to best fit your needs. You can include a maximum of 3 groupings per request
      # @return [Twitter::Hr28Engagements] Return insights objects for the retrieved engagements
      def tweet_engagements_hr28(tweets, options = {})
        options[:engagement_types] ||= ["impressions", "engagements", "favorites", "retweets", "replies", "media_views", "media_engagements", "url_clicks", "hashtag_clicks", "detail_expands", "permalink_clicks", "app_install_attempts", "app_opens", "email_tweet", "user_follows", "user_profile_clicks"]
        Twitter::Insights::Hr28Engagements.new(tweet_engagements('28hr', tweets, options))
      end

      # Returns a set of insights from the Enterprise Engagements API with bounded time-frame
      #
      # @see https://developer.twitter.com/en/docs/metrics/get-tweet-engagement/overview
      # @see https://developer.twitter.com/en/docs/metrics/get-tweet-engagement/api-reference/post-insights-engagement#Historical
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param tweets [Integer, String] An array that includes the Tweet IDs for the Tweets to be queried for engagement data
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :engagement_types An array that includes the types of engagement metrics to be queried. The Totals endpoint supports only the following engagement types: impressions, engagements, favorites, retweets, replies, video_views.
      # @option options [Hash] :groupings Results from the Engagement API can be returned in different groups to best fit your needs. You can include a maximum of 3 groupings per request
      # @option options [String] :start A start date or datetime string can be supplied to limit the scope of the engagements retrieval
      # @option options [String] :end An end date or datetime string can be supplied to limit the scope of the engagements retrieval
      # @return [Twitter::HistoricalEngagements] Return insights objects for the retrieved engagements
      def tweet_engagements_historical(tweets, options = {})
        options[:engagement_types] ||= ["impressions", "engagements", "favorites", "retweets", "replies", "media_views", "media_engagements", "url_clicks", "hashtag_clicks", "detail_expands", "permalink_clicks", "app_install_attempts", "app_opens", "email_tweet", "user_follows", "user_profile_clicks"]
        Twitter::Insights::HistoricalEngagements.new(tweet_engagements('historical', tweets, options))
      end

      def tweet_engagements(product, tweets, options = {})
        options = options.dup
        options[:tweet_ids] = tweets
        options[:engagement_types] ||= ["impressions", "engagements", "favorites", "retweets", "replies", "video_views"]
        options[:engagement_types] = options[:engagement_types].join(",")
        options[:request_method] ||= :json_post
        options[:headers] = {'Accept-Encoding' => 'gzip'}
        Twitter::REST::Request.new(self, options.delete(:request_method), "#{BASE_URL}/insights/engagement/#{product}", options)
      end
    end
  end
end
