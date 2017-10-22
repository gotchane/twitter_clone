require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:invitee) { create(:user) }
  before { session[:user_id] = user.id }
  describe 'GET #index' do
    it "populates an array of all rooms related to current user" do
      user.rooms << create_list(:room, 2, create_user_id: user.id)
      get :index, params: { user_id: user.id }
      expect(assigns(:rooms)).to match_array(user.rooms)
    end
    it "renders the :index template" do
      get :index, params: { user_id: user.id }
      expect(response).to render_template :index
    end
  end
  describe 'GET #new' do
    it "assigns new Room to @room" do
      get :new, params: { user_id: user.id }
      expect(assigns(:room)).to be_a_new(Room)
    end
    it "renders the :new template" do
      get :new, params: { user_id: user.id }
      expect(response).to render_template :new
    end
  end
  describe 'POST #create' do
    it "saves new room in the database" do
      expect{
        post :create,
        params: {
          user_id: user.id,
          room: {room: {user_ids: [invitee.id] }}
        }
      }.to change(Room, :count).by(1)
    end
    it "saves new user_room in the database" do
      expect{
        post :create,
        params: {
          user_id: user.id,
          room: {room: {user_ids: [invitee.id] }}
        }
      }.to change(UserRoom, :count).by(2)
    end
    it "redirect to the :show template" do
      post :create,
      params: {
        user_id: user.id,
        room: {room: {user_ids: [invitee.id] }}
      }
      expect(response).to redirect_to user_room_path(user, Room.find_by(create_user_id: user.id))
    end
  end
end
