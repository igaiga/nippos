require "spec_helper"
require_relative "../daily_report"

describe "DailyReport" do
  describe "#new" do
    it { expect{ DailyReport.new(date: "test", body: "test", name: "test", url: "http://example.com") }.to_not raise_error }
  end

  let(:daily_report) {
    DailyReport.new(
      date: "2015/12/02",
      body: "# 勤務時間\n| 場所 | 時間 | 小計 |\n| --- | --- | --- |\n| 自宅 | 8:00-9:00 | 1:00 |\n| オフィス | 12:00-13:00 | 1:00 |\n| オフィス | 14:00-19:20 | 5:20 |\n| 合計 |  | 7:20 |\n # 次のセクション\n ",
      name: "山田太郎",
      url: "http://example.com" )
  }

  describe "#working_times_sum" do
    subject { daily_report.working_times_sum }
    it { is_expected.to eq "7:20"}
  end
end

