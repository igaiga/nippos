require 'active_support/all'

# HyphenTime データフォーマット
# data: ["8:00-9:00", "10:00-13:00", ...]
# sum: X:XX
class HyphenTime
  attr_reader :data

  def initialize(arg = nil)
    @data = []
    store(arg)
    self
  end

  def add(arg)
    store(arg)
    self
  end

  def sum
    to_hyphen(sum_min)
  end

  def sum_min
    data.map { |hyphen_string|
      from, to = hyphen_string.split(/-/)
      to_min(to) - to_min(from) 
    }.sum
  end

  def adapt_string?(arg)
    return false unless arg
    !!(arg =~ /\d+:\d+-\d+:\d+/)
  end

  # TODO "8:00" が HyphenTime で、"8:00-9:00" はHyphenTimeRange とかになるべき。
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

  private

  # in " 9 : 00 - 10 : 00 ", out: "9:00-10:00"
  def treat(string)
    string.gsub(/\s+/, '')
  end

  # in: "9:00-10:00" or ["9:00-10:00", ...]
  def store(arg)
    return unless arg
    return unless adapt_string?(arg)
    case
    when arg.respond_to?(:each)
        arg.each{ |x| @data << treat(x) }
    else
      @data << treat(arg)
    end
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
