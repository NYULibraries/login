require 'rails_helper'
require './config/env_git_branch.rb'


describe "#env_git_branch" do
  context 'when environment variable GIT_BRANCH is set' do
    before { allow(ENV).to receive(:[]).with("GIT_BRANCH").and_return("foo") }
    it "returns the value" do
      expect(env_git_branch).to eq("foo")
    end
  end

  context 'when environment variable GIT_BRANCH is not set' do
    before { allow(ENV).to receive(:[]).with("GIT_BRANCH").and_return(nil) }
    it "raises an ArgumentEror" do
      expect{env_git_branch}.to raise_error(ArgumentError)
    end
  end
end
