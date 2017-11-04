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
    scenario "post a message successfully" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: post message successfully
    end
    scenario "fail to post an empty message" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: create empty message and render new
    end
    scenario "fail to post a message over 500 chars" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: create over 500 chars message and render new
    end
    scenario "display messages posted to the room by others" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: post message successfully
    end
    scenario "remains unread message of mine until others read" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: message state is unread
    end
    scenario "change message already read after others read" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: message state changes read
    end
    scenario "display delete link only messages of mine" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: show delete link
    end
    scenario "delete a message successfully" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: delete successfully
    end
    scenario "delete message history of room successfully" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: delete message history successfully
    end
    scenario "show only messages posted after message history deletion when message history has deleted" do
      room_first = create(:room, create_user_id: bob.id,
                                 user_ids:[bob.id,alice.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      visit user_room_path(bob,bob.rooms.first)
      # TODO: delete message history successfully
    end
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
