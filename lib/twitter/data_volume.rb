require 'twitter/base'

module Twitter
  class DataVolume < Twitter::Base
    attr_reader :timePeriod, :count

    def time_period
      attrs[:timePeriod]
    end

    def count
      attrs[:count]
    end
  end
end
