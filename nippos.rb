# ACCESS_TOKEN=xxxxx ruby nippos.rb

require "esa"
require "awesome_print"
require_relative "daily_report"
require_relative "monthly_report"
require_relative "hyphen_time"
require "pry"

# TODO: トークンを設定ファイルへ
client = Esa::Client.new(access_token: ENV["ACCESS_TOKEN"],
                         current_team: 'spicelife')

# TODO: 名前指定、月指定
esa_posts = client.posts(q: 'in:/日報/2015/06/ name:五十嵐邦明', per_page: 100)

monthly_report = MonthlyReport.new
esa_posts.body["posts"].map do |post|
  monthly_report.add(DailyReport.new(name: post["name"], body: post["body_md"], date: post["category"]))
end

# TODO: 集計結果を集計ページへ投稿

#ap monthly_report
ap monthly_report.data.map(&:date) #月の日報が書かれている日
ap monthly_report.working_times_sum #月合計勤務時間
