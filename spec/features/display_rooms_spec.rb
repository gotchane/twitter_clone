require 'rails_helper'

RSpec.feature 'Display rooms', type: :feature do
  context "as logged in user" do
    scenario "display rooms list" do
      bob = FactoryGirl.create(:user, :bob)
      alice = FactoryGirl.create(:user, :alice)
      carol = FactoryGirl.create(:user, :carol)
      first_room = FactoryGirl.create(:room)
      second_room = FactoryGirl.create(:room)
      first_room_bob = FactoryGirl.create(:user_room, :first_room_bob)
      first_room_alice = FactoryGirl.create(:user_room, :first_room_alice)
      second_room_bob = FactoryGirl.create(:user_room, :second_room_bob)
      second_room_alice = FactoryGirl.create(:user_room, :second_room_alice)
      second_room_carol = FactoryGirl.create(:user_room, :second_room_carol)
      msg_bob_to_first_room = FactoryGirl.create(:message, room_id: first_room.id, user_id: bob.id, body:"1st_bob")
      msg_alice_to_first_room = FactoryGirl.create(:message, room_id: first_room.id, user_id: alice.id, body:"1st_alice")
      msg_bob_to_second_room = FactoryGirl.create(:message, room_id: second_room.id, user_id: bob.id, body:"2nd_bob")
      msg_alice_to_second_room = FactoryGirl.create(:message, room_id: second_room.id, user_id: alice.id, body:"2nd_alice")
      msg_carol_to_second_room = FactoryGirl.create(:message, room_id: second_room.id, user_id: carol.id, body:"2nd_carol")
      login_as(bob)
      visit root_path
      click_link "Message"
      expect(page).to have_selector "h1", text: "Direct Messages"
      expect(page).to have_css("img.rooms__item__avater")
      expect(page).to have_selector(".rooms__item__name"), text: alice.name
      expect(page).to have_selector(".rooms__item__img"), text: msg_alice_to_first_room[0,5]
      expect(page).to have_css("img.rooms__item__avater")
      expect(page).to have_selector(".rooms__item__name"), text: carol.name
      expect(page).to have_selector(".rooms__item__msg"), text: msg_carol_to_first_room[0,5]
    end
    scenario "change background color of rooms with unread"
  end

  context "as not logged in user" do
    scenario "redirect to login page" do
      user = FactoryGirl.create(:user)
      visit root_path
      expect(page).not_to have_content "Message"
      visit "/users/#{user.id}/rooms"
      expect(page).to have_content "Please log in."
    end
  end
end
