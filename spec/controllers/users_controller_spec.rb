require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    render_views
    it "links successfully" do
      expect(get: users_path).to route_to(controller: "users",action: "index")
      expect(response.status).to eq(200)
    end
    it "render template successfully" do
      get :index
    end
  end

  describe 'GET #new' do
    render_views
    it "links successfully" do
      expect(get: signup_path).to route_to(controller: "users",action: "new")
      expect(response.status).to eq(200)
    end

    it "render template successfully" do
      get :new
      expect(response.body).to include('Name')
      expect(response.body).to include('Email')
      expect(response.body).to include('Password')
      expect(response.body).to include('Password Confirmation')
      expect(response.body).to include('Create my account')
      expect(response.body).to include('Back')
    end
  end
end
