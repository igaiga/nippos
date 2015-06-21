# $ ACCESS_TOKEN=xxxxx ruby nippos.rb

require "esa"
require "awesome_print"
require_relative "daily_report"
require_relative "monthly_report"
require_relative "hyphen_time"
require "pry"

# TODO: Gemfile
# TODO: トークンを設定ファイルへ

class Nippo
  def initialize(access_token: ENV["ACCESS_TOKEN"], current_team: 'spicelife')
    unless access_token
      puts "example: $ ACCESS_TOKEN=xxxxx ruby nippos.rb"
      exit
    end
    @client = Esa::Client.new(access_token: access_token, current_team: current_team)
    self
  end

  def collect(name: , year: , month: )
    esa_posts = @client.posts(q: "in:/日報/#{year}/#{'%02d' % month}/ name:#{name}", per_page: 100)

    monthly_report = MonthlyReport.new(year: year, month: month)
    esa_posts.body["posts"].map do |post|
      monthly_report.add(DailyReport.new(name: post["name"], body: post["body_md"], date: post["category"]))
    end

    #ap monthly_report.data.map(&:date) #月の日報が書かれている日
    #ap monthly_report.working_times_sum #月合計勤務時間
    monthly_report.total_md
  end

  # TODO: 集計結果を集計ページへAPIで投稿

end

names = ['五十嵐邦明']

names.each do |name|
  report = Nippo.new.collect(name: name, year: 2015, month: 6)
  ap "#{name}: #{report}"
  File.open("report_#{name}.txt", 'w') do |f|
    f.puts report
  end
end
