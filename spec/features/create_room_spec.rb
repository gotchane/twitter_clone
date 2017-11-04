require 'rails_helper'

RSpec.feature 'Create room', type: :feature do
  given!(:bob) { create(:user, name: "Bob") }
  given!(:alice) { create(:user, name: "Alice") }
  given!(:carol) { create(:user, name: "Carol") }

  context "as logged in user" do
    scenario "display create message form" do
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      expect(page).to have_selector "h1", text: "Create Message"
      expect(page).to have_button "Next"
      expect(page).not_to have_field("Bob")
      expect(page).to have_field("Alice")
      expect(page).to have_field("Carol")
    end
    scenario "create a message room successfully" do
      login_as(bob)
      click_link "Message"
      click_link "Create Message"
      check "Alice"
      click_button "Next"
      expect(page).to have_selector "h1", text: "Messages of Alice / Bob"
    end
    scenario "cannot create a room with no participants" do
      login_as(bob)
      click_link "Message"
      click_link "Create Message"
      click_button "Next"
      expect(page).to have_content "No one is selected as room participant."
    end
    scenario "cannot create a room with dup participants combination" do
      login_as(bob)
      2.times do
        click_link "Message"
        click_link "Create Message"
        check "Alice"
        click_button "Next"
      end
      expect(page).to have_content "Participant combination is overlapped."
    end
    scenario "rejoin the room of same participants after deletion of message history", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Create Message"
      check "Alice"
      click_button "Next"
      page.accept_confirm 'Are you sure?' do
        click_link "Delete messages history"
      end
      click_link "Create Message"
      check "Alice"
      click_button "Next"
      expect(page).to have_selector "h1", text: "Messages of Alice / Bob"
    end
  end
  context "as not logged in user" do
    scenario "redirect to login page" do
      user = create(:user)
      visit root_path
      visit "/users/#{user.id}/rooms/new"
      expect(page).to have_content "Please log in."
    end
  end
end
