require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    it "links successfully" do
      expect(get: root_url).to route_to(controller: "static_pages",action: "home")
      expect(response.status).to eq(200)
    end
  end
end
