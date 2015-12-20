require "spec_helper"
require_relative "../hyphen_time"
require_relative "../daily_working_time"

describe "DailyWorkingTime" do
  describe "#new" do
    context "no arg" do
      it { expect{ DailyWorkingTime.new }.to_not raise_error }
    end
    context "1 arg" do
      describe "#new(HyphenTime)" do
        subject { DailyWorkingTime.new(HyphenTime.new('8:00-9:00')).data.count }
        it { is_expected.to eq 1 }
      end
    end
    context "2 args" do
      describe "#new([HyphenTime,..])" do
        subject { DailyWorkingTime.new(HyphenTime.new('8:00-9:00'), HyphenTime.new('10:00-11:00')).data.count }
        it { is_expected.to eq 2 }
      end
    end
  end

  describe "#sum" do
    subject {
      DailyWorkingTime.new(
        HyphenTime.new('8:00-9:30'),
        HyphenTime.new('10:00-11:00')).sum }
    it { is_expected.to eq '2:30' }

    context "24時をまたぐ時" do
      subject do
        DailyWorkingTime.new(
          HyphenTime.new('8:00-9:00'),
          HyphenTime.new('23:30-25:30')).sum
      end
      it { is_expected.to eq '3:00' }
    end
  end

  describe "#midnight_sum" do
    # 22:00-29:00(=AM5:00) が対象
    subject {
      DailyWorkingTime.new(
        HyphenTime.new('20:00-23:30'),
        HyphenTime.new('24:00-25:00'),
        HyphenTime.new('28:00-30:00')
      ).midnight_sum }
    it { is_expected.to eq '3:30' }
  end

  describe "#to_hyphen" do
    subject {
      DailyWorkingTime.new(
        HyphenTime.new('8:00-9:30'),
        HyphenTime.new('10:00-11:00')).to_hyphen }
    it { is_expected.to eq ['8:00-9:30', '10:00-11:00'] }
  end

end
