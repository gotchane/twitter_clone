require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'valid tweet model' do
    it "is valid" do
      user = FactoryGirl.create(:user, :name_example)
      tweet = user.tweets.create(:tweet_text => 'test', :user_id => user.id)
      expect(tweet).to be_valid
    end
  end
  describe 'invalid tweet model' do
    it "is invalid over 140 letters" do
      user = FactoryGirl.create(:user, :name_example)
      tweet = user.tweets.create(:tweet_text => 'a' * 141, :user_id => user.id)
      expect(tweet.errors[:tweet_text]).to include("is too long (maximum is 140 characters)")
    end
    it "is invalid when tweet is empty" do
      user = FactoryGirl.create(:user, :name_example)
      tweet = user.tweets.create(:tweet_text => nil, :user_id => user.id)
      expect(tweet.errors[:tweet_text]).to include("can't be blank")
    end
  end
end
