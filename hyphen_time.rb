require 'active_support/all'

# TODO: "8:00" が HyphenTime で、"8:00-9:00" はHyphenTimeRange とかの方がいい？

# HyphenTime データフォーマット
# data: "8:00-9:00"
class HyphenTime
  attr_reader :data

  def initialize(arg = nil)
    @data = nil
    store(arg)
    self
  end

  def from
    @data.split(/-/)[0]
  end

  def to
    @data.split(/-/)[1]
  end

  def add(arg)
    store(arg)
    self
  end

  def sum_min
    from, to = @data.split(/-/)
    to_min(to) - to_min(from) 
  end

  def in_range(range_hyphen_time)
    range_from = range_hyphen_time.from
    range_to = range_hyphen_time.to
    ranged_data_from = self.class.to_hyphen([HyphenTime.to_min(range_hyphen_time.from), HyphenTime.to_min(from)].max)
    ranged_data_to   = self.class.to_hyphen([HyphenTime.to_min(range_hyphen_time.to)  , HyphenTime.to_min(to)].min)
    self.class.new("#{ranged_data_from}-#{ranged_data_to}")
  end

  def adapt_string?(arg)
    return false unless arg
    !!(treat(arg) =~ /\d+:\d+-\d+:\d+/)
  end

  # in: "8:00", out: 400
  def self.to_min(string)
    h, m = string.split(':')
    h.to_i * 60 + m.to_i
  end
  # in: "240", out: "4:00"
  def self.to_hyphen(arg)
    h = arg.to_i / 60
    m = arg.to_i % 60
    "#{h}:#{format("%02d", m)}"
  end

  # in: ["8:00", "9:00"], out: 1020
  def self.hyphen_time_sum_minutes(array)
    array.map{ |x| to_min(x) }.sum
  end

  # in: ["8:00", "9:00"], out: "17:00"
  def self.hyphen_time_sum(array)
    to_hyphen(hyphen_time_sum_minutes(array))
  end

  def valid?
    adapt_string?(@data)
  end

  private

  # in " 9 : 00 - 10 : 00 ", out: "9:00-10:00"
  def treat(string)
    string.gsub(/\s+/, '')
  end

  # in: "9:00-10:00"
  def store(arg)
    return unless arg
    return unless adapt_string?(arg)
    @data = treat(arg)
  end

  def to_min(string)
    self.class.to_min(string)
  end

  def to_hyphen(arg)
    self.class.to_hyphen(arg)
  end

end

# # sample
# ht = HyphenTime.new("8:00-9:00")
# ht.add(["10:00-13:00", "14:00-19:00"])
# p ht.sum
