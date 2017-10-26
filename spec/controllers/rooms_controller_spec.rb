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
    it "populates an array of rooms without unavailable" do
      user.rooms << create_list(:room, 2, create_user_id: user.id)
      user.rooms.first.user_rooms.first.available_flag = false
      get :index, params: { user_id: user.id }
      expect(assigns(:rooms).count).to eq(2)
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
          room: {user_room: {user_id: [invitee.id] }}
        }
      }.to change(Room, :count).by(1)
    end
    it "saves new user_room in the database" do
      expect{
        post :create,
        params: {
          user_id: user.id,
          room: {user_room: {user_id: [invitee.id] }}
        }
      }.to change(UserRoom, :count).by(2)
    end
    it "redirect to the :show template" do
      post :create,
      params: {
        user_id: user.id,
        room: {user_room: {user_id: [invitee.id] }}
      }
      expect(response).to redirect_to user_room_path(user, Room.find_by(create_user_id: user.id))
    end
    it "redirect to the :new template when creating dup room" do
      user.rooms << create(:room, create_user_id: user.id)
      user_room_invitee = create(:user_room, user: invitee, room: user.rooms.first)
      post :create,
      params: {
        user_id: user.id,
        room: {user_room: {user_id: [invitee.id] }}
      }
      expect(response).to redirect_to new_user_room_path(user)
    end
    it "redirect to the :new template when user_room_params is nil" do
      post :create,
      params: {
        user_id: user.id
      }
      expect(response).to redirect_to new_user_room_path(user)
    end
  end
  describe 'GET #show' do
    it "populates a room of current user" do
      user.rooms << create(:room, create_user_id: user.id)
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:room)).to eq(user.rooms.first)
    end
    it "populates relations between users and a room" do
      user.rooms << create(:room, create_user_id: user.id)
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:user_room)).to eq(user.rooms.first.user_rooms.first)
    end
    it "populates messages of room" do
      user.rooms << create(:room, create_user_id: user.id)
      msg = create(:message, room: user.rooms.first, user: user, body:"test")
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:messages)).to match_array([msg])
    end
    it "assigns new Room to @room" do
      user.rooms << create(:room, create_user_id: user.id)
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:message_post)).to be_a_new(Message)
    end
    it "renders the :show template" do
      user.rooms << create(:room, create_user_id: user.id)
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(response).to render_template :show
    end
  end
  describe 'GET #mark_read' do
    it "populates a room of current user" do
      user.rooms << create(:room, create_user_id: user.id)
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:room)).to eq(user.rooms.first)
    end
    it "populates a room of current user" do
      user.rooms << create(:room, create_user_id: user.id)
      user_room = UserRoom.where("user_id = ? and room_id = ?", user.id, user.rooms.first.id)
      user.rooms.first.messages << create_list(:message, 2, room: user.rooms.first, user: user, body:"test")
      get :mark_read, params: { user_id: user.id, id: user.rooms.first.id }
      expect(user_room.first.latest_read_message_id).to eq(user.rooms.first.messages.last.id)
    end
    it "renders json" do
      user.rooms << create(:room, create_user_id: user.id)
      get :mark_read, params: { user_id: user.id, id: user.rooms.first.id }
      expect(response.status).to eq(200)
    end
  end
  describe 'DELETE #destroy' do
  end
end
