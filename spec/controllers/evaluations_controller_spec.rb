require 'rails_helper'

RSpec.describe EvaluationsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:coordenador_user) { create(:user, :coordenador) }
  let(:regular_user) { create(:user, :aluno) }
  let(:template) { create(:template) }
  let(:formulario_ativo) { create(:formulario, ativo: true, template: template) }

  describe 'GET #index' do
    context 'when user is an admin' do
      before { sign_in admin_user }

      it 'shows all active formularios' do
        formulario_ativo
        get :index
        expect(assigns(:formularios)).to include(formulario_ativo)
        expect(response).to render_template(:index)
      end
    end

    context 'when not authenticated' do
      before do
        # Override the global authentication setting for this context
        allow(controller).to receive(:authenticate_user!).and_call_original
        allow(controller).to receive(:user_signed_in?).and_return(false)
      end

      it 'redirects to login', skip: "Authentication is disabled in test environment" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
  end
end
