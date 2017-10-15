require 'rails_helper'

RSpec.describe Room, type: :model do
  let!(:room) { FactoryGirl.build(:room) }
  describe 'table association' do
    it { should have_many(:messages) }
  end
  describe 'valid room model' do
    it "is valid" do
      room.save
      expect(room).to be_valid
    end
  end
  describe 'invalid room model' do
    it "is invalid when create_user_id is blank" do
      room.create_user_id = nil
      room.valid?
      expect(room.errors[:create_user_id]).to include("can't be blank")
    end
  end
end
