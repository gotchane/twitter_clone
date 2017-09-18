require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid user model' do
    it "is valid" do
      user = FactoryGirl.create(:user, :name_example)
      expect(user).to be_valid
    end
    it "is valid when email is valid format" do
      user = FactoryGirl.create(:user, :name_example)
      valid_addresses = %w[user@example.com USER@mmm.COM A_jp-user@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
  end
  describe 'invalid user model' do
    it "is invalid when name is blank" do
      user = FactoryGirl.build(:user, :name_none)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end
    it "is invalid when email is not unique" do
      user = FactoryGirl.create(:user, :name_example)
      user.save
      user.dup.valid?
      is_expected.to validate_uniqueness_of(:email)
    end
    it "is invalid when email char num is over maximum" do
      user = FactoryGirl.build(:user, :over_max_email)
      user.valid?
      expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end
    it "is invalid when email is invalid format" do
      user = FactoryGirl.create(:user, :name_example)
      invalid_addresses = %w[user@example,com USERmmmCOM A_jp,user@foo.bar.org
                         first.last@foo..jp alice+,bob@baz:cn]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end
    end
    it "is invalid when password is blank" do
      user = FactoryGirl.build(:user, :name_example)
      user.password = user.password_confirmation = " " * 6
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end
    it "is invalid when password is under minimum length" do
      user = FactoryGirl.build(:user, :name_example)
      user.password = user.password_confirmation = "a" * 5
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
end
