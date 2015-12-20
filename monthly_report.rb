class MonthlyReport
  attr_reader :data, :year, :month
  attr_accessor :url

  # @data : DailyReport が入った配列
  def initialize(year: , month: , daily_reports: nil)
    @data = []
    @year = year
    @month = month
    store(daily_reports)
    self
  end

  def add(daily_reports)
    store(daily_reports)
    self
  end

  def working_times_sum
    HyphenTime.hyphen_time_sum(@data.map(&:working_times_sum))
  end

  def total_md
    result_lines = []
    result_lines << "#勤務時間集計"
    result_lines << "| 日付 | 時間 | 日合計 |"
    result_lines << "| --- | --- | --- |"
    weekly_working_min = 0 #週次集計

    (first_day..last_day).each do |date|
      daily_report = find(date)
      if daily_report
        result_lines << "|[#{date_string(date)}](#{daily_report.url})| #{daily_report.daily_working_time.to_hyphen.join ', '} | #{daily_report.working_times_sum} | "
        weekly_working_min += HyphenTime.to_min(daily_report.working_times_sum)
      else
        result_lines << "|#{date_string(date)}| | |"
      end

      if date.saturday? || (date == date.end_of_month) #週次集計
        result_lines << "| |週合計| #{HyphenTime.to_hyphen(weekly_working_min)} |"
        weekly_working_min = 0
      end
    end

    result_lines << "| 月合計 | | #{working_times_sum} |"

    result_lines.join "\n"
  end

  def find(date)
    @data.select{|x| x.date == "#{@year}/#{'%02d' % @month}/#{'%02d' % date.day}" }.first
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

  def first_day
    Date.new(@year, @month, 1).beginning_of_month
  end

  def last_day
    first_day.end_of_month
  end

  def date_string(date)
    "#{date.strftime('%Y/%m/%d')}(#{%w(日 月 火 水 木 金 土)[date.wday]})"
  end
end

# テストデータ(実際の日報body_md)1日分で計算するテストコード
#str_reloaded = File.open("nippo_body", "r") do |f|
#  Marshal.restore(f.read)
#end
# mr = MonthlyReport.new(DailyReport.new(date: Date.today, body: str_reloaded))
# mr.add(DailyReport.new(date: Date.today, body: str_reloaded))
# p mr.collect_working_time

