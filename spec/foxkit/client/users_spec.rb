require 'spec_helper'

describe Foxkit::Client::Users do

  before(:each) do
    Foxkit.reset!
    @client = token_auth_client
  end

  describe ".all_users", :vcr do
    it "returns all GitLab users" do
      users = @client.all_users
      expect(users).to be_kind_of Array
    end
  end # .all_users

  describe ".user", :vcr do
    it "returns a user" do
      user = @client.user(56022)
      expect(user.username).to eq('foxkit')
    end

    it "returns the authenticated user" do
      user = @client.user
      expect(user.username).to eq("foxkit")
    end
  end # .user

  describe ".create_user", :vcr do
   it "create a new user" do
      expect do
        @client.create_user(email: 'a@b.com')
      end.to raise_error Foxkit::Forbidden
    end
  end

  describe ".update_user", :vcr do
    it "update a user" do
      expect do
        @client.update_user(1)
      end.to raise_error Foxkit::Forbidden
    end
  end

  describe ".delete_user", :vcr do
    it "delete a user" do
      expect do
        @client.delete_user(1)
      end.to raise_error Foxkit::Forbidden
    end
  end

  describe ".user_keys", :vcr do
    it "list current authenticated user's SSH keys" do
      keys = @client.user_keys
      expect(keys).to be_kind_of Array
    end
  end

  describe ".key", :vcr do
    it "get a single SSH key" do
      key = @client.key(52074)
      expect(key.title).to eq "fake_ssh_key"
    end
  end

  describe ".add_user_key", :vcr do
    it "add keys for authenticated user" do
      @client.add_key(
        title: "Public key",
        key: "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAiPWx6WM4lhHNedGfBpPJNPpZ7yKu+dnn1SJejgt4596k6YjzGGphH2TUxwKzxcKDKKezwkpfnxPkSMkuEspGRt/aZZ9wa++Oi7Qkr8prgHc4soW6NUlfDzpvZK2H5E7eQaSeP3SAwGmQKUFHCddNaP0L+hM7zhFNzjFvpaMgJw0="
      )
      key = @client.user_keys.first
      expect(key.title).to eq "Public key"

      # cleanup
      begin
        @client.delete_key(key.id)
      rescue Foxkit::NotFound
      end
    end
  end

  describe ".delete_user_key", :vcr do
    it "try to delete SSH key for a given user" do
      expect do
        @client.delete_user_key(1, 1)
      end.to raise_error Foxkit::Forbidden
    end
  end

end
