require 'rails_helper'

RSpec.feature 'Manage messages', type: :feature do
  given!(:bob) { create(:user, name: "Bob") }
  given!(:alice) { create(:user, name: "Alice") }

  context "as logged in user" do
    scenario "show messages page" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      expect(page).to have_selector "h1", text: "Messages of Bob / Alice"
      expect(page).to have_css(".room-messages__item__avater")
      expect(page).to have_selector ".room-messages__item__box__user", text: "Bob"
      expect(page).to have_selector ".room-messages__item__box__user", text: "Alice"
      expect(page).to have_selector ".room-messages__item__box__msg", text: "1st_bob"
      expect(page).to have_selector ".room-messages__item__box__msg", text: "1st_alice"
    end
    scenario "post a message successfully"
    scenario "fail to post an empty message"
    scenario "fail to post a message over 500 chars"
    scenario "display messages posted to the room by others"
    scenario "remains unread message of mine until others read"
    scenario "change message already read after others read"
    scenario "display delete link only messages of mine"
    scenario "delete a message successfully"
    scenario "delete message history of room successfully"
    scenario "show only messages posted after message history deletion when message history has deleted"
  end
  context "as not logged in user" do
    scenario "redirect to login page" do
      bob = create(:user, name: "Bob")
      alice = create(:user, name: "Alice")
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      visit root_path
      visit "/users/#{bob.id}/rooms/#{bob.rooms.first.id}"
      expect(page).to have_content "Please log in."
    end
  end
end
