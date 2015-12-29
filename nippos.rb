# $ ACCESS_TOKEN=xxxxx ruby nippos.rb

require "esa"
require "awesome_print"
require_relative "daily_report"
require_relative "monthly_report"
require_relative "hyphen_time"

# require "pry"

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

  # for debug
  # File.open("report_#{name}.txt", 'w') do |f|
  #   f.puts report
  # end

  def run
    year = 2015
    month = 8
    names = ['五十嵐邦明']
    names.each do |name|
      collect_and_upload(name: name, year: year, month: month)
      puts @monthly_report.url
    end
  end

  def collect_and_upload(name: , year: , month: )
    md = collect(name: name, year: year, month: month)
    ap md
    upload(name: name, body_md: md, category: category_string(year: year, month: month) + "集計/" )
  end

  def collect(name: , year: , month: )
    esa_posts = @client.posts(q: "in:#{category_string(year: year, month: month)} name:#{name}", per_page: 100)
    ap "in:#{category_string(year: year, month: month)} name:#{name}"
    @monthly_report = MonthlyReport.new(year: year, month: month)
    esa_posts.body["posts"].map do |post|
      @monthly_report.add(DailyReport.new(name: post["name"], body: post["body_md"], date: post["category"], url: post["url"]))
    end

    @monthly_report.total_md
  end

  def upload(name:, body_md:, category: )
    params = {
        name:     name,
        category: category,
        body_md:  body_md,
        wip:      true,
        message:  'Updated by nippos',
    }
    id = post_number(category: category, name: name)
    response = if id
      @client.update_post(id, params)
    else
      @client.create_post(params)
    end
    @monthly_report.url = response.body["url"]
  end

  def post_number(category: ,name:)
    posts = @client.posts(q: "in:#{category} name:#{name}")
    if posts.body["total_count"] > 0
      posts.body["posts"].first["number"]
    else
      nil
    end
  end

  private

  def category_string(year:, month:)
    "/日報/#{year}/#{'%02d' % month}/"
  end
end

# main
Nippo.new.run
