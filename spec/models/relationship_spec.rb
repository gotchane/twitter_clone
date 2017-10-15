require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { FactoryGirl.build(:user) }
  let!(:relationship) { FactoryGirl.build(:relationship) }
  describe 'table association' do
    it { should belong_to(:follower) }
    it { should belong_to(:followed) }
  end
  describe 'valid' do
    it "can follow and unfollow" do
      followed_user = user
      followed_user.email = 'followed@example.com'
      user.save!
      followed_user.save!
      user.follow(followed_user)
      expect(user.following?(followed_user)).to be true
      user.unfollow(followed_user)
      expect(user.following?(followed_user)).to be false
    end
  end
end
