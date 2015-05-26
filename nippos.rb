require "esa"
require "awesome_print"
require_relative "hyphen_time"
require_relative "daily_report"

class MonthlyReport
  attr_reader :data

  # @data : DailyReport が入った配列
  def initialize(daily_report = nil)
    @data = []
    store(daily_report)
    self
  end

  def add(arg)
    store(arg)
    self
  end

  def collect_working_time
    HyphenTime.hyphen_time_sum(@data.map(&:collect_working_time))
  end

  private

  def store(arg)
    return unless arg
    case
    when arg.respond_to?(:each)
      arg.each{ |x| @data << x }
    else
      @data << arg
    end
  end

end

# テストデータ(実際の日報body_md)1日分で計算する
str_reloaded = File.open("nippo_body", "r") do |f|
  Marshal.restore(f.read)
end

mr = MonthlyReport.new(DailyReport.new(date: Date.today, body: str_reloaded))
mr.add(DailyReport.new(date: Date.today, body: str_reloaded))
p mr.collect_working_time
