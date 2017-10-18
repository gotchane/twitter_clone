require 'rails_helper'

RSpec.feature 'tweet', type: :feature do
  let!(:user) { FactoryGirl.create(:user) }
  scenario 'login and logout by valid user' do
    login_as(user)
    fill_in "Tweet text", :with => "This is a tweet test."
    attach_file "Image", "test/fixtures/files/test.jpg"
    click_button "Tweet"
  end
end
