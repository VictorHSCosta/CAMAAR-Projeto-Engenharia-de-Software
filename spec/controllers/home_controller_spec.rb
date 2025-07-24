require 'rails_helper'

RSpec.describe HomeController, type: :request do
  describe 'GET /home/index' do
    context 'in test environment' do
      it 'returns a success response' do
        get home_index_path
        expect(response).to be_successful
      end

      it 'renders the index template' do
        get home_index_path
        expect(response).to render_template(:index)
      end

      it 'assigns @current_user' do
        get home_index_path
        expect(assigns(:current_user)).to be_present
      end
    end

    context 'with different user types' do
      let(:admin_user) { create(:user, role: :admin) }
      let(:aluno_user) { create(:user, role: :aluno) }
      let(:professor_user) { create(:user, role: :professor) }

      it 'works with admin user' do
        get home_index_path
        expect(response).to be_successful
      end

      it 'works with aluno user' do
        get home_index_path
        expect(response).to be_successful
      end

      it 'works with professor user' do
        get home_index_path
        expect(response).to be_successful
      end
    end
  end
end
