require 'rails_helper'

RSpec.feature 'Display rooms', type: :feature do
  context "as logged in user" do
    scenario "display rooms list" do
      user =  FactoryGirl.create(:user)
      login_as(user)
      visit root_path
      click_link "Message"
      expect(page).to have_selector "h1", text: "Direct Messages"
      expect(page).to have_selector("ul li")
    end
    scenario "change background color of rooms with unread"
  end

  context "as not logged in user" do
    scenario "redirect to login page"
  end
end
