require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryGirl.create(:user, :name_example) }
  let!(:user_name_none) { FactoryGirl.build(:user, :name_none) }
  let!(:user_over_max_email) { FactoryGirl.build(:user, :over_max_email) }
  let!(:user_password_blank) { FactoryGirl.build(:user, :password_blank) }
  let!(:user_under_min_password) { FactoryGirl.build(:user, :under_min_password) }

  describe 'valid user model' do
    it "is valid" do
      expect(user).to be_valid
    end
    it "is valid when email is valid format" do
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
      user_name_none.valid?
      expect(user_name_none.errors[:name]).to include("can't be blank")
    end
    it "is invalid when email is not unique" do
      user.save
      user.dup.valid?
      is_expected.to validate_uniqueness_of(:email)
    end
    it "is invalid when email char num is over maximum" do
      user_over_max_email.valid?
      expect(user_over_max_email.errors[:email]).to include("is too long (maximum is 255 characters)")
    end
    it "is invalid when email is invalid format" do
      invalid_addresses = %w[user@example,com USERmmmCOM A_jp,user@foo.bar.org
                         first.last@foo..jp alice+,bob@baz:cn]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end
    end
    it "is invalid when password is blank" do
      user_password_blank.valid?
      expect(user_password_blank.errors[:password]).to include("can't be blank")
    end
    it "is invalid when password is under minimum length" do
      user_under_min_password.valid?
      expect(user_under_min_password.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
end
