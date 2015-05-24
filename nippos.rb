require "esa"
require "awesome_print"
require_relative "hyphen_time"
require_relative "daily_report"

#TODO: 複数日報収集(クラス名命名)

# テストデータ(実際の日報body_md)1日分で計算する
str_reloaded = File.open("nippo_body", "r") do |f|
  Marshal.restore(f.read)
end
p DailyReport.new(str_reloaded).collect_working_time

