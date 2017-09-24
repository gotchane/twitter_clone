require 'rails_helper'

RSpec.feature 'tweet', type: :feature do
  scenario 'login and logout by valid user' do
    # Log in
    visit login_path
    user = FactoryGirl.create(:user, :name_example)
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
    # Tweet
    fill_in "Tweet text", :with => "This is a tweet test."
    attach_file "Image", "test/fixtures/files/test.jpg"
    click_button "Tweet"
  end
end
