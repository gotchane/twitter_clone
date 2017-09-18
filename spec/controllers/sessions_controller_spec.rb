require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    render_views
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "render template successfully" do
      get :new
      expect(response.body).to include('Email')
      expect(response.body).to include('Password')
      expect(response.body).to include('Log in')
      expect(response.body).to include('Sign up')
      expect(response.body).to include('Back')
    end
  end
end
