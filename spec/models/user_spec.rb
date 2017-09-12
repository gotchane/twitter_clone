require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid user model' do
    it "is valid" do
      user = FactoryGirl.create(:user)
      expect(user).to be_valid
    end
  end
  describe 'unvalid user model' do
    it "is not valid" do
      user = User.new(:name => nil )
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end
  end
end
