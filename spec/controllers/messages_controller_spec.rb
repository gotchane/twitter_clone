require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:invitee) { create(:user) }
  let!(:room) { create(:room, create_user_id: user.id,
                              user_ids:[user.id,invitee.id]) }
  before { session[:user_id] = user.id }
  describe 'GET #mark_read' do
    it "shows latest message" do
      user_room = UserRoom.where("user_id = ? and room_id = ?", user.id, user.rooms.first.id)
      user.rooms.first.messages << create_list(:message, 2, room: user.rooms.first,
                                                            user: user,
                                                            body:"test")
      get :mark_read, params: { user_id: user.id, room_id: user.rooms.first.id }
      expect(user_room.first.latest_read_message_id).to eq(user.rooms.first.messages.last.id)
    end
    it "renders json" do
      msg = create(:message, room: user.rooms.first, user: user, body:"test")
      get :mark_read, params: { user_id: user.id, room_id: user.rooms.first.id }
      expect(response.status).to eq(200)
    end
  end
end
