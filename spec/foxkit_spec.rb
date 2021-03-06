require "spec_helper"

describe Foxkit do

  before do
    Foxkit.reset!
  end

  after do
    Foxkit.reset!
  end

  it "sets defaults" do
    Foxkit::Configurable.keys.each do |key|
      expect(Foxkit.instance_variable_get(:"@#{key}")).to eq(Foxkit::Default.send(key))
    end
  end

  describe ".client" do
    it "create a Foxkit::Client" do
      expect(Foxkit.client).to be_kind_of Foxkit::Client
    end

    it "caches the client when the same options are passed" do
      expect(Foxkit.client).to eq(Foxkit.client)
    end
  end

  describe ".configure" do
    Foxkit::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Foxkit.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Foxkit.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end
end
