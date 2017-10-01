require 'rails_helper'

RSpec.feature 'Log in', type: :feature do
  scenario 'login and logout by valid user' do
    # Log in
    visit login_path
    user = FactoryGirl.create(:user, :name_example)
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
    expect(page).to have_content 'Tweets'
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.profile)
    expect(page).not_to have_content 'Log in'
    expect(page).to have_content 'Log out'
    # Log out
    click_link "Log out"
    expect(page).to have_content 'Welcome to Twitter Clone'
    expect(page).not_to have_content 'Log out'
    expect(page).to have_content 'Log in'
  end
end
