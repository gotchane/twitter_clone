require 'rails_helper'

RSpec.feature 'Manage messages', type: :feature do
  given!(:bob) { create(:user, name: "Bob") }
  given!(:alice) { create(:user, name: "Alice") }
  given!(:room) { create(:room, create_user: bob, users:[bob,alice]) }
  context "as logged in user" do
    scenario "show messages page", js: true do
      msg_bob = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Bob / Alice"
      expect(page).to have_selector "h1", text: "Messages of Bob / Alice"
      expect(page).to have_css(".room-messages__item__avater")
      expect(page).to have_selector ".room-messages__item__box__user", text: "Bob"
      expect(page).to have_selector ".room-messages__item__box__user", text: "Alice"
      expect(page).to have_selector ".room-messages__item__box__msg", text: "1st_bob"
      expect(page).to have_selector ".room-messages__item__box__msg", text: "1st_alice"
    end
    scenario "post a message successfully", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: 'new bob message.'
      click_button "Post"
      expect(page).to have_selector ".room-messages__item__box__user", text: "Bob"
      expect(page).to have_selector ".room-messages__item__box__msg", text: "new bob message."
    end
    scenario "display messages posted to the room by others" do
      login_as(alice)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: "new alice message."
      click_button "Post"
      click_link "Log out"
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      expect(page).to have_selector ".room-messages__item__box__msg", text: "new alice message."
    end
    scenario "remains unread message of mine unless others read", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: 'new bob message.'
      click_button "Post"
      expect(page).to have_selector ".room-messages__item__box__read", text: "Unread"
    end
    scenario "change message already read after others read", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: 'new bob message.'
      click_button "Post"
      click_link "Log out"
      login_as(alice)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: 'new alice message.'
      click_button "Post"
      click_link "Log out"
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      expect(page).to have_selector ".room-messages__item__box__read", text: "Read"
    end
    scenario "delete a message successfully", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: 'new bob message.'
      click_button "Post"
      page.accept_confirm 'Are you sure?' do
        click_link "delete"
      end
      expect(page).not_to have_selector ".room-messages__item__box__msg", text: "new bob message."
    end
    scenario "delete message history of room successfully", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      page.accept_confirm 'Are you sure?' do
        click_link "Delete messages history"
      end
      expect(page).not_to have_selector ".rooms__item__box__user", text: "Bob / Alice"
    end
    scenario "show messages posted after message history deletion when message history has deleted", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: '1st bob message.'
      click_button "Post"
      page.accept_confirm 'Are you sure?' do
        click_link "Delete messages history"
      end
      click_link "Log out"
      login_as(alice)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: '1st alice message.'
      click_button "Post"
      click_link "Log out"
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      expect(page).not_to have_selector ".room-messages__item__box__msg", text: "1st bob message."
      expect(page).to have_selector ".room-messages__item__box__msg", text: "1st alice message."
    end
  end
  context "as not logged in user" do
    scenario "redirect to login page" do
      visit root_path
      visit "/users/#{bob.id}/rooms/#{bob.rooms.first.id}"
      expect(page).to have_content "Please log in."
    end
  end
end
