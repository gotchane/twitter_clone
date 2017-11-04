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
    scenario "create a message room successfully"
    scenario "display messages of room"
    scenario "cannot create a room with no participants"
    scenario "cannot create a room with dup participants combination"
    scenario "rejoin the room of same participants after deletion of message history"
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
