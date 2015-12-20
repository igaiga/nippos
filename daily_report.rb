require_relative "daily_working_time"
class DailyReport
  attr_accessor :date, :body, :name, :url
  attr_reader :daily_working_time
  def initialize(date: nil, body: nil, name: nil, url: nil)
    @date = date.split(/\//)[1..3].join('/').gsub(/\(.*\)\z/, '') # 例: "日報/2015/07/01(水)" → "2015/07/01"
    @body = body
    @name = name
    @url = url
    @daily_working_time = DailyWorkingTime.new(working_times)
    self
  end

  def working_times_sum
    @daily_working_time.sum
  end

  private

  def working_times
    result = []
    hyphen_time = HyphenTime.new
    working_time_area_string.each_line do |line|
      ht =  HyphenTime.new(extract_working_time(line))
      result << ht if ht.valid?
    end
    result
  end

  def working_time_area_string
    # //m は . を複数行マッチさせるモード
    "#{ @body.match(/#\s+勤務時間(.*?)#\s+/m){ |matched| matched[1] } }"
  end

  def extract_working_time(string)
    # "| オフィス | 10:00-13:00 |" の 10:00-13:00 のとこ
    string.split(/\|/)[2]
  end
end

# p DailyReport.new(body: daily_report_body_string).collect_working_time
