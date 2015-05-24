require "esa"
require "awesome_print"
require_relative "hyphen_time"
require_relative "daily_report"

#TODO: 複数日報収集(クラス名命名)
class MonthlyReport
  attr_reader :data

  # @data : DailyReport が入った配列
  def initialize(arg = nil)
    @data = []
    store(arg)
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
      arg.each{ |x| @data << DailyReport.new(x) }
    else
      @data << DailyReport.new(arg)
    end
  end

end
# テストデータ(実際の日報body_md)1日分で計算する
str_reloaded = File.open("nippo_body", "r") do |f|
  Marshal.restore(f.read)
end
mr = MonthlyReport.new(str_reloaded)
mr.add(str_reloaded)
p mr.collect_working_time
