require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it "links successfully" do
      expect(get: signup_path).to route_to(controller: "users",action: "new")
      expect(response.status).to eq(200)
    end
  end
end
