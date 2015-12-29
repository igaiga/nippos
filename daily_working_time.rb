require_relative "hyphen_time"
# [HyphenTime1, HyphenTime2, ...]

class DailyWorkingTime
  attr_reader :data
  def initialize(*hyphen_times)
    @data = []
    return unless hyphen_times
    # HyphenTime 単体でも Array でも対応
    @data = [hyphen_times].flatten
  end

  def sum
    HyphenTime.to_hyphen(@data.map(&:sum_min).sum)
  end

  def midnight_sum
    midnights = [HyphenTime.new("0:00-5:00"), HyphenTime.new("22:00-29:00")]
    midnights_total_min = midnights.map { |midnight|
      @data.map{|x| x.in_range(midnight).sum_min }.sum
    }.sum
    HyphenTime.to_hyphen(midnights_total_min)
  end

  def to_hyphen
    @data.map(&:data)
  end
end
