require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    render_views
    it "links successfully" do
      expect(get: root_url).to route_to(controller: "static_pages",action: "home")
      get :home
      expect(response).to render_template(:home)
      expect(response.body).to include('Welcome to Twitter Clone')
      expect(response.status).to eq(200)
    end
  end
end
