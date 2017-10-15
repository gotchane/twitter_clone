require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  describe 'valid tweet model' do
    it "is valid" do
      tweet = user.tweets.create(:tweet_text => 'test', :user_id => user.id)
      expect(tweet).to be_valid
    end
  end
  describe 'invalid tweet model' do
    it "is invalid over 140 letters" do
      tweet = user.tweets.create(:tweet_text => 'a' * 141, :user_id => user.id)
      expect(tweet.errors[:tweet_text]).to include("is too long (maximum is 140 characters)")
    end
    it "is invalid when tweet is empty" do
      tweet = user.tweets.create(:tweet_text => nil, :user_id => user.id)
      expect(tweet.errors[:tweet_text]).to include("can't be blank")
    end
  end
end
