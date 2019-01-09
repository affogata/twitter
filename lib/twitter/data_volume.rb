require 'twitter/base'
require 'time'

module Twitter
  class DataVolume < Twitter::Base
    attr_reader :time_period, :count

    def time_period
      Time.zone = "UTC"
      Time.parse(attrs[:timePeriod])
    end

    def count
      attrs[:count]
    end
  end
end
