require 'rails_helper'

RSpec.describe Room, type: :model do
  let!(:room_valid) { FactoryGirl.create(:room, :valid) }
  let!(:room_invalid) { FactoryGirl.build(:room, :invalid) }
  describe 'valid room model' do
    it "is valid" do
      expect(room_valid).to be_valid
    end
  end
  describe 'invalid room model' do
    it "is invalid when name is blank" do
      room_invalid.valid?
      expect(room_invalid.errors[:create_user_id]).to include("can't be blank")
    end
  end
end
