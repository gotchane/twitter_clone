require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:room) { FactoryGirl.create(:room) }
  let!(:message) { FactoryGirl.build(:message) }
  describe 'table association' do
    it { should belong_to(:room) }
    it { should belong_to(:user) }
  end
  describe 'valid message model' do
    it "is valid" do
      message.save!
      expect(message).to be_valid
    end
  end
  describe 'invalid message model' do
    it "is invalid when body is blank" do
      message.body = nil
      message.valid?
      expect(message.errors[:body]).to include("can't be blank")
    end
    it "is invalid when number of chars is over maximum" do
      message.body = 'a' * 501
      message.valid?
      expect(message.errors[:body]).to include("is too long (maximum is 500 characters)")
    end
    it "is invalid when user_id is blank" do
      message.user_id = nil
      message.valid?
      expect(message.errors[:user_id]).to include("can't be blank")
    end
    it "is invalid when room_id is blank" do
      message.room_id = nil
      message.valid?
      expect(message.errors[:room_id]).to include("can't be blank")
    end
    it "is invalid when room model is not existed" do
      expect do
        message.room_id = 9999
        message.save!
      end.to raise_error( ActiveRecord::RecordInvalid )
    end
  end
end
