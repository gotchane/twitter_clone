require 'rails_helper'

RSpec.feature 'Display rooms', type: :feature do
  given!(:bob) { create(:user, name: "Bob") }
  given!(:alice) { create(:user, name: "Alice") }
  given!(:carol) { create(:user, name: "Carol") }

  context "as logged in user" do
    scenario "display rooms where current user participates" do
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
    scenario "do not display rooms where current user does not participate"
    scenario "change backgroud color of room with unread messages"
    scenario "redisplay the room where message history was deleted after other user post a message"
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
