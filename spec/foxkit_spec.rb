require 'spec_helper'

describe Foxkit do
  describe ".client" do
    it "create a Foxkit::Client" do
      expect(Foxkit.client).to be_kind_of Foxkit::Client
    end
  end
end
