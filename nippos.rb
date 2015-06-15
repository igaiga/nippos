# $ ACCESS_TOKEN=xxxxx ruby nippos.rb

require "esa"
require "awesome_print"
require_relative "daily_report"
require_relative "monthly_report"
require_relative "hyphen_time"
require "pry"

# TODO: Gemfile
# TODO: ここをクラス化
# TODO: トークンを設定ファイルへ
unless ENV["ACCESS_TOKEN"]
  puts "example: $ ACCESS_TOKEN=xxxxx ruby nippos.rb"
  exit
end
client = Esa::Client.new(access_token: ENV["ACCESS_TOKEN"],
                         current_team: 'spicelife')

year = 2015
month = 6
name = '五十嵐邦明'

esa_posts = client.posts(q: "in:/日報/#{year}/#{'%02d' % month}/ name:#{name}", per_page: 100)

monthly_report = MonthlyReport.new(year: year, month: month)
esa_posts.body["posts"].map do |post|
  monthly_report.add(DailyReport.new(name: post["name"], body: post["body_md"], date: post["category"]))
end
# TODO: 週次集計
# TODO: エラー処理を1日だけに閉じ込める

#ap monthly_report.data.map(&:date) #月の日報が書かれている日
#ap monthly_report.working_times_sum #月合計勤務時間
monthly_report.total_md

# TODO: 集計結果を集計ページへAPIで投稿

# TODO: 6月分全員集計＆動作確認(週次集計してからやりたい)
