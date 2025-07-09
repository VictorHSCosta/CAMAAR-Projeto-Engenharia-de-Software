require 'rails_helper'

RSpec.describe "Evaluations", type: :request do
  let(:user) { FactoryBot.create(:user) }
  
  before do
    # Simula usuário logado
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
  end
  
  describe "GET /index" do
    it "returns http success" do
      get "/evaluations"
      expect(response).to have_http_status(:success)
    end
  end
end
