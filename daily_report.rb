class DailyReport
  attr_accessor :date, :body
  def initialize(date: nil, body: nil)
    @date = date
    @body = body
    self
  end
  def collect_working_time
    hyphen_time = HyphenTime.new
    working_time_area_string.each_line do |line|
      hyphen_time.add(extract_working_time(line))
    end
    hyphen_time.sum
  end

  private

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
