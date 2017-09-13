require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid user model' do
    it "is valid" do
      user = FactoryGirl.create(:user, :name_example)
      expect(user).to be_valid
    end
  end
  describe 'unvalid user model' do
    it "is not valid when name is blank" do
      user = FactoryGirl.build(:user, :name_none)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end
    it "is not valid when email is not unique" do
      user = FactoryGirl.create(:user, :name_example)
      user.save
      user.dup.valid?
      is_expected.to validate_uniqueness_of(:email)
    end
    it "is not valid when password is blank" do
      user = FactoryGirl.build(:user, :name_example)
      user.password = user.password_confirmation = " " * 6
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end
    it "is not valid when password is under minimum length" do
      user = FactoryGirl.build(:user, :name_example)
      user.password = user.password_confirmation = "a" * 5
      user.valid?
      #expect(user).to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
end
