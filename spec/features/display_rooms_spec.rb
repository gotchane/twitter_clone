require 'rails_helper'

RSpec.feature 'Display rooms', type: :feature do
  context "as logged in user" do
    scenario "display rooms list" do
      bob = create(:user, name: "Bob")
      alice = create(:user, name: "Alice")
      carol = create(:user, name: "Carol")
      room_first = create(:room, create_user_id: bob.id,
                                  user_ids:[bob.id,alice.id])
      room_second = create(:room, create_user_id: bob.id,
                                  user_ids:[bob.id,alice.id,carol.id])
      msg_bob_first_room = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice_first_room = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      msg_bob_second_room = create(:message, room: bob.rooms.second, user: bob, body:"2nd_bob")
      msg_alice_second_room = create(:message, room: bob.rooms.second, user: alice, body:"2nd_alice")
      msg_carol_second_room = create(:message, room: bob.rooms.second, user: carol, body:"2nd_carol")
      login_as(bob)
      visit root_path
      click_link "Message"
      expect(page).to have_selector "h1", text: "Direct Messages"
      expect(page).to have_selector ".rooms-button", text: "Create Message"
      expect(page).to have_css(".rooms__item__avater")
      expect(page).to have_selector ".rooms__item__box__user", text: "Bob / Alice"
      expect(page).to have_selector ".rooms__item__box__msg", text: "1st_alice"
      expect(page).to have_selector ".rooms__item__box__user", text: "Bob / Alice / Carol"
      expect(page).to have_selector ".rooms__item__box__msg", text: "2nd_carol"
    end
  end

  context "as not logged in user" do
    scenario "redirect to login page" do
      user = create(:user)
      visit root_path
      expect(page).not_to have_content "Message"
      visit "/users/#{user.id}/rooms"
      expect(page).to have_content "Please log in."
    end
  end
end
