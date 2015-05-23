require 'active_support/all'
require 'awesome_print'
require 'pry'

# HyphenTime データ構造
# data: ["8:00-9:00", "10:00-13:00", ...]
# sum: X:XX
class HyphenTime
  attr_reader :data

  def initialize(arg)
    @data = []
    parse(arg)
  end

  def add(arg)
    parse(arg)
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

  private

  def treat(string)
    string.gsub(/\s+/, '')
  end

  def parse(arg)
    case
    when arg.respond_to?(:each)
        arg.each{ |x| @data << treat(x) }
    else
      @data << treat(arg)
    end
  end

  def to_min(string)
    h,m = string.split(':')
    h.to_i * 60 + m.to_i
  end

  def to_hyphen(arg)
    hh = arg.to_i / 60
    mm = arg.to_i % 60 # TODO: 0 fill
    "#{hh}:#{mm}"
  end

end

h = HyphenTime.new("8:00-9:00")
h.add(["10:00-13:00", "14:00-19:00"])
p h.sum



# str_reloaded = File.open("nippo_body", "r") do |f|
#   Marshal.restore(f.read)
# end
# p str_reloaded
