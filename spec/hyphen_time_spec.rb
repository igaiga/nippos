require "spec_helper"
require_relative "../hyphen_time"

describe "HyphenTime" do
  describe "#new" do
    it { expect{ HyphenTime.new }.to_not raise_error }
    it { expect{ HyphenTime.new("8:00-9:00") }.to_not raise_error }
    it { expect{ HyphenTime.new(["8:00-9:00", "10:00-13:00"]) }.to raise_error(NoMethodError) }
  end
end
