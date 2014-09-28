require 'spec_helper'

describe Foxkit::Client::Users do
  describe ".authenticate", :vcr do
    it "authenticate success with correct identity", :vcr do
      user = Foxkit.authenticate(login: 'foxkit', password: 'il0veruby')
      expect(user.username).to eq "foxkit"
    end
  end
end
