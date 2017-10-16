require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let!(:bob) { FactoryGirl.create(:user,:bob) }
  let!(:alice) { FactoryGirl.create(:user,:alice) }
  let!(:carol) { FactoryGirl.create(:user,:carol) }
  let!(:first_room) { FactoryGirl.create(:room) }
  let!(:second_room) { FactoryGirl.create(:room) }
  let!(:first_room_bob) { FactoryGirl.create(:user_room, :first_room_bob) }
  let!(:first_room_alice) { FactoryGirl.create(:user_room, :first_room_alice) }
  let!(:second_room_bob) { FactoryGirl.create(:user_room, :second_room_bob) }
  let!(:second_room_carol) { FactoryGirl.create(:user_room, :second_room_carol) }
  describe 'GET #index' do
    it "populates an array of all rooms related to current user" do
      #get :index
      #expect(assigns(:rooms)).to match_array([first_room,second_room])
    end
    it "renders the :index template"
  end
end
