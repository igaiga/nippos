require "esa"
require "awesome_print"
require_relative "hyphen_time"
require_relative "daily_report"
require_relative "monthly_report"

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
# reloaded_hash.values.flatten.frist(1).map(&:body).each do |body| #1人
reloaded_hash.values.flatten.map(&:body).each do |body|
  mr.add(DailyReport.new(date: Date.today, body: body))
end

ap mr
ap mr.working_times_sum

#require "pry"; binding.pry

# TODO: esaclientを持ってくる
# client = Esa::Client.new(access_token: "xxx",
#                          current_team: 'spicelife')
# esa_posts = client.posts(q: 'in:/日報/2015/05/')
# #TODO: ページネーション
# # ページネーション考慮 http://esa-pages.io/p/sharing/105/posts/102/12c5eb215034628c6a8d.html#2-7-0
# #TODO: ↑ページネーションと思ってたけど、その人の投稿だけに in とか使って絞れればページネーションしなくて良さそう

# # p client.posts(page: 4)
# nippos = {}
# esa_posts.body["posts"].map do |post|
#   nippos[post["name"]] = [] if nippos[post["name"]].nil?
#   nippos[post["name"]] << Nippo.new(name: post["name"], body: post["body_md"], date: post["category"])
# end
# ap nippos
