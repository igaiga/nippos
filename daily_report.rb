class DailyReport
  attr_accessor :date, :body, :name
  def initialize(date: nil, body: nil, name: nil)
    @date = date.split(/\//)[1..3].join('/').gsub(/\(.*\)\z/, '') # 例: "日報/2015/07/01(水)" → "2015/07/01"
    @body = body
    @name = name
    self
  end

  def working_times
    result = []
    hyphen_time = HyphenTime.new
    working_time_area_string.each_line do |line|
      ht =  HyphenTime.new(extract_working_time(line))
      result << ht if ht.valid?
#      hyphen_time.add(extract_working_time(line)) #旧コード
    end
    result
  end

  def working_times_sum
    HyphenTime.to_hyphen(working_times.map(&:sum_min).sum)
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
