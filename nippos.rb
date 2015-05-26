require "esa"
require "awesome_print"
require_relative "hyphen_time"
require_relative "daily_report"

# TODO: monthly_report.rb へ移動
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

# テストデータ(実際の日報body_md)1日分で計算するテストコード
#str_reloaded = File.open("nippo_body", "r") do |f|
#  Marshal.restore(f.read)
#end
# mr = MonthlyReport.new(DailyReport.new(date: Date.today, body: str_reloaded))
# mr.add(DailyReport.new(date: Date.today, body: str_reloaded))
# p mr.collect_working_time

# テストデータ(実際の日報)複数日分で計算するテストコード
# TODO: DailyReportへ移動
class Nippo
  attr_accessor :name, :body, :date
  def initialize(name: nil, body: nil, date: nil)
    @name = name
    @body = body
    @date = date #TODO: "日報/2015/05/18" のスタイルで来るから整形
  end
end
reloaded_hash = File.open("nippos", "r") do |f|
  Marshal.restore(f.read)
end
# 全員の日報bodyデータ
mr = MonthlyReport.new
reloaded_hash.values.flatten.map(&:body).each do |body|
  mr.add(DailyReport.new(date: Date.today, body: body))
end
ap mr
ap mr.collect_working_time

# TODO: esaclientを持ってくる
# client = Esa::Client.new(access_token: "xxx",
#                          current_team: 'spicelife')
# esa_posts = client.posts(q: 'in:/日報/2015/05/')
# #TODO: ページネーション
# # ページネーション考慮 http://esa-pages.io/p/sharing/105/posts/102/12c5eb215034628c6a8d.html#2-7-0
# # p client.posts(page: 4)
# nippos = {}
# esa_posts.body["posts"].map do |post|
#   nippos[post["name"]] = [] if nippos[post["name"]].nil?
#   nippos[post["name"]] << Nippo.new(name: post["name"], body: post["body_md"], date: post["category"])
# end
# ap nippos
