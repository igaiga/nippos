class MonthlyReport
  attr_reader :data

  # @data : DailyReport が入った配列
  # TODO: 引数に日報配列を渡せるように（そんなに要らない？）
  def initialize(daily_report = nil)
    @data = []
    store(daily_report)
    self
  end

  def add(arg)
    store(arg)
    self
  end

  def working_times_sum
    HyphenTime.hyphen_time_sum(@data.map(&:working_times_sum))
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

# テストデータ(実際の日報body_md)1日分で計算するテストコード
#str_reloaded = File.open("nippo_body", "r") do |f|
#  Marshal.restore(f.read)
#end
# mr = MonthlyReport.new(DailyReport.new(date: Date.today, body: str_reloaded))
# mr.add(DailyReport.new(date: Date.today, body: str_reloaded))
# p mr.collect_working_time

