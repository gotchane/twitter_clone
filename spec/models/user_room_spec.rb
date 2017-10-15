require 'rails_helper'

RSpec.describe UserRoom, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:room) { FactoryGirl.create(:room) }
  let!(:user_room) { FactoryGirl.build(:user_room) }
  describe 'table association' do
    it { should belong_to(:room) }
    it { should belong_to(:user) }
  end
  describe 'valid user_room model' do
    it "is valid" do
      user_room.save!
      expect(user_room).to be_valid
    end
  end
  describe 'invalid user_room model' do
    it "is invalid when user_id is blank" do
      user_room.user_id = nil
      user_room.valid?
      expect(user_room.errors[:user_id]).to include("can't be blank")
    end
    it "is invalid when user model is not existed" do
      expect do
        user_room.user_id = 9999
        user_room.save!
      end.to raise_error( ActiveRecord::RecordInvalid )
    end
    it "is invalid when room_id is blank" do
      user_room.room_id = nil
      user_room.valid?
      expect(user_room.errors[:room_id]).to include("can't be blank")
    end
    it "is invalid when room model is not existed" do
      expect do
        user_room.room_id = 9999
        user_room.save!
      end.to raise_error( ActiveRecord::RecordInvalid )
    end
    it "is invalid when combo of user_id and room_id is not unique" do
      user_room.save!
      user_room.dup.valid?
      is_expected.to validate_uniqueness_of(:room_id).scoped_to(:user_id)
    end
  end
end
