require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:invitee) { create(:user) }
  let!(:invitee_2nd) { create(:user) }
  let!(:room) { create(:room, create_user_id: user.id,
                              user_ids:[user.id,invitee.id]) }
  before { session[:user_id] = user.id }
  describe 'GET #index' do
    it "populates an array of all rooms related to current user" do
      get :index, params: { user_id: user.id }
      expect(assigns(:rooms)).to match_array(user.rooms)
    end
    it "populates an array of rooms without unavailable" do
      user.rooms.first.user_rooms.first.available_flag = false
      get :index, params: { user_id: user.id }
      expect(assigns(:rooms).count).to eq(1)
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
          room: {
            create_user_id: user.id,
            user_ids: [invitee_2nd.id]
          }
        }
      }.to change(Room, :count).by(1)
    end
    it "saves new user_room in the database" do
      expect{
        post :create,
        params: {
          user_id: user.id,
          room: {
            create_user_id: user.id,
            user_ids: [invitee_2nd.id]
          }
        }
      }.to change(UserRoom, :count).by(2)
    end
    it "redirect to the :show template" do
      post :create,
      params: {
        user_id: user.id,
        room: {
          create_user_id: user.id,
          user_ids: [invitee_2nd.id]
        }
      }
      expect(response).to redirect_to user_room_path(user, Room.find(2))
    end
    it "redirect to the :new template when creating dup room" do
      post :create,
      params: {
        user_id: user.id,
        room: {
          create_user_id: user.id,
          user_ids: [invitee.id]
        }
      }
      expect(response).to render_template :new
    end
    it "redirect to the :new template when user_room_params is nil" do
      post :create,
      params: {
        user_id: user.id,
        room: {
          create_user_id: user.id
        }
      }
      expect(response).to render_template :new
    end
  end
  describe 'GET #show' do
    it "populates a room of current user" do
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:room)).to eq(user.rooms.first)
    end
    it "populates messages of room" do
      msg = create(:message, room: user.rooms.first, user: user, body:"test")
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:messages)).to match_array([msg])
    end
    it "assigns new Room to @room" do
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(assigns(:message_post)).to be_a_new(Message)
    end
    it "renders the :show template" do
      get :show, params: { user_id: user.id, id: user.rooms.first.id }
      expect(response).to render_template :show
    end
  end
  describe 'DELETE #destroy' do
    it "redirects user_room_path" do
      delete :destroy, params: { user_id: user.id, id: user.rooms.first.id }
      expect(response).to redirect_to user_rooms_path(user)
    end
  end
end
