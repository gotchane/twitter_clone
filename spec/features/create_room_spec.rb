require 'rails_helper'

RSpec.feature 'Create room', type: :feature do
  context "as logged in user" do
    scenario "display create message form" do
      bob = create(:user, name: "Bob")
      alice = create(:user, name: "Alice")
      carol = create(:user, name: "Carol")
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      expect(page).to have_selector "h1", text: "Create Message"
      expect(page).to have_selector ".rooms-button", text: "Next"
      expect(page).to have_checked_field("Bob")
      expect(page).to have_checked_field("Alice")
      expect(page).to have_checked_field("Carol")
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
